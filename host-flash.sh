#!/bin/bash
clear
###
#
#	Host Flash™ v2.7.1
#
#	Lead Author: Lee Hodson
#	Donate: paypal.me/vr51
#	Website: https://host-flash.com
#	First Written: 18th Oct. 2015
#	First Release: 2nd Nov. 2015
#	This Release: 6th July. 2017
#
#	Copyright 2015 Host Flash™ <https://host-flash.com>
#	License: GPL3
#
#	Programmer: Lee Hodson <journalxtra.com>, VR51 <vr51.com>
#
#	Use of this program is at your own risk
#
#	TO RUN:
#
#	- Ensure the script is executable.
#	- Run script from its installation directory
#	- Command line: bash host-flash.sh or ./host-flash.sh
#	- File browser: click host-flash.sh
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

version="v2.7.1"
title="Host Flash"
debugMode="false" # Set to "true" to force the program to pause after each significant step

# Establish Linux epoch time in seconds
now=$(date +%s)

# Establish both Date and Time
todaytime=$(date +"%Y-%m-%d-%H:%M:%S")

# Locate Where We Are
filepath="$(dirname "$(readlink -f "$0")")"

# A Little precaution
cd "$filepath"


###
#
#	Register add_to_log function
#		Use as add_to_log "MESSAGE"
#		Set variable debugMode='true' to enable program execution pause after each message.
#
###

add_to_log() {
	# Add to log file
	printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): $1" >> "$filepath/log/run.log"
	# Print to screen
	# Convert $1 to all lowercase then capitalise initial letter.
	x=$1
	x=${x,,}
	x=${x^}
	printf "\n$(date +"%Y-%m-%d-%H:%M:%S"): $x\n"
	if test "$debugMode" == "true" ; then
		printf "\nPaused. Press any key to continue."
		read something
		printf "\nContinuing...\n"
	fi
}


###
#
#	Add Start Time to run.log
#
###

add_to_log "RUN START"


##
#
# Make Program Directories. We make them now otherwise the log directory cannot be written to.
#
##

programdirectories=( 'temp' 'log' 'log/updates' 'backup' 'custom' 'docs' 'settings' )
for i in "${programdirectories[@]}"; do

	if test ! -d "$filepath/$i"
	then
		mkdir "$filepath/$i"
		add_to_log "CREATED DIRECTORY '$i' in $filepath/$i"
	fi

done


###
#
#	Set Dialogue Program
#		In this case we use first try to use 'dialog' then, if dialog is not installed, we try to use 'whiptail'. We could add or use any other dialog compatible program to the list.
#		The colour palette used by whiptail is controlled by newt. It can be configured with 'sudo update-alternatives --config newt-palette'
#		The colour palette used by dialog can be set by issuing command 'dialog --create-rc ~/.dialogrc'. The file .dialogrc can be edited as needed.
#
###

if test ! -f "$filepath/settings/dialogrc"
then
	DIALOGRC="$filepath/settings/dialogrc"
fi

dialoguesystem=( dialog whiptail kdialog zenity xdialog )
for i in ${dialoguesystem[@]} ; do
	if command -v $i > /dev/null 2>&1; then
		DIALOG=$i
		break
	else
		DIALOG='textMode'
	fi
done

# Ignore -- for testing
#DIALOG=dialog
#DIALOG=whiptail
#DIALOG=textMode

add_to_log "SET DIALOGUE PROGRAM TO $DIALOG"


###
#
#	Dialogue Abstraction Layer
#
###

sayMessage() {

	# 1 = Backtitle
	# 2 = Title
	# 3 = Type (--msgbox)
	# 4 = Message
	
	# sayMessage "$backtitle" "$title" "$type" "$message"
	
	# Example:
	#
	# message="Tell me what to say." // Set the message to be displayed
	# sayMessage "$title" "Update Notice" "--msgbox" "$message" // Call the function sayMessage, set parameters, feed $message into it.

	case $DIALOG in
	
		dialog)
			lb="\n\n\n"
			$DIALOG --clear --backtitle "$1" --title "$2" "$3" "$4" 0 0
			;;
		whiptail)
			$DIALOG --clear --backtitle "$1" --title "$2" "$3" "$4" 0 0
			;;
		textMode)
			printf "$4\n"
			read something
			;;
			
	esac

}


