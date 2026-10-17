#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use File::Find qw(find);
use File::Basename qw(basename);
use JSON::PP;
use Encode qw(decode FB_DEFAULT);

# GitHub Pages cannot execute Perl at request time.
# This Perl program runs in GitHub Actions after files in photos/ change.
my $folder = 'photos';
my @pictures;

sub utf8_text {
  return decode('UTF-8', $_[0], FB_DEFAULT);
}

if (-d $folder) {
  find({
    no_chdir => 1,
    wanted => sub {
      my $file = $File::Find::name;
      return unless -f $file && !-l $file;
      return unless $file =~ /\.(?:jpe?g|png|gif|webp|avif)\z/i;

      $file =~ s!^\./!!;
      $file =~ s!\\!/!g;
      my $name = basename($file);
      $name =~ s/\.[^.]+\z//;
      $name =~ s/[_-]+/ /g;
      $name =~ s/^\s+|\s+$//g;
      my $relative = utf8_text($file);
      my $title = utf8_text($name);
      push @pictures, { src => $relative, title => $title };
    },
  }, $folder);
}

@pictures = sort { lc($a->{src}) cmp lc($b->{src}) } @pictures;
my $json = JSON::PP->new->canonical->pretty->utf8->encode({
  images => \@pictures,
});

open my $fh, '>:raw', 'gallery.json' or die "Cannot write gallery.json: $!";
print {$fh} $json;
close $fh or die "Cannot close gallery.json: $!";

printf "Updated gallery.json with %d photo(s).\n", scalar @pictures;
