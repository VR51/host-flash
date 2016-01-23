#!/bin/bash
clear
###
#
#	Host Flash™ v2.5.0
#
#	Lead Author: Lee Hodson
#	Donate: paypal.me/vr51
#	Website: https://host-flash.com
#	First Written: 18th Oct. 2015
#	First Release: 2nd Nov. 2015
#	This Release: 23rd Jan. 2016
#
#	Copyright 2015 Host Flash™ <https://host-flash.com>
#	License: GPL3
#
#	Programmer: Lee Hodson <journalxtra.com>, <vr51.com>
#
#	Use of this program is at your own risk
#
#	TO RUN:
#
#	- Ensure the script is executable.
#	- Command line: bash host-flash.sh or ./host-flash.sh
#	- File browser: click host-flash.sh or click host-flash.desktop, or
#
#	Use Host Flash™ to block access to websites (hosts), ad servers, malicious websites and time wasting websites.
#	Use Host Flash™ to manage your hosts file
#
###

###
#
#	Let the user know we are running
#
###

printf "HOST FLASH INITIALISED\n----------------------\n\n"

###
#
#	Set Variables
#
###

version="v2.0.1"

# Establish Linux epoch time in seconds
now=$(date +%s)

# Establish both Date and Time
todaytime=$(date +"%Y-%m-%d-%H:%M:%S")

# Locate Where We Are
filepath="$(dirname "$(readlink -f "$0")")"


###
#
#	Register leave_program function
#
###


leave_program() {

	exittime=$(date +%s)
	runtime=$(($exittime - $now))
	
	# Add End Run time to run.log
	printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): RUN END" >> "$filepath/log/run.log"
	# Add Run elapsed time to run.log
	printf "\nPROGRAM RUN TIME: $runtime seconds\n" >> "$filepath/log/run.log"

        clear
	printf "\nPROGRAM RUN TIME: $runtime seconds\n"
	printf "\n\nVisit https://host-flash.com to learn more about Host Flash and hosts files.\n\n"
	printf "\n\nSend donations to paypal.me/vr51\n\n"
	printf "\n\nPress any key to exit Host Flash"
	read something
	exit

}


###
#
#	Add Start Time to run.log
#
###

if test ! -d "$filepath/log"
then
	mkdir "$filepath/log"
fi

if test -f "$filepath/log/run.log"
then
	printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): RUN START" >> "$filepath/log/run.log"
fi

###
#
#	Confirm we are running in a terminal
#		If not, try to launch this program in a terminal
#
###

printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): CHECKED FOR TERMINAL PROGRAM" >> "$filepath/log/run.log"

tty -s

if test "$?" -ne 0
then

	# This code section is released in public domain by Han Boetes <han@mijncomputer.nl>
	# Updated by Dave Davenport <qball@gmpclient.org>
	# Updated by Lee Hodson <https://journalxtra.com> - Added break on successful hit, added more terminals, humanized the failure message, replaced call to rofi with printf and made $terminal an array for easy reuse.
	#
	# This script tries to exec a terminal emulator by trying some known terminal
	# emulators.
	#
	# We welcome patches that add distribution-specific mechanisms to find the
	# preferred terminal emulator. On Debian, there is the x-terminal-emulator
	# symlink for example.

	terminal=( konsole gnome-terminal x-terminal-emulator xdg-terminal terminator urxvt rxvt Eterm aterm roxterm xfce4-terminal termite lxterminal xterm )
	for i in ${terminal[@]}; do
		if command -v $i > /dev/null 2>&1; then
			exec $i -e "$0"
			break
		else
			printf "\nUnable to automatically determine the correct terminal program to run e.g Console or Konsole. Please run this program from a terminal AKA the command line or click the host-flash.desktop file to launch Host Flash.\n"
			read something
			leave_program
		fi
	done

fi

###
#
#	Check for required software dependencies
#
###

printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): CHECKED SOFTWARE DEPENDENCIES" >> "$filepath/log/run.log"

printf "Checking software requirements...\n\n"

requirement=( dialog whiptail zip unzip 7z wget sed ) # p7zip and p7zip-full. Their status flag is used near line 510 (# Select the hosts file blocklists)
for i in ${requirement[@]}; do

	if command -v $i > /dev/null 2>&1; then
		statusmessage+=("%4sFound:%10s$i")
		statusflag+=('0')
	else
		statusmessage+=("%4sMissing:%8s$i")
		statusflag+=('1')
		whattoinstall+=("$i")
		error=1
	fi