sayQuestion() {

	# 1 = Backtitle
	# 2 = Title
	# 3 = Default Answer (--defaultno, --defaultyes)
	# 4 = Type (--yesno)
	# 5 = Question

	# sayQuestion "$backtitle" "$title" "$default" "$type" "$question"
	# hookVariable=$sayQuestion
	# Do something with $hookVariable
	
	# Example:
	#
	# question="What can I echo back to you?" // Set the question text
	# sayQuestion "$title" "Restore?" "--defaultno" "--yesno" "$question" // Call the sayQuestion function, set the parameters, feed $question into it.
	# answer=$sayQuestion // Push the output of sayQuestion into a variable
	# echo $answer // Do something with the variable
	
	case $DIALOG in
	
		dialog)
			lb="\n\n\n"
			$DIALOG --clear --backtitle "$1" --title "$2" "$3" "$4" "$5" 0 0
			printf "$?"
			;;
		whiptail)
			$DIALOG --clear --backtitle "$1" --title "$2" "$3" "$4" "$5" 0 0
			printf "$?"
			;;
		textMode)
			lb="\n"
			prompt_confirm() {
			while true; do
				printf "$1 [y/n] "
				read REPLY
				case $REPLY in
				[yY])
					printf "$REPLY"
					return 0
					;;

				[nN])
					printf "$REPLY"
					return 1
					;;
				255)
					exit
					;;
				*)
					printf " \033[31m %s \n\033[0m" "Invalid answer. "
				esac
			done
			}
			prompt_confirm "$5"
			;;
			
	esac

}


###
#
#	Register leave_program function
#		Use as leave_program "EXIT STATUS TO LOG" "MESSAGE TO USER"
#
###

leave_program() {

	exittime=$(date +%s)
	runtime=$(($exittime - $now))
	
	add_to_log "RUN END: $1"
	add_to_log "PROGRAM RUN TIME: $runtime seconds"

	# Convert $1 & $2 to all lowercase then capitalise initial letter of each.
	x=$1
	x=${x,,}
	x=${x^}

	y=$2
	y=${y,,}
	y=${y^}
	
	message="$y
	$lb
	Visit https://host-flash.com to learn more about $title, hosts files and to grab program updates.
	$lb
	Sponsor program development. Send donations to paypal.me/vr51
	$lb
	Thank You for using $title.
	$lb
	Program Run Time: $runtime seconds"
		
	sayMessage "$title" "$x" "--msgbox" "$message"

	exit

}


###
#
#	Capture interrupt signals
#
###

trap "leave_program 'Program stopped prematurely.'" SIGHUP SIGINT SIGTERM


###
#
#	Confirm we are running in a terminal
#		If not, try to launch this program in a terminal
#
###

tty -s

if test "$?" -ne 0
then

	terminal=( konsole gnome-terminal x-terminal-emulator xdg-terminal terminator urxvt rxvt Eterm aterm roxterm xfce4-terminal termite lxterminal xterm )
	for i in ${terminal[@]}; do
		if command -v $i > /dev/null 2>&1; then
			exec $i -e "$0"
			break
		else
			leave_program "LAUNCH ERROR" "UNABLE TO AUTOMATICALLY FIND SUITABLE COMMAND LINE TERMINAL. RESTART $title WITHIN A TERMINAL."
		fi
	done

fi

add_to_log "CHECKED FOR TERMINAL PROGRAM"

###
#
#	Check for required software dependencies
#
###

add_to_log "CHECKING SOFTWARE ENVIRONMENT...\n"

error=0

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

add_to_log "CHECKED SOFTWARE ENVIRONMENT"

# Check for critical errors and warning errors. Set critical flag if appropriate.

critical=0

if test ${statusflag[0]} = 1 && test ${statusflag[1]} = 1; then
	add_to_log "%4SCRITICAL:%6S NEITHER 'DIALOG' NOR 'WHIPTAIL' IS INSTALLED."
	critical=1
fi

if test ${statusflag[2]} = 1; then
	add_to_log "%4SCRITICAL:%6S ZIP IS NOT INSTALLED."
	critical=1
fi

if test "${statusflag[4]}" = 1; then
	add_to_log "%4SWARNING:%6S EITHER 'P7ZIP' OR 'P7ZIP-FULL' IS NOT INSTALLED. $title WILL RUN WITH REDUCED CHOICE OF BLACKLIST DOWNLOAD SOURCES."
fi

if test ${statusflag[5]} = 1; then
	add_to_log "%4SCRITICAL:%6S 'WGET' IS NOT INSTALLED."
	critical=1
fi

if test ${statusflag[6]} = 1; then
	add_to_log "%4SCRITICAL:%6S 'SED' IS NOT INSTALLED."
	critical=1
fi

# Display appropriate status messages

if test "$error" == 0 && test "$critical" == 0; then
	add_to_log "THE SOFTWARE ENVIRONMENT IS OPTIMAL FOR THIS PROGRAM."
fi

if test "$error" == 1 && test "$critical" == 0; then
	add_to_log "NON ESSENTIAL SOFTWARE REQUIRED BY $title IS MISSING FROM THIS SYSTEM. IF $title FAILS TO RUN, CONSIDER TO INSTALL WITH, FOR EXAMPLE,\n\n%6ssudo apt-get install ${whattoinstall[*]}"
