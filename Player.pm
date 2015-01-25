# this is not the interface for tf2soundboard. this contains methods for playing the .wav files and searching for them

use strict;
use warnings;
use Win32::Sound;

package Player;

# it's important that we get the way to search for appropriate .wav file to play out of the way first
# the follow function needs a string to scan, so that it can determine how to best play a meaning

# this returns what to play
sub get_meaning {
	my $users_string = shift; # user's string part that contains their desire of what to play
	my $character_file = shift; # character's file to iterate over

	# .DATA section of this subroutine
	my @possible_matches; # to iterate over if there are multiple matches
	
	# the procedure to use will be seeing if there is a matching attribute at all in the directory of .wav files. if there isn't,
	# no .wav file will be selected (return -1). else, determine how many matches were found. if one, select that .wav file to play. if
	# there are multiple matches, a random one will be selected. this is a very simple implementation of the automated soundboard
	# idea.
	
	open (my $character_file_filehandle, "<", $character_file . ".txt") || die "Couldn't open '" . $character_file . ".txt" . "' for reading because: " . $!;
	
	while (my $line = <$character_file_filehandle>) {
		chomp $line;
		
		if (index(uc $line, uc $users_string) != -1) { # if the current line contains the user's string after the == attribute delimiter
			# get the .wav file on that line and put it in @possible_matches
			$line =~ /(.*)==/;
			push @possible_matches, $1;
		}
	}
	
	close ($character_file_filehandle);
	
	# now to determine what to do with the matches found
	
	my $one_meaning; # this will be the selected meaning
	
	if (scalar @possible_matches == 0) { # if none found return -1
		$one_meaning = -1;
	} elsif (scalar @possible_matches == 1) {
		$one_meaning = shift @possible_matches;
	} elsif (scalar @possible_matches > 1) {
		$one_meaning = $possible_matches[rand @possible_matches];
	}
	
	return $one_meaning;
}

# selects the wav file to play
sub play_wav { # PLEASE DON'T PASS -1 TO THIS OR THE DEFAULT SYSTEM SOUND WILL PLAY INSTEAD
	my $wav_file = shift;
	my $folder = shift;
	
	# use the SND_NODEFAULT flag to not play the default sound if a wav file could not be found
	sleep 2; # to give the user time to switch between windows
	Win32::Sound::Play(($folder . "\\" . $wav_file));
}

1; # end of module/to show that the module was loaded successfully
