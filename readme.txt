###
#
#	Host Flash (Junior) v1.2.0
#
#	Author: Lee Hodson
#	Donate: paypal.me/vr51
#	Website: https://journalxtra.com/linux/linux-hosts-file-manager-program/
#	First Written: 18th Oct. 2015
#	First Release: 2nd Nov. 2015
#	This Release: 7th Nov. 2015
#
#	Copyright 2015 Lee Hodson <journalxtra.com>
#	License: GPL3
#
#	Use of this program is at your own risk
#
#	TO RUN:
#
#	- command line: sh host-flash.sh
#	- File browser: click host-flash.sh or click host-file.desktop
#
#	Use Host Flash to block access to websites (hosts), ad servers, malicious websites and time wasting websites.
#	Use Host Flash to manage your hosts file
#
###

###
#
#	New Features
#
###

	- Quick Run
	- Save options for reuse
	- More block list sources
	- Hosts file backup archive directory

###
#
#	What Host Flash Does
#
###

Host Flash blocks computers from accessing content served by certain web hosts. These hosts, for example, could be reported malicious websites, known ad servers, adult websites or torrent sites.

Host Flash

	- downloads up to 8 bad hosts blocklists,
	- merges those lists into one large compilation of bad hosts,
	- adds your custom bad hosts list into the mix (blocklist.txt),
	- removes duplicate bad host entries from the compiled bad hosts list,
	- comments out (unblocks) whitelisted hosts (whitelist.txt),
	- copies the hosts file that exists when Host Flash is first run to /etc/hosts.hf.original,
	- stores replaced hosts files in archive directory 'Hosts Flash/backup/',
	- option to remove previously installed bad hosts added by Host Flash from the existing hosts file,
	- retains the original hosts file entries within the hosts file created by Host Flash.

This process is run interactively so you will be asked to confirm changes before they are made to your system.

You will not be able to access sites blocked by Host Flash.

Run Host Flash regularly to keep your hosts file up-to-date with new bad hosts.

Run Host Flash if you need to undo changes made to the hosts file by Host Flash

Use Host Flash and the files whitelist.txt and blocklist.txt to manage your computer's hosts file.

Rerun Host Flash to update the list of blocked sites or to activate changes to whitelist.txt and blocklist.txt.

If you manually edit your computer's hosts file after using Host Flash, make sure your edits are above the content added by Host Flash or risk your manual edits being removed when Host Flash next runs.

Press Esc or Ctrl+C to stop the process at any stage.

###
#
#	Portability
#
###

Host Flash will run in many Debian (and probably non Debian) environments like Ubuntu, Kubuntu and Debian. It should work on rooted Androids too.

Saved Quick Run settings will work independently of the host they were configured on. If you want to reuse the settings, just move the Host Flash directory to any other system and any saved settings will be migrated too.

###
#
#	Requirements
#
###

This program needs either 'dialog' or 'whiptail' as well as 'wget', 'sed', 'zip' and 'p7zip' to be installed in your computer. Host Flash will tell you if any of those programs are missing. Many Linux systems have them installed. If your computer does not have them installed you can install them using your package manager or via the command line by issuing a command similar to sudo apt-get install dialog whiptail wget sed

This software is known to work on Linux systems. It may work on other Unix based systems too. It was developed on Kubuntu.

###
#
#	How to Use Host Flash
#
###

Download Host Flash from GitHub, run the program, follow the on screen prompts to quickly configure the program and install your new hosts file block list then save your settings for use as the default Quick Run options for the next time you run Host Flash.

1) Download the program from https://github.com/VR51/host-flash/archive/master.zip
2) Unzip host-flash-master.zip
3) Enter the directory 'host-flash-master'
4) Run host-flash.sh

Programatically, that is

`wget https://github.com/VR51/host-flash/archive/master.zip ; unzip host-flash-master.zip ; cd host-flash-master ; sh host-flash.sh`

To Run Host Flash, either

	click host-flash.sh, or
	clicking host-flash.desktop, or
	type 'sh host-flash.sh' at the command line.

Note: You may need to restart your computer and clear your browser cache(s) for the new hosts file rules to be observed by your OS.

###
#
#	Advanced Usage
#
###

Whitelist

	The web hosts blocked by the downloaded blocklists may deny you access to a small number of websites that you enjoy visiting.

	The presence of a website in one of the downloaded lists does not necessarily imply the site is malicious. If you trust that a blocked website is safe to view you can 'whitelist' it to prevent Host Flash blocking access to it.

	To whitelist a website, add the website's root address to the whitelist.txt file stored in the same directory as host-flash.sh.

	Notes

		1) DO put each whitelisted domain onto a line of its own within whitelist.txt.

		2) Do add both www and non-www versions of the domain to whitelist.txt to ensure both versions are whitelisted.

		3) DO NOT include the HTTP or HTTPS part of the domain address i.e the protocol is not required.

		4) DO NOT include anything after the TLD part of the domain.

		GOOD Examples

			example.com
			www.example.com
			example-two.com
			www.example-two.com

		BAD Examples

			http://example.com
			www.example.com/
			example-two.com/some-page
			https://www.example-two.com/one.html