done

# Display status of presence or not of each requirement

for LINE in ${statusmessage[@]}; do
	printf "$LINE\n"
done

printf "\n"
# Check for critical errors and warning errors. Set critical flag if appropriate.

critical=0

if test ${statusflag[0]} = 1 && test ${statusflag[1]} = 1; then
		printf "%4sCritical:%6s Neither dialog nor whiptail is installed. Host Flash cannot run without at least one of them\n"
		critical=1
fi

if test ${statusflag[2]} = 1; then
		printf "%4sCritical:%6s zip is not installed. Program cannot run without zip\n"
		critical=1
fi

if test "${statusflag[4]}" = 1; then
		printf "%4sWarning:%6s Neither p7zip nor p7zip-full is installed. Program will run with reduced choice of blacklist download sources\n"
fi

if test ${statusflag[5]} = 1; then
		printf "%4sCritical:%6s wget is not installed. Program cannot run without wget\n"
		critical=1
fi

if test ${statusflag[6]} = 1; then
		printf "%4sCritical:%6s sed is not installed. Program cannot run without sed\n"
		critical=1
fi

# Display appropriate status messages

if test "$error" == 0 && test "$critical" == 0; then
	printf "The software environment is optimal for this program.\n\n"
fi

if test "$error" == 1 && test "$critical" == 0; then
	printf "Non essential software required by Host Flash is missing from this system. If the program fails to run, consider to install with, for example,\n\n%6ssudo apt-get install ${whattoinstall[*]}\n\n"
fi

if test "$critical" == 1; then
	printf "Critical Error: essential software dependencies are missing from this system. Host Flash will stop here. Install missing software with, for example,\n\n%6ssudo apt-get install ${whattoinstall[*]}\n\n"
	read something
	leave_program
fi


###
#
#	Set Dialog Program to use.
#		In this case we use first try to use 'dialog' then, if dialog is not installed, we try to use 'whiptail'. We could add or use any other dialog compatible program to the list.
#		The colour palette used by whiptail is controlled by newt. It can be configured with 'sudo update-alternatives --config newt-palette'
#		The colour palette used by dialog can be set by issuing command 'dialog --create-rc ~/.dialogrc'. The file .dialogrc can be edited as needed.
#
###

printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): SET DIALOGUE PROGRAM" >> "$filepath/log/run.log"

DIALOGRC="$filepath/settings/dialogrc"

dialoguesystem=( dialog whiptail )
for i in ${dialoguesystem[@]} ; do
	if command -v $i > /dev/null 2>&1; then
		DIALOG=$i
		break
	fi
done

###
#
#	Obtain Authorisation to Install Hosts
#
###

# Add event to run.log
printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): ASKED FOR AUTHORISATION" >> "$filepath/log/run.log"

printf "\n\nAUTHORISATION\n-------------\n"

printf "\nAuthorise Host Flash to backup, restore, edit and replace the hosts file:\n"
sudo -v


###
#
#	Display Update Message and Run Post Update Actions
#
###

if test ! -d "$filepath/log/updates"
then
        mkdir "$filepath/log/updates"
fi

if test ! -f "$filepath/log/updates/version-$version" # 
then

# Add event to run.log
printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): SHOWED UPDATE NOTICE" >> "$filepath/log/run.log"

$DIALOG --clear \
	--backtitle "Host Flash" \
	--title "Update Notice" \
	--msgbox "Host Flash Updated to Version $version.
\n\n
Host Flash now includes a program update feature.
\n\n
Important: The custom whitelists and the custom blocklist now reside in the 'custom' directory.
Your existing custom whitelists and custom blocklist will be moved for you automatically when you click 'OK'.
\n\n
Important: Host Flash now has an update feature.
\n\n
Read change.log to see brief list of changes in this version.
\n\n
Visit host-flash.com to read more about changes in $version and stay up-to-date with Host Flash developments.
" 0 0

touch "$filepath/log/updates/version-$version"
printf "Delete this file to re-enable the Host Flash version update information dialogue box that displayed when Host Flash updated to version $version." > "$filepath/log/updates/version-$version"

#
# Run post update actions
#