fi

if test "$critical" == 1; then
	leave_program "CRITICAL ERROR" "ESSENTIAL SOFTWARE DEPENDENCIES ARE MISSING FROM THIS SYSTEM. $title WILL STOP HERE. INSTALL MISSING SOFTWARE WITH, FOR EXAMPLE,\n\n%6ssudo apt-get install ${whattoinstall[*]}\n\nTHEN RUN $title AGAIN."
fi


###
#
#	Obtain Authorisation to Install Hosts
#
###

printf "\n\nAUTHORISATION\n-------------\n"

printf "\nAuthorise Host Flash to backup, restore, edit and replace the hosts file:\n"
sudo -v

add_to_log "ASKED FOR AUTHORISATION"


##
#
#	Create Backup of Existing Hosts File
#
##

zip -j9 "$filepath/backup/hosts-backup-$todaytime.zip" /etc/hosts

add_to_log "CREATED ZIPPED BACKUP COPY OF EXISTING HOSTS FILE AS $filepath/backup/hosts-backup-$todaytime.zip"


##
#
#	Run Setup and Confirm Default Dirctories and Files Exist (Recreate as necessary), Run Upgrade Routines If This is an Upgrade
#
##


# Display Update Message and Run Post Update Actions

if test ! -f "$filepath/log/updates/version-$version"
then

	message="$title $version Installed.$lb
	$title now includes a program update feature.$lb
	Important:$lb
	The custom whitelists and the custom blocklist now reside in directory 'Host Flash/custom'.$lb
	The existing files will be moved automatically when you click 'OK'.$lb
	Important: $title now has an update feature.$lb
	Read $filepath/docs/change.log to see brief list of changes brought in by this version of $title.$lb
	Visit host-flash.com/blog to read more about changes in $title $version and to stay up-to-date with program developments."

	sayMessage "$title" "Update Notice" "--msgbox" "$message"

	touch "$filepath/log/updates/version-$version"
	printf "Delete this file to re-enable the version update information prompt and to rerun the upgrade process that displayed when $title updated to version $version." > "$filepath/log/updates/version-$version"

	add_to_log "DISPLAYED UPDATE NOTICE"

	##
	#
	#	Run post update actions
	#
	#	If directories and files need to be created, moved, downloaded or deleted then this is where it is done.
	#
	##

	# Move Files

    upgradeMoveFiles=( "whitelist.txt" "whitelist-wild.txt" "blocklist.txt" "LICENSE" "change.log" )
    upgradeMoveFilesFrom=( "$filepath" "$filepath" "$filepath" "$filepath" "$filepath" )
    upgradeMoveFilesTo=( "$filepath/custom" "$filepath/custom" "$filepath/custom" "$filepath/docs" "$filepath/docs" )
	for i in "${upgradeMoveFiles[@]}"; do

		if test -f "${upgradeMoveFilesFrom[0]}/$i"
		then
			# Include subdirectory directory
			mv "${upgradeMoveFilesFrom[0]}/$i" "${upgradeMoveFilesTo[0]}/$i"
			add_to_log "MOVED FILE '$i' in ${upgradeMoveFilesFrom[0]}/$i to ${upgradeMoveFilesTo[0]}/$i"
		fi
		upgradeMoveFilesFrom=("${upgradeMoveFilesFrom[@]:0:0}" "${upgradeMoveFilesFrom[@]:1}")
		upgradeMoveFilesTo=("${upgradeMoveFilesTo[@]:0:0}" "${upgradeMoveFilesTo[@]:1}")

	done
	
	# Add Files
	
	upgradeAddNewFiles=( 'custom/whitelist.txt' 'custom/whitelist-wild.txt' 'custom/blocklist.txt' 'temp/hosts-temp.txt' )
	for i in "${upgradeAddNewFiles[@]}"; do

		if test ! -f "$filepath/$i"
		then
			touch "$filepath/$i"
			add_to_log "CREATED NEW FILE '$i' in $filepath/$i"
		fi

	done

	# Download missing files

	programdirectories=( 'docs/LICENSE' 'docs/change.log' 'README.md' )
	programfiles=( 'LICENSE' 'change.log' 'README.md' )
	for i in "${programdirectories[@]}"; do

		if test ! -f "$filepath/$i"
		then
			wget "https://raw.githubusercontent.com/VR51/host-flash/master/${programfiles[0]}" -O "$filepath/$i"
			add_to_log "DOWNLOADED MISSING FILE '$i' in $filepath/$i"
		fi
		programfiles=("${programfiles[@]:0:0}" "${programfiles[@]:1}")
	done
	
	# Remove Files
	
	upgradeRemoveOldFiles=( 'readme.txt' 'host-flash.desktop' 'settings/.showonce' 'hosts' )
	for i in "${upgradeRemoveOldFiles[@]}"; do

		if test -f "$filepath/$i"
		then
			rm "$filepath/$i"
			add_to_log "REMOVED OBSOLETE FILE '$i'"
		fi

	done
	
	# Remove Obsolete Directories
	
	upgradeRemoveOldDirectories=( 'TEMP' )
	for i in "${upgradeRemoveOldDirectories[@]}"; do

		if test -d "$filepath/$i"
		then
			rm -r "$filepath/$i"
			add_to_log "REMOVED OBSOLETE DIRECTORY '$i'"
		fi

	done

    # Wondering why program directories are not added here? They are created earlier in the program.
    
    add_to_log "RAN POST UPDATE ACTIONS"
	
