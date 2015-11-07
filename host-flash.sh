#!/bin/bash
clear
###
#
#	Host Flash (Junior) v1.2.0
#
#	Author: Lee Hodson
#	Donate: paypal.me/vr51
#	First Written: 18th Oct. 2015
#	First Release: 2nd Nov. 2015
#	This Release: 7th Nov. 2015
#
#	https://github.com/VR51/host-flash
#	https://journalxtra.com
#
#	Copyright 2015 Lee Hodson
#	License: GPL3
#
#	Use of this program is at your own risk
#
#	TO RUN either 'bash host-flash.sh' or click the file host-flash.sh
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

printf "HOST FLASH INITIALISED\n----------------------\n\n"

###
#
#	Set Variables
#
###

# Date
todaytime=$(date +"%Y-%m-%d-%H:%M:%S")

# Locate Where We Are
filepath="$(dirname "$(readlink -f "$0")")"


###
#
#	Confirm we are running in a terminal
#		If not, try to launch thIS program in a terminal
#
###

tty -s

if test "$?" -ne 0
then

	# This code section is released in public domain by Han Boetes <han@mijncomputer.nl>
	# Updated by Dave Davenport <qball@gmpclient.org>
	# Updated by Lee Hodson <https://journalxtra.com> - Added break on successful hit, added more terminals, humanized the failure message and replaced call to rofi with printf.
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
			printf "\nUnable to automatically determine the correct terminal program to run e.g Console or Konsole. Please run this program from a terminal AKA the command line or click the host-flash.desktop file to launch Host Flash.\n"
		fi
	done

fi

###
#
#	Check for required software dependencies
#
###

missing=0
for requirement in $REQUIREMENT wget sed dialog whiptail unzip p7zip p7zip-full; do
	if command -v $requirement > /dev/null 2>&1; then
		printf "Checking for software dependencies.. $requirement found. Success! :-)\n"
	else
		printf "Checking for software dependencies.. $requirement MISSING :-(\n"
		printf "\n\t$requirement can be installed with, for example, sudo apt-get install $requirement\n"
		case $requirement in

			whiptail)
				printf "\n\tWe are still okay if 'dialog' is installed\n"
				missing=$(($missing + 1))
				;;

			dialog)
				printf "\n\tWe are still okay if 'whiptail' is installed\n"
				missing=$(($missing + 2))
				;;
			p7zip)
				printf "\n\tWe are still okay if 'p7zip-full' is installed\n"
				missing=$(($missing + 4))
				;;

			p7zip-full)
				printf "\n\tWe are still okay if 'p7zip' is installed\n"
				missing=$(($missing + 8))
				;;
		esac

	fi
done

case $missing in

	3)
		printf "\nUh oh! Host Flash needs either 'whiptail' or 'dialog' to be installed on this computer. Please install one or both of them then rerun Host Flash\n"
		read something
		exit
		;;

	12)
		printf "\nThis is awkward.. Host Flash needs either the 'p7zip' or 'p7zip-full' file extractor to be installed on this computer to enable some features to work. Install p7zip or p7zip-full if you want to use the Airelle Lists of bad hosts. Host Flash will continue but with the Airelle Lists disabled.\n"
		read something
		;;

esac

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
		printf "\nUnable to detect a dialog box program such as 'dialog' or 'whiptail'. Please install one.\n"
	fi
done

###
#
#	Obtain Authorisation to Install Hosts
#
###

printf "\n\nAUTHORISATION\n-------------\n"

printf "\nPlease authorise Host Flash to backup, restore, edit or replace your computer's hosts file:\n"
sudo -v


###
#
#	Check for Quick Run Saved Settings. Ask to Import Quick Run Variables if Set
#
###

if test -f "$filepath/settings/quickrun"
then

	quickrun="$($DIALOG --stdout \
			--clear \
			--backtitle "Host Flash" \
			--radiolist 'Use Quick Run?' 0 0 0 \
			Yes 'Use saved settings.' On \
			No 'Use new settings.' Off \
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

			# Add newlines back into the imported hosts_listings variable. They were removed during settings export
			#hosts_listsqr="$(echo ${hosts_listsqr} | tr '\t' '\n')"
			;;

		No)
			continue
			;;

		Delete)

			rm "$filepath/settings/quickrun"
			$DIALOG --clear --backtitle "Host Flash" --title "Quick Run Settings Deleted" --msgbox "Quick Run can be reconfigured at the end of this program session." 0 0

			;;

		255)

			$DIALOG --clear --backtitle "Host Flash" --title "Cancelled" --msgbox "Esc pressed.\n\nSend donations to paypal.me/vr51" 0 0
			exit
			;;

	esac

