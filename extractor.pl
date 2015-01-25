#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

# extractor.pm parses wiki.teamfortress2.com for response .wav files and classifies them based on dialogue
# LWP::Simple will be used to crawl the webpage for the files we're looking for

use LWP::Simple;

# print get("http://wiki.teamfortress.com/wiki/Demoman_responses");
# print getstore("http://wiki.teamfortress.com/wiki/Demoman_responses", "testhtml.txt"); # these are tests to get a feel for LWP::Simple

# we will use a similar procedure to parse for the regular expression that we're looking for
# open (my $filehandle, ">", "testhtml.txt");
# foreach my $line ( get("http://wiki.teamfortress.com/wiki/Demoman_responses") ) {
	# print $filehandle $line, "\n"; # this newline character is really the main reason why this loop was created in the first place
# }
# close ($filehandle);

# <a href="/w/images/a/a5/Demoman_thanks02.wav?t=20100625224106" class="internal" title="Demoman thanks02.wav">"Aye, thanks."</a> is the text we want to parse
# our method is to download the href path with http://wiki.teamfortress.com/wiki/Demoman_responses ($url_to_download_from) as the first part of that path
# before we save it, we will create a simple database .txt file that attributes the quoted string preceeding the last </a> to the .wav file being downloaded


#my $demo_url = "http://wiki.teamfortress.com/wiki/Demoman_responses";
#my $regex_pattern = qr/^<li>.*href.*\.wav/; # now to see if we can select matches of li beginners and href containers


sub filterAndDownload {
	my $url_to_download_from = shift @_;
	my $textfile_to_write_to = shift @_;
	my $folder_to_save_to = shift @_;
	
	open (my $filehandle, ">", $textfile_to_write_to) || die "Couldn't open '".$textfile_to_write_to."' for reading because: ".$!;
	foreach my $line ( split qr/\R/, get($url_to_download_from) ) { # since get returns as a single value, we create a list
		if ($line =~ /^<li>.*href.*\.wav/) {
			#print $filehandle $line, "\n";
			
			# search for the .wav file's download link
			$line =~ /.*href="(.*?)"/;
			my $download_link = "http://wiki.teamfortress.com" . $1;
			next if $download_link !~ /\.wav/;
			#print $filehandle $download_link, "\n";
			
			# here we must label the .wav file with its description before we download it
			$line =~ /.*\.wav">(.*?)<\/a>/;
			#print $filehandle $1, "\n";
			my $label = $1;
			# changing the url syntax to a regualr file for easier handling
			$download_link =~ /.*\/(.*?\.wav)/;
			my $wavfile = $1;
			print $filehandle $wavfile . "==" . $label, "\n"; 
			
			
			# now we can finally download the file
			getstore($download_link, $folder_to_save_to . "\\" . $wavfile);
			print "file ", $wavfile, " downloaded to ", $folder_to_save_to, "\n";
		} 
	}
	close ($filehandle);
	return;
}



my @classes = ("demoman", "sniper", "spy", "soldier", "pyro", "engineer", "heavy", "medic", "scout");


print "beginning to extract the .wav files...\n";
foreach my $class (@classes) {
	print "extracting for ", $class, "\n";
	filterAndDownload( "http://wiki.teamfortress.com/wiki/" . $class . "_responses", $class . ".txt", $class );
	print "extraction for ", $class, " is done\n";
}
print "finished everything...\n";
