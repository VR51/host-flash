#! /bin/bash
clear
###
#
#	Host Flash (Junior) v1.1.0
#
#	Author: Lee Hodson
#	Donate: paypal.me/vr51
#	First Written: 18th Oct. 2015
#	First Release: 2nd Nov. 2015
#	This Release: 2nd Nov. 2015
#
#	https://github.com/VR51/host-flash
#	https://journalxtra.com
#
#	Copyright 2015 Lee Hodson
#	License: GPL3
#
#	Use of this script is at your own risk
#
#	TO RUN either 'sh host-flash.sh' or click the file host-flash.sh
#
#	Use Host Flash to block access to websites (hosts), ad servers, malicious websites and time wasting websites.
#	Use Host Flash to manage your hosts file
#
###

###
#
#	Let the user know we are running
#
###

echo -e "HOST FLASH INITIALISED"
echo -e "----------------------\n"


###
#
#	Locate Where We Are
#
###

filepath="$(dirname "$(readlink -f "$0")")"


###
#
#	Confirm we are running in a terminal
#		If not, try to launch thIS program in a terminal
#
###

tty -s

if [ $? -ne 0 ]; then

	# This code section is released in public domain by Han Boetes <han@mijncomputer.nl>
	# Updated by Dave Davenport <qball@gmpclient.org>
	# Updated by Lee Hodson <https://journalxtra.com> - Added break on successful hit, added more terminals, humanized the failure message, and removed call to rofi.
	#
	# This script tries to exec a terminal emulator by trying some known terminal
	# emulators.
	#
	# We welcome patches that add distribution-specific mechanisms to find the
	# preferred terminal emulator. On Debian, there is the x-terminal-emulator
	# symlink for example.
	for terminal in $TERMINAL x-terminal-emulator xdg-terminal konsole gnome-terminal terminator urxvt rxvt Eterm aterm roxterm xfce4-terminal termite lxterminal xterm; do
		if command -v $terminal > /dev/null 2>&1; then
			exec $terminal -e "$0"
			break
		else
			echo "Unable to automatically determine the correct terminal program to run e.g Console or Konsole. Please run this program from a terminal AKA the command line or click the host-flash.desktop file to launch Host Flash."
		fi
	done

fi

###
#
#	Check for required software dependencies
#
###

missing=0
for requirement in $REQUIREMENT wget sed dialog whiptail; do
	if command -v $requirement > /dev/null 2>&1; then
		echo "Checking for software dependencies.. $requirement found. Success! :-)"
	else
		echo "Checking for software dependencies.. $requirement MISSING :-("
		case $requirement in

			whiptail)
				echo "We are still okay if 'dialog' is installed"
				missing=$(($missing + 1))
				;;

			dialog)
				echo "We are still okay if 'whiptail' is installed"
				missing=$(($missing + 2))
				;;
		esac

	fi
done

if [ $missing -eq 3 ] ; then
	echo -n "Uh oh! Host Flash needs either 'whiptail' or 'dialog' to be installed. Please install one or both of them then rerun Host Flash"
	read something
	exit
fi

###
#
#	Set Dialog Program to use.
#		In this case we use first try to use 'dialog' then, if dialog is not installed, we try to use 'whiptail'. We could add or use any other dialog compatible program to the list.
#		The colour palette used by whiptail is controlled by newt. It can be configured with 'sudo update-alternatives --config newt-palette'
#		The colour palette used by dialog can be set by issuing command 'dialog --create-rc ~/.dialogrc'. The file .dialogrc can be edited as needed.
#
###

DIALOGRC="$filepath/settings/dialogrc"

# DIALOG=${DIALOG=dialog}

for dialogbox in $DIALOGBOX dialog whiptail; do
	if command -v $dialogbox > /dev/null 2>&1; then
		DIALOG=$dialogbox
		break
	else
		echo "Unable to detect a dialog box program such as 'dialog' or 'whiptail'. Please install one."
	fi
done


###
#
#	Obtain Authorisation to Install Hosts
#
###

echo -e "\n\nAUTHORISATION"
echo -e "-------------\n"

echo -e "\nPlease authorise Host Flash to backup, restore, edit or replace your computer's hosts file:\n"
sudo -v

###
#
#	Introduction
#
###

if [ ! -f ".showonce" ] ; then

$DIALOG --clear \
	--backtitle "Host Flash" \
	--title "Host Flash Protects Your Computer & Blocks Internet Ads" \
	--msgbox "General Information.