# Add event to run.log
printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): RAN POST UPDATE ACTIONS" >> "$filepath/log/run.log"

    # Added in version 2.0.1. Create custom directory and move whitelist & blocklist files into it. Remove in version 3.0.0
    
    if test ! -d "$filepath/custom"
    then
        mkdir "$filepath/custom"
    fi

    if test -f "$filepath/whitelist.txt"
    then
        mv "$filepath/whitelist.txt" "$filepath/custom/whitelist.txt"   
    fi
    
    if test -f "$filepath/whitelist-wild.txt"
    then
        mv "$filepath/whitelist-wild.txt" "$filepath/custom/whitelist-wild.txt"   
    fi

    if test -f "$filepath/blocklist.txt"
    then
        mv "$filepath/blocklist.txt" "$filepath/custom/blocklist.txt"   
    fi
    
    # Added in version 2.0.1. Remove .showonce. Remove in version 3.0.0
    
    if test -f "$filepath/settings/.showonce"
    then
        rm "$filepath/settings/.showonce"
    fi

fi



###
#
#	Check for Quick Run Saved Settings. Ask to Import Quick Run Variables if Set
#
###

if test -f "$filepath/settings/quickrun"
then

	# Add event to run.log
	printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): CHECKED FOR QUICKRUN" >> "$filepath/log/run.log"

	quickrun="$($DIALOG --stdout \
			--clear \
			--backtitle "Host Flash" \
			--radiolist 'Use Quick Run?' 0 0 0 \
			Yes 'Use saved settings.' On \
			No 'Use manual settings.' Off \
			Delete 'Delete saved settings. Maybe reconfigure later.' Off \
		)"

	case $quickrun in

		Yes)

			# Load source 'quickrun' variable file the right way
			if source "$filepath/settings/quickrun"
			then
				source "$filepath/settings/quickrun"
			else
				. "$filepath/settings/quickrun"
			fi

			;;

		No)
			continue
			;;

		Delete)

			rm "$filepath/settings/quickrun"
			$DIALOG --clear --backtitle "Host Flash" --title "Quick Run Settings Deleted" --msgbox "Quick Run can be reconfigured at the end of this program session." 0 0

			;;

		255)

			$DIALOG --clear --backtitle "Host Flash" --title "Cancelled" --msgbox "Esc pressed.\n\n" 0 0
			leave_program
			;;

	esac

fi


####
#
#	Update Host Flash
#
###

if test "$quickrun" = "On"
then # Use saved answer if quick run enabled

	updatehf=$updatehfqr

fi

if test "$quickrun" != "On"
then

	$DIALOG --clear --backtitle "Host Flash" --title 'Update Host Flash' --yesno 'Download and install Host Flash program update?' 0 0
	updatehf=$?

fi

case $updatehf in

                0)
                
                        # Add event to run.log
                        printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): UPDATED HOST FLASH PROGRAM FILES" >> "$filepath/log/run.log"

                
                        # Update Host Flash
                        
                        wget -q https://raw.githubusercontent.com/VR51/host-flash/master/LICENSE -O "$filepath/LICENSE"
                        wget -q https://raw.githubusercontent.com/VR51/host-flash/master/change.log -O "$filepath/change.log"
                        wget -q https://raw.githubusercontent.com/VR51/host-flash/master/README.md -O "$filepath/README.md"
                        wget -q https://raw.githubusercontent.com/VR51/host-flash/master/readme.txt -O "$filepath/readme.txt"
                        wget -q https://raw.githubusercontent.com/VR51/host-flash/master/host-flash.desktop -O "$filepath/host-flash.desktop"
                        wget -q https://raw.githubusercontent.com/VR51/host-flash/master/host-flash.sh -O "$filepath/host-flash.sh"
                        
                        printf "\nHost Flash updated. Program will restart when you press a key."
                        read something
                        
                        exec bash "$filepath/host-flash.sh"
                        
                        ;;
                        
                1)
                
                        continue
                        
                        ;;
                        
                255)
                
                        leave_program
                        
                        ;;
                        
esac


###
#
#	Introduction
#
###

if test "$quickrun" != "On"
then

# Add event to run.log
printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): SHOWED INTRODUCTION TEXT" >> "$filepath/log/run.log"

$DIALOG --clear \
	--backtitle "Host Flash" \
	--title "Host Flash Protects Computers & Blocks Internet Ads" \
	--msgbox "General Information.
