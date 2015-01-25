use Tk;
use strict;
use warnings;

require Player;

# the GUI for the soundboard. the user interface. this will use Player's subroutines as it sees fit
# the layout that we want to use is creating an entry field, a text area, a button for the entry field,
# and a drop down menu for selecting the tf2 class character to play

my $mw = MainWindow->new;
$mw->title("TF2 Soundboard");

my $button_frame = $mw -> Frame();
my $button = $button_frame->Button(-text => "Begin", -command => \&do_Toplevel); # creates the toplevel for us to stay on top

$button_frame->pack;
$button->pack;

# let's take this opportunity to create the menu for selecting the user's character
# in fact, a radio button set would be easier to create

my $class = "demoman";

MainLoop;

# necessary to create a subroutine in the first place for staying on top. namely, to create a Toplevel instance
# as such, this will be the window with all that we'll work with
sub do_Toplevel {
    my $tl = $mw->Toplevel( );
    $tl->attributes(-topmost => 1);
    $tl->title("Toplevel");
	
	my $radio_frame = $tl -> Frame();
	my $radio_label = $radio_frame -> Label(-text=>"Class ");

	my $rdb_demoman = $radio_frame -> Radiobutton(-text=>"demoman",  
			-value=>"demoman",  -variable=>\$class);
	my $rdb_sniper = $radio_frame -> Radiobutton(-text=>"sniper",
			-value=>"sniper",-variable=>\$class);
	my $rdb_heavy = $radio_frame -> Radiobutton(-text=>"heavy",
			-value=>"heavy",-variable=>\$class);
	my $rdb_scout = $radio_frame -> Radiobutton(-text=>"scout",
			-value=>"scout",-variable=>\$class);
	my $rdb_spy = $radio_frame -> Radiobutton(-text=>"spy",
			-value=>"spy",-variable=>\$class);
	my $rdb_medic = $radio_frame -> Radiobutton(-text=>"medic",
			-value=>"medic",-variable=>\$class);
	my $rdb_soldier = $radio_frame -> Radiobutton(-text=>"soldier",
			-value=>"soldier",-variable=>\$class);
	my $rdb_engineer = $radio_frame -> Radiobutton(-text=>"engineer",
			-value=>"engineer",-variable=>\$class);
	my $rdb_pyro = $radio_frame -> Radiobutton(-text=>"pyro",
			-value=>"pyro",-variable=>\$class);				
			
	$radio_frame -> pack;		
	$radio_label -> pack(-side => 'left');

	$rdb_demoman -> pack;
	$rdb_sniper -> pack;
	$rdb_heavy -> pack;
	$rdb_scout -> pack;
	$rdb_spy -> pack;
	$rdb_medic -> pack;
	$rdb_soldier -> pack;
	$rdb_engineer -> pack;
	$rdb_pyro -> pack;
														   
	# the text field displays the results of the user's input
	my $text_field_frame = $tl -> Frame();
	my $text_field = $text_field_frame -> Text(-relief => 'sunken',
											   -height => 2,
											   -width => 40,
											   -wrap => 'word',
											   -takefocus => 0);
											   
	# creating an entry box and it's frame. speaking of frames, two frames will be in this toplevel:
	# one for the entry box and it's confirm button and a frame for the text field that displays output
											   
	my $entry_and_button_frame = $tl -> Frame();
	my $entry_widget = $entry_and_button_frame -> Entry(-relief => 'sunken',
														 -takefocus => 1);
	my $confirm_button = $entry_and_button_frame -> Button(-text => 'Confirm',
														   -command => [ \&process_users_input, $entry_widget, $text_field ]);
														   
	$text_field_frame->pack(-side => 'top');
	$text_field->pack;
	
	$entry_and_button_frame->pack(-side => 'bottom');
	$entry_widget->pack(-side => 'left');
	$confirm_button->pack(-side => 'right');
}

# receives the user's input and clears the entry widget
sub process_users_input {
	my $entry_widget = shift;
	my $text_field = shift;
	
	# clear the text area
	$text_field->delete('1.0', 'end');
	
	# now to process what was typed
	my $wav_file = Player::get_meaning($entry_widget->get(), $class);
	if ($wav_file eq "-1") {
		$text_field->insert('end', "No match was found. Try again.\n");
	} else {
		$text_field->insert('end', "Playing " . $wav_file. "\n");
		Player::play_wav($wav_file, $class);
	}
	
	# clear the entry field
	$entry_widget->delete('0','end');
}