\n\n
Host Flash installs a list of Internet host domain names that are known to serve ads, malware or other undesirable to view content.
\n\n
This list of 'bad host' domains is installed into your computer's hosts file.
\n\n
The hosts file is typically stored in /etc/hosts and is read by your Linux computer when a request is made to view a domain.
\n\n
As you probably know, DNS servers tell computers the IP address of a server where a website (host) is located. DNS servers are usually managed by ISPs and are only connected to your computer through the incredibly long cables that connect it to the Internet. What you might not know is that your computer's hosts file overrules the remotely managed DNS servers.
\n\n
Domain names listed in your computer's hosts file are placed next to an IP address. This IP address is the address of the host (or web server) that your computer will attempt to contact when it needs to reach the domain listed alongside it.
\n\n
IP address to host name maps in a hosts file look like this one:
\n\n
		127.0.0.1 example.com\n
		127.0.0.1 example-two.com\n
		...
\n\n
Not all domain names (hosts) are listed in a computer's hosts file. In fact, most domain names are not listed in it. Only those hosts that need their server IP address(es) to be overriden need to be listed in the local hosts file of your computer.
\n\n
Your computer will not be able to access, send requests to, or recieve content from the domains that are added by Host Flash to your computer's local hosts file.
\n\n
The domains Host Flash adds to your hosts file are mapped to either the local IP address (i.e. loopback address) of your computer or to an IP address you specify when Host Flash is run. Requests to visit the hosts listed in the hosts file will never get any further than your computer's own IP address.
\n\n
With the bad hosts blocklist installed you will see (usually) a Document Not Found error message issued by your web browser when you try to view content hosted at a blocked address. This is the normal and expeted behaviour.
\n\n
Host Flash offers you 4 IP address mapping options:
\n\n
	a) 127.0.0.1 (default)\n
	b) 127.255.255.254 (non default)\n
	c) 0.0.0.0 (standard), and\n
	d) Custom\n
\n\n
Use the default IP address if in doubt over which to use.
\n\n
If you wanted to, you could use the IP address of another website so that requests to visit bad hosts redirect to something useful.
\n\n
This message will not show the next time you run Host Flash. Full instructions are in the readme.txt file shipped with Host Flash." 0 0

touch .showonce

fi

###
#
#	Warning Message
#
###

$DIALOG --clear \
	--backtitle "Host Flash" \
	--title "Thank You For Using Host Flash" \
	--msgbox "Host Flash blocks computers from accessing content served by certain web hosts. These hosts, for example, could be reported malicious websites, known ad servers, adult websites or torrent sites.
\n\n
Host Flash
\n\n
	- downloads 2 bad hosts blocklists,\n
	- merges those lists into one large compilation of bad hosts,\n
	- adds your custom bad hosts list into the mix (blocklist.txt),\n
	- removes duplicate bad host entries from the compiled bad hosts list,\n
	- comments out (unblocks) whitelisted hosts (whitelist.txt)\n
	- copies your existing hosts file to a backup location in /etc/hosts.backup (only one backup),\n
	- removes any previously installed bad hosts added by Host Flash from the existing hosts file,\n
	- merges your existing hosts file with the newly compiled bad hosts file,\n
	- replaces your existing hosts file with the new hosts file that blocks access to bad hosts.
\n\n
This process is run interactively so you will be asked to confirm changes before they are made to your system.
\n\n
You will not be able to access sites blocked by Host Flash.
\n\n
Run Host Flash regularly to keep your hosts file up-to-date with new bad hosts.
\n\n
Run Host Flash if you need to undo changes made to the hosts file by Host Flash
\n\n
Use Host Flash and the files whitelist.txt and blocklist.txt to manage your computer's hosts file.
\n\n
Rerun Host Flash to update the list of blocked sites or to activate changes to whitelist.txt and blocklist.txt.
\n\n
If you manually edit your computer's hosts file after using Host Flash, make sure your edits are above the content added by Host Flash or risk your manual edits being removed when Host Flash next runs.
\n\n
Read readme.txt for more information.
\n\n
Host Flash may take several minutes to complete its tasks on some systems.
\n\n
Use of this program is at your own risk." 0 0

###
#
#	Remove old working directory if it exists
#
###

if [ -d "HOSTS" ] ; then
	rm -r HOSTS
fi

###
#
#	Check for previous run
#
###

if [ -f "/etc/hosts.hf.backup" ] ; then

	$DIALOG --clear --backtitle "Host Flash" --title "Restore?" --defaultno --yesno 'There is a Host Flash backup file from a previous run. Would you like to restore this backup file?' 0 0
	restore=$?

