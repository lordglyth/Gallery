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


# GitHub's upload form has two caption fields:
#   Commit message      -> caption headline
#   Extended description -> caption text
# Read the latest commit affecting THIS image, not the gallery manifest commit.
# Checkout must use fetch-depth: 0 so git log can find older uploads.
sub git_caption_for {
  my ($path) = @_;
  my $bytes = '';

  if (open my $pipe, '-|', 'git', 'log', '-1', '--format=%B', '--', $path) {
    local $/;
    $bytes = <$pipe> // '';
    close $pipe;
  }

  my $message = utf8_text($bytes);
  $message =~ s/\r\n?/\n/g;
  $message =~ s/\A\s+//;
  $message =~ s/\s+\z//;

  my ($subject, $description) = split(/\n/, $message, 2);
  $subject //= '';
  $description //= '';
  $subject =~ s/^\s+|\s+$//g;
  $description =~ s/^\s+|\s+$//g;

  return ($subject, $description);
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
      my ($commit, $description) = git_caption_for($file);
      push @pictures, {
        src => $relative,
        title => $title,
        commit => $commit,
        description => $description,
      };
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