fi


###
#
#	Check for Quick Run Saved Settings. Ask to Import Quick Run Variables if Set
#
###

if test -f "$filepath/settings/quickrun"
then

	add_to_log "CHECKED FOR QUICKRUN"

	quickrun="$($DIALOG --stdout \
			--clear \
			--backtitle "$title" \
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

			add_to_log "QUICKRUN SETTINGS USED"
			;;

		No)
			add_to_log "QUICKRUN SETTINGS NOT USED"
			;;

		Delete)

			rm "$filepath/settings/quickrun"
			
			message="Quick Run can be reconfigured at the end of this program session."
			
			sayMessage "$title" "Quick Run Settings Deleted" "--msgbox" "$message"
			
			add_to_log "QUICKRUN SETTINGS DELETED"
			;;

		255)

			leave_program "CANCELLED" "PROGRAM STOPPED BY USER."
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

	question="Download and install $title program update?$lb
	Use this option to download the latest version of $title or to (re)install $title documentation files."
	
	sayQuestion "$title" "Update Host Flash" "--defaultno" "--yesno" "$question"
	updatehf=$sayQuestion

fi

case $updatehf in

                0)
                
                        # Update Host Flash
                        
                        wget -q https://raw.githubusercontent.com/VR51/host-flash/master/LICENSE -O "$filepath/docs/LICENSE"
                        wget -q https://raw.githubusercontent.com/VR51/host-flash/master/change.log -O "$filepath/docs/change.log"
                        wget -q https://raw.githubusercontent.com/VR51/host-flash/master/README.md -O "$filepath/README.md"
                        wget -q https://raw.githubusercontent.com/VR51/host-flash/master/host-flash.sh -O "$filepath/host-flash.sh"
                        
                        add_to_log "UPDATED HOST FLASH PROGRAM FILES"
                        
                        printf "\nProgram will restart when you press a key."
                        read something
                        
                        exec bash "$filepath/host-flash.sh"
                        
                        ;;
                        
                1)
                        
                        ;;
                        
                255)
                
                        leave_program "CANCELLED" "PROGRAM STOPPED BY USER."
                        ;;
                        
esac


###
#
#	Introduction
#
###