fi

case $restore in

	0)

		sudo cp /etc/hosts /etc/hosts.hf.replaced
		sudo mv /etc/hosts.hf.backup /etc/hosts

		$DIALOG --clear --backtitle "Host Flash" --title "Finished" --msgbox "The backup hosts file has been restored. The replaced hosts file has been moved to hosts.hf.replaced. This file can be deleted when you no longer need it.\n\nSend donations to paypal.me/vr51" 0 0

		exit
		;;

	1)

		$DIALOG --clear --backtitle "Host Flash" --title "Deactivate?" --defaultno --yesno "Are you using Host Flash to remove an existing Host Flash blocklist from your hosts file?\n\nSelect 'Yes' if you want to deactivate Host Flash and undo the edits Host Flash made to your computer's hosts file in a previous run, otherwise select 'no'." 0 0
		remove=$?

		;;

	255)

		$DIALOG --clear --backtitle "Host Flash" --title "Cancelled" --msgbox "Esc pressed.\n\nSend donations to paypal.me/vr51" 0 0
		exit
		;;

esac


case $remove in

	0)

		sudo mv /etc/hosts.hf.backup /etc/hosts
		sed -i '/#### Hosts Flash Bad Hosts Block ########/,$d' /etc/hosts

		$DIALOG --clear --backtitle "Host Flash" --title "Finished" --msgbox "Hosts Flash bad hosts blocklist has been removed from your hosts file.\n\nSend donations to paypal.me/vr51" 0 0

		exit
		;;

	1)
		;;

	255)

		$DIALOG --clear --backtitle "Host Flash" --title "Cancelled" --msgbox "Esc pressed.\n\nSend donations to paypal.me/vr51" 0 0
		exit
		;;

esac


###
#
#	Select the hosts file blocklists
#
###

hosts_lists="$($DIALOG --stdout \
		--clear \
		--backtitle "Host Flash" \
		--separate-output \
		--checklist 'Choose the bad hosts block-lists to install' 0 0 0 \
		hosts-file.net '' On \
		mvps.org '' On \
		)"

###
#
#	Set the IP address that blocked hosts will redirect to
#
###

function set_redirect_address_func {

	redirectip="$($DIALOG --stdout \
			--clear \
			--backtitle "Host Flash" \
			--radiolist 'Set the Redirect IP Address' 0 0 0 \
			127.0.0.1 'localhost (default)' On \
			127.255.255.254 'localhost (non default)' Off \
			0.0.0.0 'localhost (non-standard)' Off \
			Custom 'Type in a Preferred IP Address' Off \
		)"

	if [ "$redirectip" == "Custom" ] ; then

		redirectip="$($DIALOG --stdout --clear --backtitle "Host Flash" --inputbox 'Enter the IP address' 0 0 '127.0.0.1')"

	fi

}

set_redirect_address_func

##
#	Quick check that the address is an IP address
##

if expr "$redirectip" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
	for i in 1 2 3 4; do
	if [ $(echo "$redirectip" | cut -d. -f$i) -gt 255 ]; then
		$DIALOG --clear --backtitle "Host Flash" --msgbox "$redirectip is not a valid IP address. Try again." 0 0

		set_redirect_address_func
	fi
	done
else
	$DIALOG --clear --backtitle "Host Flash" --msgbox "$redirectip is not a valid IP address. Try again." 0 0

	set_redirect_address_func
fi

####
#
#	House Cleaning
#
###

$DIALOG --clear --backtitle "Host Flash" --title 'House Cleaning' --yesno 'Remove temporary files when finished?' 0 0
clean=$?


###
#
#	Download Host Files, Merge Host Files and Clean up
#
###

clear

mkdir HOSTS
cd HOSTS

#	Download Files
#	Look at hosts_lists $DIALOG box for more info

for opt in $hosts_lists
do
	case $opt in

		hosts-file.net)

			wget http://hosts-file.net/download/hosts.zip
			unzip -o hosts.zip
			echo -e "\nPreparing files.. We could be here a while..\n"
			sed -i 's/#.*//' hosts.txt
			sed -i '/.*\blocalhost\b.*/d' hosts.txt
			sed -i "s/127\.0\.0\.1/$redirectip/" hosts.txt
			sed -i 's/	/ /' hosts.txt
			sed -i '/^$/d' hosts.txt
			rm hosts.zip

		;&

		mvps.org)

			wget http://winhelp2002.mvps.org/hosts.zip
			unzip -o hosts.zip
			echo -e "\nPreparing files.. We could be here a while..\n"
			sed -i 's/#.*//' HOSTS
			sed -i '/.*\blocalhost\b.*/d' HOSTS
			sed -i "s/0\.0\.0\.0/$redirectip/g" HOSTS
			sed -i 's/	/ /' HOSTS
			sed -i '/^$/d' HOSTS
			rm hosts.zip

		;;

	esac