\n\n
Host Flash installs a list of Internet host domain names that are known to serve ads, malware, undesirable, inapropriate or questionable content.
\n\n
Full instructions are in the readme.txt file that shipped with Host Flash.
\n\n
More information about Host Flash and hosts files can be found at https://host-flash.com.
\n\n
Run Host Flash frequently to keep your blocklist up-to-date and your computer safe." 0 0

fi



###
#
#	Remove old working directory if it exists
#
###

if test -d "$filepath/TEMP"
then

	# Add event to run.log
	printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): DELETED OLD TEMP DIRECTORY" >> "$filepath/log/run.log"

	rm -r "$filepath/TEMP"
fi

###
#
#	Check for backup file
#
###

# Do not run if Quick Run is On
if test "$quickrun" != "On"
then

	if test -f '/etc/hosts.hf.original'
	then

		$DIALOG --clear --backtitle "Host Flash" --title "Restore?" --defaultno --yesno 'Would you like to restore the original hosts file that Host Flash replaced the very first time Host Flash ran on this computer? This will overwrite the current hosts file.' 0 0
		restore=$?

	fi

	case $restore in

		0)

			sudo mv /etc/hosts.hf.original /etc/hosts

			$DIALOG --clear --backtitle "Host Flash" --title "Finished" --msgbox "The original hosts file has been restored." 0 0

			# Add event to run.log
			printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): RESTORED HOSTS FILE" >> "$filepath/log/run.log"
			printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): RUN END" >> "$filepath/log/run.log"
			leave_program
			;;

		1)

			$DIALOG --clear --backtitle "Host Flash" --title "Deactivate?" --defaultno --yesno "Do you want to remove the Host Flash blocklist from the existing hosts file?\n\nSelect 'Yes' if you want to deactivate Host Flash and undo the edits made to your hosts file by Host Flash, otherwise select 'no'." 0 0
			remove=$?

			;;

		255)

			$DIALOG --clear --backtitle "Host Flash" --title "Cancelled" --msgbox "Esc pressed." 0 0
			leave_program
			;;

	esac


	case $remove in

		0)

			sed -i '/#### Hosts Flash Bad Hosts Block ########/,$d' /etc/hosts

			$DIALOG --clear --backtitle "Host Flash" --title "Finished" --msgbox "Hosts Flash bad hosts blocklist has been removed from your hosts file." 0 0

			# Add event to run.log
			printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): REMOVED BLOCK LIST" >> "$filepath/log/run.log"
			printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): RUN END" >> "$filepath/log/run.log"

			leave_program
			;;

		255)

			$DIALOG --clear --backtitle "Host Flash" --title "Cancelled" --msgbox "Esc pressed." 0 0
			leave_program
			;;

	esac

fi

###
#
#	Select the hosts file blocklists
#
###

if test "$quickrun" = "On"
then
	# Use saved answer if set
	hosts_lists=$hosts_listsqr
fi

if test "$quickrun" != "On"
then

	if test "${statusflag[4]}" = 0
	then

		hosts_lists="$($DIALOG --stdout \
				--clear \
				--backtitle "Host Flash" \
				--separate-output \
				--checklist 'Choose the bad hosts block-lists to install. Lists that interfere least with regular web browsing are preselected.' 0 0 0 \
				hosts-file.net 'Liberal: Blocks mostly ad servers, malware sites and trackers.' On \
				mvps.org 'Liberal: Blocks mostly ad servers, malware sites and trackers' On \
				free.fr-Trackers 'Moderate: Blocks tracking services and analytic services' Off \
				free.fr-Ad-Servers 'Moderate: Blocks ad servers' On \
				free.fr-Malware 'Moderate: Blocks reported malware sites' On \
				free.fr-Adult 'Moderate: Blocks pornography. Coincidentally blocks forums and some social sites.' Off \
				free.fr-Misc 'Moderate: Blocks miscellaneous sites that some consider undesirable' Off \
				hostsfile.org 'Very Strict: Regular blocks + porn, gambling and gaming sites.' Off \
				)"
	fi

	if test "${statusflag[4]}" = 1
	then

		hosts_lists="$($DIALOG --stdout \
				--clear \
				--backtitle "Host Flash" \
				--separate-output \
				--checklist 'Choose the bad hosts block-lists to install. Lists that interfere least with regular web browsing are preselected.' 0 0 0 \
				hosts-file.net 'Liberal: Blocks mostly ad servers, malware sites and trackers' On \
				mvps.org 'Liberal: Blocks mostly ad servers, malware sites and trackers' On \
				hostsfile.org 'Very Strict: Regular blocks + porn, gambling and gaming sites.' Off \
				)"
	fi