Blocklist

	You may want to block access to more hosts than are included in the bad hosts lists downloaded by Host Flash.

	To block extra websites (hosts), add their root addresses (e.g. name.tld) to the blocklist.txt file stored in the same directory as host-flash.sh.

	Notes

		1) DO put each domain to block onto a line of its own within blocklist.txt.

		2) Do add both www and non-www versions of the domain to blocklist.txt to ensure both versions are blocked.

		3) DO NOT include the HTTP or HTTPS part of the domain address.

		4) DO NOT include anything after the TLD part of the domain.

		GOOD Examples

			example.com
			www.example.com
			example-two.com
			www.example-two.com

		BAD Examples

			http://example.com
			www.example.com/
			example-two.com/some-page
			https://www.example-two.com/one.html

###
#
#	What to Expect
#
###

Your computer will no longer be able to receive data from any of the domains blocked by Host Flash.

	1) When you try to access a page of a blocked domain you will be greeted by a 'Document Not Found' error message that will be served by your computer. This is normal and is what is supposed to happen.

	2) Some web pages you visit will display their main content but the places where ads would normally display will now be replaced by Document Not Found messages.

	3) Some web pages you visit will display their main content but the places where social media messages normally display will now be replaced by Document Not Found messages.

	4) Many web pages will load faster because your web browser will no longer need to wait for ad content to load. This makes web pages lighter so will save bandwidth too.


###
#
#	Remember
#
###

If you see a Document Not Found page when you try to visit a website, and you trust the website, add the website's domain to whitelist.txt and rerun host-flash.sh

If you want to block access to additional websites (like social media sites, search engines, adult sites or torrent sites etc...) add their domain names to blocklist.txt

###
#
#	Quick Note About the IP Address Options
#
###

Host Flash lets you choose from 4 IP address mapping options. The IP address you choose is the address your computer will call when host names in the list of bad hosts are requested. Here is more information about these options.

127.0.0.1

	This is the normal loopback address of a computer. This is the address normally used to send a request to a bad host (blocked host / website) back to your own computer so that the bad host is never contacted. Select this IP address unless you know better for your own purposes.

0.0.0.0

	This IP address is mapped to hosts in bad host lists provided by some sources. I think, not sure, this is occasionally used to resolve a bug in some versions of Windows. Linux is not affected by this bug (obviously - ** insert smug smile here **). This IP address is included ...just in case...

127.255.255.254

	This IP address is included for my own convenience. I redirect all blocked hosts to a home server virtual host that listens to all ports on loopback address 127.255.255.254. This allows me to tell my home server to serve a minimally styled 404 message in place of ugly browser Document Not Found error messages. Has a visible affect on mod_pagespeed's cache too... (mod_pagespeed caches the request).

Custom

	If you wish, use a custom IP address to redirect bad hosts to websites of your choosing such as Google or any other host with its own dedicated IP address.

###
#
#	Introduction to Host Files and Host Flash
#
#		I've placed this here because most users won't want to read it but for those who do....
#
###

Host Flash Protects Your Computer & Blocks Internet Ads.

Host Flash installs a list of Internet host domain names that are known to serve ads, malware or other undesirable to view content.

This list of 'bad host' domains is installed into your computer's hosts file.

The hosts file is typically stored in /etc/hosts and is read by your Linux computer when a request is made to view a domain.

As you probably know, DNS servers tell computers the IP address of a server where a website (host) is located. DNS servers are usually managed by ISPs and are only connected to your computer through the incredibly long cables that connect it to the Internet. What you might not know is that your computer's hosts file overrules the remotely managed DNS servers.

Domain names listed in your computer's hosts file are placed next to an IP address. This IP address is the address of the host (or web server) that your computer will attempt to contact when it needs to reach the domain listed alongside it.

IP address to host name maps in a hosts file look like this one:

		127.0.0.1 example.com
		127.0.0.1 example-two.com
		...

Not all domain names (hosts) are listed in a computer's hosts file. In fact, most domain names are not in it. Only those hosts that need their server IP address(es) to be overriden need to be listed in the local hosts file of your computer.

Your computer will not be able to access, send requests to, or recieve content from the domains that are added by Host Flash to your computer's local hosts file.

The domains Host Flash adds to your hosts file are mapped to either the local IP address (i.e. loopback address) of your computer or to an IP address you specify when Host Flash is run. Requests to visit the hosts listed in the hosts file will never get any further than your computer's own IP address.

With the bad hosts blocklist installed you will see (usually) a Document Not Found error message issued by your web browser when you try to view content hosted at a blocked address. This is the normal and expeted behaviour.

Host Flash offers you 4 IP address mapping options:

	a) 127.0.0.1 (default)
	b) 127.255.255.254 (non default)
	c) 0.0.0.0 (standard), and
	d) Custom

Use the default IP address if in doubt over which to use.

If you wanted to, you could use the IP address of another website so that requests to visit bad hosts redirect to something useful.


###
#
#	Thank You to...
#
###

The lists of bad hosts used by Host Flash are compiled by, and are available from,

	- hosts-file.net
	- winhelp2002.mvps.org
	- rlwpx.free.fr
	- hostsfile.org

The program developer Lee Hodson and all who wrote the Linux scripting guides he has read.

###
#
#	Stay Up to Date
#
###

Updates to Host Flash can be found at either

	- https://github.com/VR51/host-flash
	- https://journalxtra.com/linux/linux-hosts-file-manager-program/


###
#
#	Donations
#
###

Send donations to paypal.me/vr51

Donations will be received by Lee Hodson of journalxtra.com and VR51.

A contribution of the Donations received will be split between the host file source providers.