if test "$quickrun" != "On"
then

	message="General Information.
	$lb
	$title installs a blacklist of web hosts (AKA website domain names) that are known to serve ads, malware, undesirable, inapropriate or questionable content.
	$lb
	Read the documentation that came with $title to learn more about this program.
	$lb
	More information about this program, hosts files and Linux computer security can be read at https://host-flash.com.
	$lb
	Run $title daily or weekly to keep your blacklist up-to-date and your computer safe."

	sayMessage "$title" "$title Protects Computers & Blocks Internet Ads" "--msgbox" "$message"

	add_to_log "SHOWED INTRODUCTION TEXT"

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

		question="Would you like to restore the original hosts file that $title replaced the very first time $title ran on this computer? This will overwrite the current hosts file."
		
		sayQuestion "$title" "Restore Original Hosts File?" "--defaultno" "--yesno" "$question"		
		restore=$sayQuestion
		

	fi

	case $restore in

		0)

			sudo mv /etc/hosts.hf.original /etc/hosts

			message="The original hosts file has been restored."
			
			sayMessage "$title" "Finished" "--msgbox" "$message"
			
			leave_program "HOSTS FILE RESTORED" "THE ORIGINAL HOSTS FILE HAS BEEN RESTORED."
			;;

		1)

			question="Do you want to remove the blocklist installed by $title from the existing hosts file?
			$lb
			Select 'Yes' if you want to deactivate $title and undo the edits made to your hosts file by $title, otherwise select 'no'."
			
			sayQuestion "$title" "Deactivate Hosts Blocklist?" "--defaultno" "--yesno" "$question"			
			remove=$sayQuestion
			
			;;

		255)

			leave_program "CANCELLED" "PROGRAM STOPPED BY USER."
			;;

	esac


	case $remove in

		0)

			sudo sed -i '/#### Hosts Flash Bad Hosts Block ########/,$d' /etc/hosts

			message="$title bad hosts blocklist has been removed from your hosts file."
			
			sayMessage "$title" "Finished" "--msgbox" "$message"

			leave_program "BLACKLIST UNINSTALLED" "THE HOSTS BLACKLIST HAS BEEN REMOVED FROM THE SYSTEM'S HOSTS FILE"
			;;

		255)

			leave_program "CANCELLED" "PROGRAM STOPPED BY USER."
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
				--backtitle "$title" \
				--separate-output \
				--checklist 'Choose the hosts blacklists to install. Lists that interfere least with regular web browsing are preselected.' 0 0 0 \
				hosts-file.net 'Liberal: Blocks mostly adware, spyware, malware and trackers. Big list.' On \
				mvps.org 'Liberal: Blocks mostly adware, spyware, malware and trackers. Big list.' On \
				someonewhocares.org 'Liberal: Blocks mostly adware, spyware, malware and trackers. This is the Dan Pollock list. Small list.' On \
				adaway.org 'Liberal: Blocks adware. Small list.' On \
				malwaredomainlist.com 'Liberal: Blocks mostly malware. Small list.' On \
				free.fr-Ad-Servers 'Moderate: Blocks ad servers.' On \
				free.fr-Malware 'Moderate: Blocks reported malware sites.' On \
				free.fr-Trackers 'Moderate: Blocks tracking services, analytic services and spyware.' Off \
				free.fr-Adult 'Moderate: Blocks pornography. Coincidentally blocks forums and some social sites.' Off \
				free.fr-Misc 'Moderate: Blocks miscellaneous sites that some consider undesirable.' Off \
				hostsfile.org 'Very Strict: Regular blocks + porn, gambling and gaming sites.' Off \
				)"
	fi

	if test "${statusflag[4]}" = 1
	then

		hosts_lists="$($DIALOG --stdout \
				--clear \
				--backtitle "$title" \
				--separate-output \
				--checklist 'Choose the bad hosts block-lists to install. Lists that interfere least with regular web browsing are preselected.' 0 0 0 \
				hosts-file.net 'Liberal: Blocks mostly ad servers, malware sites and trackers' On \
				mvps.org 'Liberal: Blocks mostly ad servers, malware sites and trackers' On \
				someonewhocares.org 'Liberal: Blocks mostly adware, spyware, malware and trackers. This is the Dan Pollock list. Small list.' On \
				adaway.org 'Liberal: Blocks adware. Small list.' On \
				malwaredomainlist.com 'Liberal: Blocks mostly malware. Small list.' On \
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
	--backtitle "$title" \
	--radiolist 'Set the Redirect IP Address' 0 0 0 \
	0.0.0.0 'localhost (default)' On \
	127.0.0.1 'localhost' Off \
	127.255.255.254 'localhost' Off \
	Custom 'Type in a Preferred IP Address' Off \
	)"

	case $redirectip in

		Custom) redirectip="$($DIALOG --stdout --clear --backtitle "$title" --inputbox 'Enter the IP address' 0 0 '127.0.0.1')"

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

	question="Download and install the Community Whitelists?"
	
	sayQuestion "$title" "Install Community Whitelists?" "--defaultno" "--yesno" "$question"	
	whitelists=$sayQuestion

fi


####
#
#	Install Community Blacklist
#
###

if test "$quickrun" = "On"
then # Use saved answer if quick run enabled

	blacklist=$blacklistqr

fi

if test "$quickrun" != "On"
then

	question="Download and install the Community Blocklist?"
	
	sayQuestion "$title" "Install Community Blocklist?" "--defaultno" "--yesno" "$question"	
	blacklist=$sayQuestion

fi


###
#
#	Download Host Files, Merge Host Files and Clean up
#	Look at hosts_lists DIALOG box for more info
#
##

cd "$filepath/temp/"