fi



###
#
#	Introduction
#
###

if test ! -f "$filepath/settings/.showonce"
then

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

touch "$filepath/settings/.showonce"
printf "Delete this file to re-enable the Host Flash information dialogue box that displays when Host Flash is first run." > "$filepath/settings/.showonce"

fi

###
#
#	Warning Message
#
###

if test "$quickrun" != "On"
then

	$DIALOG --clear \
		--backtitle "Host Flash" \
		--title "Thank You For Using Host Flash" \
		--msgbox "Host Flash blocks computers from accessing content served by certain web hosts. These hosts could, for example, be reported malicious websites, known ad servers, adult websites, gambling sites or torrent sites.
	\n\n
	Host Flash
	\n\n
		- downloads up to 8 bad hosts blocklists,\n
		- merges those lists into one large compilation of bad hosts,\n
		- adds your custom bad hosts list into the mix (blocklist.txt),\n
		- removes duplicate bad host entries from the compiled bad hosts list,\n
		- comments out (unblocks) whitelisted hosts (whitelist.txt),\n
		- copies the hosts file that exists when Host Flash is first run to /etc/hosts.hf.original,\n
		- stores replaced hosts files in archive directory 'Hosts Flash/backup/',\n
		- option to remove previously installed bad hosts added by Host Flash from the existing hosts file,\n
		- retains the original hosts file entries within the hosts file created by Host Flash.
	\n\n
	This process is run interactively so you will be asked to confirm changes before they are made to your system.
	\n\n
	You will not be able to access sites blocked by Host Flash. This means blocked sites will show in your browser as Document Not Found errors or sites that incorporate blocked sites as part of their make up will load but with blocked parts missing from the rendered pages.
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
fi

###
#
#	Remove old working directory if it exists
#
###

if test -d "$filepath/TEMP"
then
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

			$DIALOG --clear --backtitle "Host Flash" --title "Finished" --msgbox "The original hosts file has been restored.\n\nDonate toward the Host Flash Development Fund at paypal.me/vr51" 0 0

			exit
			;;

		1)

			$DIALOG --clear --backtitle "Host Flash" --title "Deactivate?" --defaultno --yesno "Do you want to remove the Host Flash blocklist from the existing hosts file?\n\nSelect 'Yes' if you want to deactivate Host Flash and undo the edits made to your hosts file by Host Flash, otherwise select 'no'." 0 0
			remove=$?

			;;

		255)

			$DIALOG --clear --backtitle "Host Flash" --title "Cancelled" --msgbox "Esc pressed.\n\nSend donations to paypal.me/vr51" 0 0
			exit
			;;

	esac


	case $remove in

		0)

			sed -i '/#### Hosts Flash Bad Hosts Block ########/,$d' /etc/hosts

			$DIALOG --clear --backtitle "Host Flash" --title "Finished" --msgbox "Hosts Flash bad hosts blocklist has been removed from your hosts file.\n\nSend donations to paypal.me/vr51" 0 0

			exit
			;;

		255)

			$DIALOG --clear --backtitle "Host Flash" --title "Cancelled" --msgbox "Esc pressed.\n\nSend donations to paypal.me/vr51" 0 0
			exit
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

	if test "$missing" -ne 12
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
				free.fr-Adult 'Moderate: Blocks pornography' Off \
				free.fr-Misc 'Moderate: Blocks miscellaneous sites that some consider undesirable' Off \
				hostsfile.org 'Very Strict: Regular blocks + porn, gambling and gaming sites.' Off \
				)"
	fi

	if test "$missing" = 12
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

mkdir "$filepath/TEMP"
cd "$filepath/TEMP"


###
#
#	Download Files
#	Look at hosts_lists DIALOG box for more info
#
##

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