fi

##
#
#	Check we have a redirect IP address
#
##

if test "$quickrun" = "On"
then
	# Use saved answer if set
	redirectip=$redirectipqr
fi

if test "$quickrun" != "On"
then
	# Ask to set redirect IP address
	redirectip="$($DIALOG --stdout \
	--clear \
	--backtitle "Host Flash" \
	--radiolist 'Set the Redirect IP Address' 0 0 0 \
	127.0.0.1 'localhost (default)' On \
	127.255.255.254 'localhost (non default)' Off \
	0.0.0.0 'localhost (non-standard)' Off \
	Custom 'Type in a Preferred IP Address' Off \
	)"

	case $redirectip in

		Custom) redirectip="$($DIALOG --stdout --clear --backtitle "Host Flash" --inputbox 'Enter the IP address' 0 0 '127.0.0.1')"

	esac

fi


####
#
#	Install Community Whitelists
#
###

if test "$quickrun" = "On"
then # Use saved answer if quick run enabled

	whitelists=$whitelistsqr

fi

if test "$quickrun" != "On"
then

	$DIALOG --clear --backtitle "Host Flash" --title 'Community Whitelists' --yesno 'Download and install the Community Whitelists?' 0 0
	whitelists=$?

fi


####
#
#	House Cleaning
#
###

if test "$quickrun" = "On"
then # Use saved answer if quick run enabled

	clean=$cleanqr

fi

if test "$quickrun" != "On"
then

	$DIALOG --clear --backtitle "Host Flash" --title 'House Cleaning' --yesno 'Remove temporary files when finished?' 0 0
	clean=$?

fi

###
#
#	Download Host Files, Merge Host Files and Clean up
#	We specify file paths but we're CD'ing to directories to ward off accidents....
#
###

clear

if test ! -d "$filepath/TEMP"
    then
    # Add event to run.log
    printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): CREATED TEMP DIRECTORY" >> "$filepath/log/run.log"
    mkdir "$filepath/TEMP"
fi
cd "$filepath/TEMP"


###
#
#	Download Files
#	Look at hosts_lists DIALOG box for more info
#
##

# Add event to run.log
printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): DOWNLOADED HOST FILES" >> "$filepath/log/run.log"

touch hosts-temp.txt
for opt in $hosts_lists
do

	case "$opt" in

		hosts-file.net)
				download=http://hosts-file.net/download # Download URL
				dfile=hosts.zip # Download file
				target=hosts.txt # The file we want to use from the file
				unzipprog='unzip' # The program to use to extract the file
				;;

		mvps.org)
				download=http://winhelp2002.mvps.org
				dfile=hosts.zip
				target=HOSTS
				unzipprog='unzip'
				;;

		free.fr-Trackers)
				download=http://rlwpx.free.fr/WPFF
				dfile=htrc.7z
				target=Hosts.trc
				unzipprog='p7zip'
				;;

		free.fr-Ad-Servers)
				download=http://rlwpx.free.fr/WPFF
				dfile=hpub.7z
				target=Hosts.pub
				unzipprog='p7zip'
				;;

		free.fr-Malware)
				download=http://rlwpx.free.fr/WPFF
				dfile=hrsk.7z
				target=Hosts.rsk
				unzipprog='p7zip'
				;;

		free.fr-Adult)
				download=http://rlwpx.free.fr/WPFF
				dfile=hsex.7z
				target=Hosts.sex
				unzipprog='p7zip'
				;;

		free.fr-Misc)
				download=http://rlwpx.free.fr/WPFF
				dfile=hmis.7z
				target=Hosts.mis
				unzipprog='p7zip'
				;;

		hostsfile.org)
				download=http://www.hostsfile.org/Downloads
				dfile=hosts.txt
				unzipprog=''
				target=hosts.txt
				;;

	esac

	wget "$download/$dfile"

	if test "$unzipprog" = 'unzip'; then unzip -o "$dfile"; fi
	if test "$unzipprog" = 'p7zip'; then 7z e -y "$dfile"; fi
	cat "$filepath/TEMP/$target" >> "$filepath/TEMP/hosts-temp.txt"
	if test -f "$filepath/TEMP/hosts.txt" ; then rm "$filepath/TEMP/hosts.txt" ; fi
	if test -f "$filepath/TEMP/HOSTS" ; then rm "$filepath/TEMP/HOSTS" ; fi
	if test "$unzipprog" = 'unzip' -o "$unzipprog" = 'p7zip' ; then rm "$filepath/TEMP/$dfile" ; fi # Delete the downloaded zip file