for opt in $hosts_lists
do

	case "$opt" in
	
		###
		#
		#	download=Download URL
		#	dfile=Download file
		#	target=The file we want to use from the download file (handy for zip files)
		#	unzipprog=The program to use to extract the target file from dfile
		#
		###

		hosts-file.net)
				download=http://hosts-file.net/download
				dfile=hosts.zip
				target=hosts.txt
				unzipprog='unzip'
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
				
		someonewhocares.org)
				download=http://someonewhocares.org/hosts
				dfile=hosts
				target=hosts
				unzipprog=''
				;;
				
		adaway.org)
				# download=https://adaway.org ## File fails to download from here. Using GitHub version instead.
				download=https://github.com/Free-Software-for-Android/AdAway/blob/master/hosts
				dfile=hosts.txt
				target=hosts.txt
				unzipprog=''
				;;
				
		malwaredomainlist.com)
				download=http://www.malwaredomainlist.com/hostslist
				dfile=hosts.txt
				target=hosts.txt
				unzipprog=''
				;;

		hostsfile.org)
				download=http://www.hostsfile.org/Downloads
				dfile=hosts.txt
				target=hosts.txt
				unzipprog=''
				;;
				
	esac

	wget -q "$download/$dfile" -O "$filepath/temp/$dfile"

	add_to_log "DOWNLOADED HOSTS BLACKLIST FROM $download/$dfile"
	
	if test "$unzipprog" = 'unzip'; then unzip -o "$filepath/temp/$dfile"; fi
	if test "$unzipprog" = 'p7zip'; then 7z e -y "$filepath/temp/$dfile"; fi
	
	cat "$filepath/temp/$target" >> "$filepath/temp/hosts-temp.txt"
	
	if test -f "$filepath/temp/hosts.txt" ; then rm "$filepath/temp/hosts.txt" ; fi
	if test -f "$filepath/temp/HOSTS" ; then rm "$filepath/temp/HOSTS" ; fi
	if test -f "$filepath/temp/hosts" ; then rm "$filepath/temp/hosts" ; fi
	rm "$filepath/temp/$dfile"

	# Establish credits to add to the hosts file header
	credits+=("# Includes hosts blacklist from $download/$dfile\n")
	
	add_to_log "MERGED '$filepath/temp/$target' INTO $filepath/temp/hosts-temp.txt"
	
done

cd "$filepath"

###
#
#	Prepare New Hosts File
#
##


#	Format Data in hosts-temp.txt

add_to_log "PREPARING NEW HOSTS FILE.."

sed -i 's/#.*//' "$filepath/temp/hosts-temp.txt" # Remove all comments (some come after hostname <-> IP map lines)
iconv -c -t UTF-8//TRANSLIT "$filepath/temp/hosts-temp.txt" > "$filepath/temp/hosts-utf8.txt" # Convert non UTF8 characters to fix comment fault in French lists.
	rm "$filepath/temp/hosts-temp.txt"
	mv "$filepath/temp/hosts-utf8.txt" "$filepath/temp/hosts-temp.txt"
sed -i 's/^[^01-9].*//' "$filepath/temp/hosts-temp.txt" # Remove any line that does not begin with a number
sed -i '/.*\blocalhost\b.*/d' "$filepath/temp/hosts-temp.txt" # Remove localhost lines - the computer's installed host file already has localhost defined the way it should be
sed -i '/^$/d' "$filepath/temp/hosts-temp.txt" # Remove empty lines

sed -i "s/^[01-9\.].*[ \t]/$redirectip /g" "$filepath/temp/hosts-temp.txt" # Replace with a single space and the new IP address everything up to, and including, the first tab(s) or space(s) in each line


###
#
#	Get head of the existing hosts file stored at /etc/hosts
#
###

#	Remove old Host Flash blacklist from existing hosts file, assuming blacklist exists
#	Remove empty lines from the end of the header
#	This creates file hosts.copy which is used a few lines down from here

cp /etc/hosts "$filepath/temp/hosts.copy"
sed -i '/#### Hosts Flash Bad Hosts Block ########/,$d' "$filepath/temp/hosts.copy"
sed -i 's/\n\n/\n/' "$filepath/temp/hosts.copy" # First Pass: Ensuring we don't have hundreds of successive newlines
sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' "$filepath/temp/hosts.copy" # Second Pass: Ensuring we don't have hundreds of successive newlines
printf '\n\n#### Hosts Flash Bad Hosts Block ########\n\n# Credits\n\n' >> "$filepath/temp/hosts.copy"

for i in "${credits[@]}" ; do
	printf "$i" >> "$filepath/temp/hosts.copy"
done

printf "\n\n# Installed with $title $version\n\n# Visit host-flash.com to learn more\n\n" >> "$filepath/temp/hosts.copy"

add_to_log "HOSTS FILE HEADER PREPARED"


###
#
#	Install community blacklist
#
###

if test "$blacklist" = "0" ; then

    printf "\nInstalling Community Blacklist..\n"

    # Download community whitelist.txt and mix it with the existing custom whitelist

    wget -q "https://gist.githubusercontent.com/VR51/ef3b90b1be2693a44f27/raw/a31adff448fb854c81009493b74fd2c4466ee3ef/blocklist.txt" -O "$filepath/temp/blocklist.txt"

    if test -s "$filepath/custom/blocklist.txt" ; then
        printf "\n" >> "$filepath/custom/blocklist.txt"
        cat "$filepath/custom/blocklist.txt" "$filepath/temp/blocklist.txt" > "$filepath/temp/blocklist-merged.txt"
        rm "$filepath/custom/blocklist.txt"
    fi

    sort -u -f "$filepath/temp/blocklist-merged.txt" > "$filepath/custom/blocklist.txt"