done

#	Remove old Host Flash blocklist, assuming it exists

echo -e "\nRemoving previous blocklist from hosts..\n"
cp /etc/hosts hosts.copy
sed -i '/#### Hosts Flash Bad Hosts Block ########/,$d' hosts.copy
echo -e '#### Hosts Flash Bad Hosts Block ########\n' >> hosts.copy

#	Format and use custom blocklist

cp ../blocklist.txt blocklist.txt

if [ -s "blocklist.txt" ] ; then

	echo -e "\nPreparing custom hosts in blocklist.txt..\n"
	sed -r -i "s/^(.*)/$redirectip \1/g" blocklist.txt
	echo -e "\nAdding custom bad hosts to..\n"
	echo -e '\n' >> blocklist.txt

fi

#	Merge bad hosts lists and custom blocklist. Sort them alphabetically and remove duplicates.
#	We test for the files instead of running tests on $hosts_lists

if [ -f "hosts.txt" ] && [ -f "HOSTS" ] ; then

	echo -e "\nBuilding new hosts file..\n"
	cat blocklist.txt hosts.txt HOSTS > hosts-temp
	sort -u -f hosts-temp > hosts

fi


if [ -f "hosts.txt" ] && [ ! -f "HOSTS" ] ; then

	echo -e "\nBuilding new hosts file..\n"
	cat blocklist.txt hosts.txt > hosts-temp
	sort -u -f hosts-temp > hosts

fi

if [ ! -f "hosts.txt" ] && [ -f "HOSTS" ] ; then

	echo -e "\nBuilding new hosts file..\n"
	cat blocklist.txt HOSTS > hosts-temp
	sort -u -f hosts-temp > hosts

fi

###
#
#	Comment out any whitelisted hosts
#
###

echo -e "\nRe-enabling hosts in whitelist.txt.. This may take several minutes..\n"

cp ../whitelist.txt whitelist.txt

#	Sort content and remove duplicates

sort -u -f whitelist.txt > whitelist

if [ -s "whitelist" ] ; then

	while read -r LINE
	do
		sed -r -i "s/($redirectip $LINE(.*)?)$/# \1/g" hosts

	done <"whitelist"
# sed -r -i "s/([0-9].+$LINE(.*)?)$/# \1/g" hosts
fi


###
#
#	Restore Default hosts file's head (restore anything above the line #### Hosts Flash Bad Hosts Block ######## of the existing hosts file)
#
###

echo -e "\nMerging bad hosts list into hosts file..\n"
cat hosts.copy hosts > hosts-temp #  We use hosts-temp so we don't overwrite the temp. hosts file (in case it's needed later)
mv hosts-temp ../hosts

cd ..

if [ "$clean" == "0" ] ; then

	echo -e "\nRemoving temporary files..\n"
	rm -r HOSTS

fi

###
#
#	Install New Hosts File
#
###

$DIALOG --clear --backtitle "Host Flash" --title "Install" --yesno 'Install new hosts file?' 0 0
install=$?

case $install in

	0)

		echo -e "\nInstalling new hosts file..\n"
		sudo cp /etc/hosts /etc/hosts.hf.backup
		sudo mv "$filepath/hosts" /etc/hosts

		$DIALOG --clear --backtitle "Host Flash" --title "Finished" --msgbox "New hosts file block list installed.\n\nThe old hosts file has been backed up to /etc/hosts.backup\n\nDonations welcome at paypal.me/vr51" 0 0

		exit

		;;

	1)

		$DIALOG --clear --backtitle "Host Flash" --title "Finished" --msgbox "The new hosts file can be found in the same directory as this program. Look for the file named 'hosts'\n\nYou can install the file manually by moving it to /etc/hosts\n\nContribute to the Host Flash development fund at paypal.me/vr51" 0 0
		exit
		;;

	255)

		$DIALOG --clear --backtitle "Host Flash" --title "Cancelled" --msgbox "Esc pressed.\n\nContribute to the Host Flash development fund at paypal.me/vr51" 0 0
		exit
		;;

esac