if test -s "$filepath/blocklist.txt"
then

	cp "$filepath/blocklist.txt" "$filepath/TEMP/blocklist.txt"

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
#	Comment out any whitelisted hosts
#
###

printf "\nRe-enabling hosts in whitelist.txt.. This may take several minutes..\n"

#	Sort content and remove duplicates

if test -s "$filepath/whitelist.txt"
then

	sort -u -f "$filepath/whitelist.txt" > "$filepath/TEMP/whitelist.txt"

	while read -r LINE
	do
		sed -r -i "s/($redirectip $LINE(.*)?)$/# \1/g" "$filepath/TEMP/hosts"

	done <"$filepath/TEMP/whitelist.txt"

fi


###
#
#	Restore Default hosts file's head (restore anything above the line #### Hosts Flash Bad Hosts Block ######## of the existing hosts file)
#
###

printf "\nMerging bad hosts list into hosts file..\n"
cat "$filepath/TEMP/hosts.copy" "$filepath/TEMP/hosts" > "$filepath/hosts" #  We use hosts-temp so we don't overwrite the temp. hosts file (in case it's needed later)

# Back up to Host File root directory
cd ..

if test "$clean" = "0"
then

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

		$DIALOG --clear --backtitle "Host Flash" --title "Enable Quick Run?" --yesno "Preserve Host Flash settings to reuse them next time?" 0 0
		quickrun=$?

		case $quickrun in

			0)

				touch "$filepath/settings/quickrun"

				printf "#!/bin/bash\n" > "$filepath/settings/quickrun"

				printf "quickrun='On'\n" >> "$filepath/settings/quickrun"

				hosts_listsqr="$(echo ${hosts_lists} | tr ' ' '\t')" # Newlines are added back in on settings import
				printf "hosts_listsqr='$hosts_listsqr'\n" >> "$filepath/settings/quickrun"

				printf "redirectipqr='$redirectip'\n" >> "$filepath/settings/quickrun"
				printf "cleanqr='$clean'\n" >> "$filepath/settings/quickrun"
				printf "installqr='$installhl'\n" >> "$filepath/settings/quickrun"

				$DIALOG --clear --backtitle "Host Flash" --title "Quick Run Enabled" --msgbox "The next time you use Host Flash you will be presented with a Quick Run menu.\nRunning Quick Run will cause Host Flash to reuse the settings preserved from this session.\nQuick Run can be disabled using the Quick Run menu." 0 0

				;;

			1)

				$DIALOG --clear --backtitle "Host Flash" --title "Quick Run Not Enabled" --msgbox "" 0 0

				;;

		esac

	fi

case $installhl in

	0)

		printf "\nInstalling new hosts file..\n"

		# When Host Flash is first used, create backup of hosts file. Do not recreate this backup if it already exists
		if test ! -f "/etc/hosts.hf.original"
		then
			sudo cp /etc/hosts /etc/hosts.hf.original
		fi

		# Backup the host file that is being replaced
		if test ! -d "$filepath/backup"
			then mkdir "$filepath/backup"
		fi

		zip -j9 "$filepath/backup/hosts-backup-$todaytime.zip" /etc/hosts
		sudo mv "$filepath/hosts" /etc/hosts

		# Tell the user we are all done
		$DIALOG --clear --backtitle "Host Flash" --title "Finished" --msgbox "New hosts file block list installed.\n\nThe original hosts lists that existed before Host Flash was first used can always be found at /etc/hosts.hf.original\n\nThe file replaced today has been moved to $filepath/backup/hosts-backup-$todaytime.zip\n\nDonations welcome at paypal.me/vr51" 0 0

		exit

		;;

	1)

		$DIALOG --clear --backtitle "Host Flash" --title "Finished" --msgbox "The new hosts file can is ready for review at $filepath/hosts\n\nYou can install the file manually by moving it to /etc/hosts\n\nContribute to the Host Flash development fund at paypal.me/vr51" 0 0
		exit
		;;

	255)

		$DIALOG --clear --backtitle "Host Flash" --title "Cancelled" --msgbox "Esc pressed.\n\nContribute to the Host Flash development fund at paypal.me/vr51" 0 0
		exit
		;;

esac