fi

#	Format and use custom blacklist

if test -s "$filepath/custom/blocklist.txt"
then

	cp "$filepath/custom/blocklist.txt" "$filepath/temp/blocklist.txt"

	sed -r -i "s/^(.*)/$redirectip \1/g" "$filepath/temp/blocklist.txt"
	printf "\nAdding custom bad hosts to the hosts list..\n"
	printf '\n' >> "$filepath/temp/blocklist.txt" # Precaution
	
	cat "$filepath/temp/blocklist.txt" >> "$filepath/temp/hosts-temp.txt"

	add_to_log "MERGED CUSTOM BLOCKLIST.TXT WITH $filepath/temp/blocklist.txt"
	
fi


###
#
#	Install community whitelist
#
###

if test "$whitelists" = "0" ; then

    printf "\nInstalling Community Whitelists..\n"

    # Download community whitelist.txt and mix it with the existing custom whitelist

    wget -q "https://gist.githubusercontent.com/VR51/7eaace2b6778ea508996/raw/ad90168c61e926d462895b190ad84e37f4e5c99e/whitelist.txt" -O "$filepath/temp/whitelist.txt"

    if test -s "$filepath/custom/whitelist.txt" ; then
        printf "\n" >> "$filepath/custom/whitelist.txt"
        cat "$filepath/custom/whitelist.txt" "$filepath/temp/whitelist.txt" > "$filepath/temp/whitelist-merged.txt"
        rm "$filepath/custom/whitelist.txt"
    fi

    sort -u -f "$filepath/temp/whitelist-merged.txt" > "$filepath/custom/whitelist.txt"

    # Download community whitelist-wild.txt and mix it with the existing custom whitelist-wild

    wget -q "https://gist.githubusercontent.com/VR51/9798c78337fe2f7ad589/raw/2bd44e16c624650d5022815a13a9b0873738900d/whitelist-wild.txt" -O "$filepath/temp/whitelist-wild.txt"

    if test -s "$filepath/custom/whitelist-wild.txt" ; then
        printf "\n" >> "$filepath/custom/whitelist-wild.txt"
        cat "$filepath/custom/whitelist-wild.txt" "$filepath/temp/whitelist-wild.txt" > "$filepath/temp/whitelist-wild-merged.txt"
        rm "$filepath/custom/whitelist-wild.txt"
    fi

    sort -u -f "$filepath/temp/whitelist-wild-merged.txt" > "$filepath/custom/whitelist-wild.txt"

    add_to_log "DOWNLOADED COMMUNITY WHITELISTS AND MERGED WITH (ANY) EXISTING CUSTOM WHITELISTS"
    
fi


###
#
#	Remove any whitelisted hosts
#
###

#	Sort content and remove duplicates

if test -s "$filepath/custom/whitelist.txt"
then

	add_to_log "RE-ENABLING HOSTS WHITELISTED IN 'whitelist.txt'. THIS MAY TAKE SEVERAL MINUTES..."

	sort -u -f "$filepath/custom/whitelist.txt" > "$filepath/temp/whitelist.txt"

	# Iterate through non wildcard domain list

	while read -r LINE
	do
		# sed -r -i "s/($redirectip $LINE(.*)?)$/# \1/g" "$filepath/temp/hosts-temp.txt" # This method comments out whitelisted hostnames
		sed -r -i "s/$redirectip $LINE.*?$//g" "$filepath/temp/hosts-temp.txt" # This method removes whitelisted hostnames

	done <"$filepath/temp/whitelist.txt"
	
	add_to_log "REMOVED WHITELIST.TXT HOSTS"

fi

if test -s "$filepath/custom/whitelist-wild.txt"
then

	add_to_log "RE-ENABLING HOSTS WHITELISTED IN 'whitelist-wild.txt'. THIS MAY TAKE SEVERAL MINUTES..."

	sort -u -f "$filepath/custom/whitelist-wild.txt" > "$filepath/temp/whitelist-wild.txt"

	# Iterate through wildcard domain list

	while read -r LINE
	do
		# sed -r -i "s/($redirectip (.*\.)$LINE(.*)?)$/# \1/g" "$filepath/temp/hosts-temp.txt" # This method comments out whitelisted hostnames
		sed -r -i "s/$redirectip .*\.$LINE.*?$//g" "$filepath/temp/hosts-temp.txt" # This method removes whitelisted hostnames

	done <"$filepath/temp/whitelist-wild.txt"
	
	add_to_log "REMOVED WHITELIST-WILD.TXT HOSTS"