done


###
#
#	Prepare New Hosts File
#
##


#	Format Data in hosts-temp.txt

# Add event to run.log
printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): PREPARED NEW HOSTS" >> "$filepath/log/run.log"

printf "\nPreparing new hosts file.. We could be here a while..\n"

sed -i 's/#.*//' "$filepath/TEMP/hosts-temp.txt" # Remove all comments (some come after hostname <-> IP map lines)
iconv -c -t UTF-8//TRANSLIT "$filepath/TEMP/hosts-temp.txt" > "$filepath/TEMP/hosts-utf8.txt" # Convert non UTF8 characters to fix comment fault in French lists.
	rm "$filepath/TEMP/hosts-temp.txt"
	mv hosts-utf8.txt "$filepath/TEMP/hosts-temp.txt"
sed -i 's/^[^01-9].*//' "$filepath/TEMP/hosts-temp.txt" # Remove any line that does not begin with a number
sed -i '/.*\blocalhost\b.*/d' "$filepath/TEMP/hosts-temp.txt" # Remove localhost lines - the computer's installed host file already has localhost defined the way it should be
sed -i '/^$/d' "$filepath/TEMP/hosts-temp.txt" # Remove empty lines

sed -i "s/^[01-9\.].*[ \t]/$redirectip /g" "$filepath/TEMP/hosts-temp.txt" # Replace with a single space and the new IP address everything up to, and including, the first tab(s) or space(s) in each line

#	Remove old Host Flash blocklist from existing hosts file, assuming it exists
#	This creates file hosts.copy which is used a few lines down from here
printf "\nRemoving previous blocklist from hosts..\n"
cp /etc/hosts "$filepath/TEMP/hosts.copy"
sed -i '/#### Hosts Flash Bad Hosts Block ########/,$d' "$filepath/TEMP/hosts.copy"
sed -i 's/\n\n/\n/' "$filepath/TEMP/hosts.copy" # Ensuring we don't have hundreds of successive newlines
printf '\n#### Hosts Flash Bad Hosts Block ########\n' >> "$filepath/TEMP/hosts.copy"


#	Format and use custom blocklist

if test -s "$filepath/custom/blocklist.txt"
then

	# Add event to run.log
	printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): ADDED BLOCKLIST.TXT HOSTS" >> "$filepath/log/run.log"

	cp "$filepath/custom/blocklist.txt" "$filepath/TEMP/blocklist.txt"

	printf "\nPreparing custom hosts in blocklist.txt..\n"
	sed -r -i "s/^(.*)/$redirectip \1/g" "$filepath/TEMP/blocklist.txt"
	printf "\nAdding custom bad hosts to the hosts list..\n"
	printf '\n' >> "$filepath/TEMP/blocklist.txt" # Precaution
	cat "$filepath/TEMP/blocklist.txt" >> "$filepath/TEMP/hosts-temp.txt"

fi


###
#
#	Organise and remove duplicate entries from the new hosts lists and build them into the new hosts file
#
###


	printf "\nBuilding the new hosts file..\n"
	sort -u -f "$filepath/TEMP/hosts-temp.txt" > "$filepath/TEMP/hosts"

	
###
#
#	Install community whitelist
#
###

