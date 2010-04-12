#!/usr/bin/perl -w
# 
# Twitpicit
# Take a picture and send it to the Twitpic online service
#
# Nicolas Hennion (aka) Nicolargo
# 04/2010
#
# Ressources:
# http://shutter-project.org/faq-help/upload-to-flickr/
# http://www.commandlinefu.com/commands/view/2007/twitpic-upload-and-tweet
# http://www.drdobbs.com/web-development/184416069;jsessionid=T1ATQFXBRIQSRQE1GHPCKHWATMY32JVN?pgno=1#l10
# http://rtadlock.blogspot.com/2009/02/let-your-dog-twitter-with-twitpic-perl.html
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Library General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor Boston, MA 02110-1301,  USA
my $PRG_VERSION = "0.1";
my $PRG_NAME = "TwitPicIt";

# Librairies
use strict;
use Getopt::Std;
use LWP::UserAgent;
use HTTP::Request::Common;
use Gtk2 -init;

# Constants
my $twitpic_uploadAndPost_url = "http://twitpic.com/api/uploadAndPost";

# GTK variables
my $builder;
my $window;
my $image;
my $user;
my $password;
my $message;

# Others variables
my $picturefile;
my $twitteruser;
my $twitterpassword;
my $twittermessage;

# Programs argument management
my %opts = ();
getopts("hvi:m:u:p:", \%opts);
if ($opts{v}) {
    # Display the version
    print "$PRG_NAME $PRG_VERSION\n";
    exit(-1);
}
if ($opts{h}) {
    # Display the help
    print "$PRG_NAME $PRG_VERSION\n";
    print "Usage: ", $0," [options]\n";
    print " -h: Print the command line help\n";
    print " -v: Print the program version\n";
    print " -i file: Input picture (JPG, PNG, GIF...)\n";
    print " -m \"message\": Message posted with the picture\n";
    print " -u user: Twitter account user name\n";
    print " -p password: Twitter account password\n";    
    exit (-1);
}
# Get the input file name (image)
if ($opts{i}) {
    $picturefile = $opts{i};
}
# Message posted with the picture
if ($opts{m}) {
    $twittermessage = $opts{m};
}
# Get the Twitter account user name
if ($opts{u}) {
    $twitteruser = $opts{u};
}
# Get the Twitter account password
if ($opts{p}) {
    $twitterpassword = $opts{p};
}

# Load the main GTK interface 
$builder = Gtk2::Builder->new();
$builder->add_from_file("twitpicit.glade");
$window = $builder->get_object("window1");
$builder->connect_signals(undef);

if ($picturefile) {
	$image = $builder->get_object("image1");
	$image->set_from_file($picturefile);
}
if ($twittermessage) {
	$message = $builder->get_object("message");
	$message->set_text($twittermessage);
}
if ($twitteruser) {
	$user = $builder->get_object("user");
	$user->set_text($twitteruser);
}
if ($twitterpassword) {
	$password = $builder->get_object("password");
	$password->set_text($twitterpassword);
}

# Run the interface
$window->show();
$builder = undef;
Gtk2->main();

# End of the program
exit(1);

# FUNCTIONS
###########

# Action when the user click on the TwitIt button
sub gtk_twitit
{
	my $ua = LWP::UserAgent->new( env_proxy => 1,
				keep_alive => 1,
				timeout => 30 );
	my $ua_response = $ua->request( POST $twitpic_uploadAndPost_url,
						Content_Type => 'multipart/form-data',
						Content => [
							media => ["$picturefile"],
							username => $twitteruser,
							password => $twitterpassword,
							message => $twittermessage ] );
}

# Action when the user click on the Quit button
sub gtk_main_quit
{
    Gtk2->main_quit();
}

# Create the main window
#my $window = Gtk2::Window->new;
#$window->set_title($PRG_NAME);
#$window->signal_connect(destroy => sub { Gtk2->main_quit; });
#$window->set_border_width(3);

# Image preview
#my $image = Gtk2::Image->new_from_file('image.png');
#my $scrwin = Gtk2::ScrolledWindow->new;
#$window->add($scrwin);

#$scrwin->set_policy('automatic', 'automatic');
#$scrwin->add_with_viewport($image);

#$window->show_all;
#Gtk2->main;