fi


###
#
#	Organise and remove duplicate entries from the new hosts lists and build them into the new hosts file
#
###

	add_to_log "FINALISING THE NEW HOSTS BLACKLIST"
	
	sort -u -f -b "$filepath/temp/hosts-temp.txt" > "$filepath/temp/hosts"
	
	sed -i '/^$/d' "$filepath/temp/hosts"

	add_to_log "NEW HOSTS BLACKLIST READY FOR INSTALLATION"

	
###
#
#	Restore Default hosts file's head (restore anything above the line #### Hosts Flash Bad Hosts Block ######## of the existing hosts file)
#
###

cat "$filepath/temp/hosts.copy" "$filepath/temp/hosts" > "$filepath/hosts" #  We use hosts-temp so we don't overwrite the temp. hosts file (in case it's needed later)

add_to_log "MERGED NEW HOSTS BLACKLIST WITH ORIGINAL HOSTS FILE HEAD"

###
#
#	Remove temp directory
#
###

if test -d "$filepath/temp"
then

	rm -r "$filepath/temp"
	
	add_to_log "DELETED TEMP DIRECTORY"
	
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

	question="Install the new hosts file?"
	
	sayQuestion "$title" "Install Hosts File?" "--defaultno" "--yesno" "$question"
	
	installhl=$sayQuestion

fi

	##
	#
	#	A Quick Detour... Asking now so the user doesn't miss out
	#
	##


	if test ! -f "$filepath/settings/quickrun"
	then

		question="Save $title settings to reuse the next time Host Flash runs?"

		sayQuestion "$title" "Enable Quick Run?" "--defaultno" "--yesno" "$question"
		quickrun=$sayQuestion

		case $quickrun in

			0)

				touch "$filepath/settings/quickrun"

				printf "#!/bin/bash\n" > "$filepath/settings/quickrun"

				printf "quickrun='On'\n" >> "$filepath/settings/quickrun"
				
				printf "updatehfqr='$updatehf'\n" >> "$filepath/settings/quickrun"

				hosts_listsqr="$(echo ${hosts_lists} | tr ' ' '\t')" # Newlines are added back in on settings import
				printf "hosts_listsqr='$hosts_listsqr'\n" >> "$filepath/settings/quickrun"

				printf "redirectipqr='$redirectip'\n" >> "$filepath/settings/quickrun"
				
				printf "whitelistsqr='$whitelists'\n" >> "$filepath/settings/quickrun"
				printf "blacklistqr='$blacklist'\n" >> "$filepath/settings/quickrun"
				
				printf "installqr='$installhl'\n" >> "$filepath/settings/quickrun"

				message="The next time you use Host Flash you will be presented with a Quick Run menu.$lb
				Running Quick Run will cause Host Flash to reuse the settings saved from this session.$lb
				Quick Run can be disabled using the Quick Run menu."
				
				sayMessage "$title" "Quick Run Enabled" "--msgbox" "$message"
				
				add_to_log "CREATED QUICKRUN CONFIG FILE"

				;;

			1)

				message="Quick run can be enabled the next time $title is run."
				
				sayMessage "$title" "Quick Run Not Enabled" "--msgbox" "$message"

				;;
				
			255)

				leave_program "CANCELLED" "PROGRAM STOPPED BY USER."
				;;

		esac

	fi

	
case $installhl in

	0)

		# When Host Flash is first used, create backup of hosts file. Do not recreate this backup if it already exists
		if test ! -f "/etc/hosts.hf.original"
		then

			sudo cp /etc/hosts /etc/hosts.hf.original
			add_to_log "CREATED BACKUP OF /ETC/HOSTS AS /etc/hosts.hf.original"
			
		fi

		sudo mv "$filepath/hosts" /etc/hosts
		
		add_to_log "INSTALLED NEW HOSTS FILE TO /etc/hosts"

		# Tell the user we are all done and exit
		leave_program "HOSTS BLACKLIST UPDATED" "THE ORIGINAL HOSTS FILE THAT EXISTED BEFORE HOST FLASH WAS FIRST USED CAN ALWAYS BE FOUND AT /etc/hosts.hf.original\n\nTHE HOSTS FILE REPLACED TODAY HAS BEEN MOVED TO $filepath/backup/hosts-backup-$todaytime.zip."
		;;

	1)

		leave_program "HOSTS FILE READY FOR INSPECTION" "THE NEW HOSTS FILE CAN IS READY FOR REVIEW AT $filepath/hosts\n\nYOU CAN INSTALL THE FILE MANUALLY BY MOVING IT TO /etc/hosts."
		;;

	255)

		leave_program "CANCELLED" "PROGRAM STOPPED BY USER."
		;;

esac