if test "$whitelists" = "0" ; then

    # Add event to run.log
    printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): INSTALLED COMMUNITY WHITELISTS" >> "$filepath/log/run.log"

    printf "\nInstalling Community Whitelists..\n"

    # Download community whitelist.txt and mix it with the existing custom whitelist

    wget -q https://gist.githubusercontent.com/VR51/7eaace2b6778ea508996/raw/ad90168c61e926d462895b190ad84e37f4e5c99e/whitelist.txt -O "$filepath/TEMP/whitelist.txt"

    if test -s "$filepath/custom/whitelist.txt" ; then
        printf "\n" >> "$filepath/custom/whitelist.txt"
        cat "$filepath/custom/whitelist.txt" "$filepath/TEMP/whitelist.txt" > "$filepath/TEMP/whitelist-merged.txt"
        rm "$filepath/custom/whitelist.txt"
    fi

    sort -u -f "$filepath/TEMP/whitelist-merged.txt" > "$filepath/custom/whitelist.txt"

    # Download community whitelist-wild.txt and mix it with the existing custom whitelist-wild

    wget -q https://gist.githubusercontent.com/VR51/9798c78337fe2f7ad589/raw/2bd44e16c624650d5022815a13a9b0873738900d/whitelist-wild.txt -O "$filepath/TEMP/whitelist-wild.txt"

    if test -s "$filepath/custom/whitelist-wild.txt" ; then
        printf "\n" >> "$filepath/custom/whitelist-wild.txt"
        cat "$filepath/custom/whitelist-wild.txt" "$filepath/TEMP/whitelist-wild.txt" > "$filepath/TEMP/whitelist-wild-merged.txt"
        rm "$filepath/custom/whitelist-wild.txt"
    fi

    sort -u -f "$filepath/TEMP/whitelist-wild-merged.txt" > "$filepath/custom/whitelist-wild.txt"

fi	
	
	
###
#
#	Remove any whitelisted hosts
#
###

#	Sort content and remove duplicates

if test -s "$filepath/custom/whitelist.txt"
then

	# Add event to run.log
	printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): REMOVED WHITELIST.TXT HOSTS" >> "$filepath/log/run.log"

	printf "\nRe-enabling hosts in whitelist.txt.. This may take several minutes..\n"

	sort -u -f "$filepath/custom/whitelist.txt" > "$filepath/TEMP/whitelist.txt"

	# Iterate through non wildcard domain list

	while read -r LINE
	do
		# sed -r -i "s/($redirectip $LINE(.*)?)$/# \1/g" "$filepath/TEMP/hosts" # This method comments out whitelisted hostnames
		sed -r -i "s/$redirectip $LINE.*?$//g" "$filepath/TEMP/hosts" # This method removes whitelisted hostnames

	done <"$filepath/TEMP/whitelist.txt"

fi

if test -s "$filepath/custom/whitelist-wild.txt"
then

	# Add event to run.log
	printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): REMOVED WHITELIST-WILD.TXT HOSTS" >> "$filepath/log/run.log"

	printf "\nRe-enabling hosts in whitelist-wild.txt.. This may take several minutes..\n"

	sort -u -f "$filepath/custom/whitelist-wild.txt" > "$filepath/TEMP/whitelist-wild.txt"

	# Iterate through wildcard domain list

	while read -r LINE
	do
		# sed -r -i "s/($redirectip (.*\.)$LINE(.*)?)$/# \1/g" "$filepath/TEMP/hosts" # This method comments out whitelisted hostnames
		sed -r -i "s/$redirectip .*\.$LINE.*?$//g" "$filepath/TEMP/hosts" # This method removes whitelisted hostnames

	done <"$filepath/TEMP/whitelist-wild.txt"

fi

###
#
#	Remove null lines left behind when whitelisted hostnames were removed
#
###


sed -i '/^$/d' "$filepath/TEMP/hosts"

###
#
#	Restore Default hosts file's head (restore anything above the line #### Hosts Flash Bad Hosts Block ######## of the existing hosts file)
#
###

# Add event to run.log
printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): UPDATED STAGING HOSTS FILE WITH BLOCKLIST" >> "$filepath/log/run.log"

printf "\nMerging bad hosts list into hosts file..\n"
cat "$filepath/TEMP/hosts.copy" "$filepath/TEMP/hosts" > "$filepath/hosts" #  We use hosts-temp so we don't overwrite the temp. hosts file (in case it's needed later)

# Back up to Host File root directory
cd ..

if test "$clean" = "0"
then

	# Add event to run.log
	printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): REMOVED TEMP DIRECTORY" >> "$filepath/log/run.log"

	printf "\nRemoving temporary files..\n"
	rm -r "$filepath/TEMP"

fi

###
#
#	Install New Hosts File
#
###

if test "$quickrun" = "On"
then # Use saved answer if quick run On

	installhl=$installqr

fi

if test "$quickrun" != "On"
then

	$DIALOG --clear --backtitle "Host Flash" --title "Install" --yesno 'Install new hosts file?' 0 0
	installhl=$?

fi

	##
	#
	#	A Quick Detour... Asking now so the user doesn't miss out
	#
	##


	if test ! -f "$filepath/settings/quickrun"
	then

		$DIALOG --clear --backtitle "Host Flash" --title "Enable Quick Run?" --yesno "Save Host Flash settings to reuse the next time Host Flash runs?" 0 0
		quickrun=$?

		case $quickrun in

			0)

				# Add event to run.log
				printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): CREATED QUICKRUN CONFIG FILE" >> "$filepath/log/run.log"

				touch "$filepath/settings/quickrun"

				printf "#!/bin/bash\n" > "$filepath/settings/quickrun"

				printf "quickrun='On'\n" >> "$filepath/settings/quickrun"
				
				printf "updatehfqr='$updatehf'\n" >> "$filepath/settings/quickrun"

				hosts_listsqr="$(echo ${hosts_lists} | tr ' ' '\t')" # Newlines are added back in on settings import
				printf "hosts_listsqr='$hosts_listsqr'\n" >> "$filepath/settings/quickrun"

				printf "redirectipqr='$redirectip'\n" >> "$filepath/settings/quickrun"
				
				printf "whitelistsqr='$whitelists'\n" >> "$filepath/settings/quickrun"
				printf "cleanqr='$clean'\n" >> "$filepath/settings/quickrun"
				
				printf "installqr='$installhl'\n" >> "$filepath/settings/quickrun"

				$DIALOG --clear --backtitle "Host Flash" --title "Quick Run Enabled" --msgbox "The next time you use Host Flash you will be presented with a Quick Run menu.\n\nRunning Quick Run will cause Host Flash to reuse the settings saved from this session.\n\nQuick Run can be disabled using the Quick Run menu." 0 0

				;;

			1)

				$DIALOG --clear --backtitle "Host Flash" --title "Quick Run Not Enabled" --msgbox "" 0 0

				;;

		esac

	fi

case $installhl in

	0)

		# When Host Flash is first used, create backup of hosts file. Do not recreate this backup if it already exists
		if test ! -f "/etc/hosts.hf.original"
		then

			# Add event to run.log
			printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): CREATED BACKUP OF /ETC/HOSTS" >> "$filepath/log/run.log"

			printf "\nCopying original hosts file /etc/hosts.hf.original..\n"
			sudo cp /etc/hosts /etc/hosts.hf.original
		fi

		# Backup the host file that is being replaced
		if test ! -d "$filepath/backup"
		then

			# Add event to run.log
			printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): CREATED BACKUP DIRECTORY" >> "$filepath/log/run.log"

			mkdir "$filepath/backup"
		fi

		# Add event to run.log
		printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): CREATED ZIPPED HOSTS BACKUP" >> "$filepath/log/run.log"

		printf "\nCreating hosts file backup for the backup archive..\n"

		zip -j9 "$filepath/backup/hosts-backup-$todaytime.zip" /etc/hosts

		# Add event to run.log
		printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): INSTALLED NEW HOSTS FILE" >> "$filepath/log/run.log"

		printf "\nInstalling new hosts file..\n"

		sudo mv "$filepath/hosts" /etc/hosts

		# Tell the user we are all done
		$DIALOG --clear --backtitle "Host Flash" --title "Finished" --msgbox "New hosts file block list installed.\n\nThe original hosts lists that existed before Host Flash was first used can always be found at /etc/hosts.hf.original\n\nThe file replaced today has been moved to $filepath/backup/hosts-backup-$todaytime.zip\n\nCheck https://host-flash.com for updates." 0 0

		leave_program
		;;

	1)

		$DIALOG --clear --backtitle "Host Flash" --title "Finished" --msgbox "The new hosts file can is ready for review at $filepath/hosts\n\nYou can install the file manually by moving it to /etc/hosts\n\nCheck https://host-flash.com for updates." 0 0

		leave_program
		;;

	255)

		$DIALOG --clear --backtitle "Host Flash" --title "Cancelled" --msgbox "Esc pressed." 0 0

		leave_program
		;;

esac