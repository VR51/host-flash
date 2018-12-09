# Host Flash™

Host Flash™ v3.1.3

Lead Author: Lee Hodson

Website: https://host-flash.com

Donate: paypal.me/vr51

This Release: 8th Dec 2018

First Written: 18th Oct 2015

First Release: 2nd Nov 2015

Copyright Host Flash™ <https://host-flash.com>

License: GPL3

Programmer: Lee Hodson <journalxtra.com>, VR51 <vr51.com>

Use of this program is at your own risk

FILE TO DOWNLOAD:

You only need to download the file `hostsflash`.

All the other files in this repository are for reference or emergency only.

TO RUN:

- Ensure the `hostsflash` file is executable:
-	`Right-click > properties > Executable`
-	OR
-	`chmod u+x hostflash`
- Run with:
-	Command line: `bash hostflash` or `./hostflash`
-	OR
-	File browser: just click `hostflash`

Use Host Flash™ to block computer requests to (and access to) websites (hosts), ad servers, malicious websites and time wasting websites.

Use Host Flash™ to manage the Linux hosts file

Host Flash™ works at the OS level. This means requests from any program or app sent to any flagged external host is blocked.

# New Features
- Rebuilt from the ground up
- Better hosts file management
- Much improved performance
- Much faster processing time
- More host blacklist repositories to choose from (17 built in, 3 Host Flash community lists and 3 user customizable lists)
- Returned to text mode only terminal GUI. Dialog, whiptale and other terminal GUIs were overkill for this app
- New menu system (will be improved once core app is finalised)
- Custom settings are now stored in $HOME/.config/hostflash/.hf* files (.hfrc, .hfwlrc, .hfwlwrc and .hfblrc, .hfremoved,  .debug, and log)
- Update local custom whitelist or blacklist through the GUI
- Update hosts file with local custom rules without rebuilding the whole hosts file
- Apply rule change updates without complete hosts file rebuild
- List management. Easily add new host list repositories from within the Host Flash™ app.
- Local DNS Cache automatically cleared after hosts file installation or update
- Better information about installed HF version to help you recognise when an update is available.
- Better config reset management.
- Use basic Grep regexes in whitelists.
- Hosts removed through whitelist rules are logged to $HOME/.config/hostflash/.hfremoved so you can review and update whitelist rules.
- Various tweaks and fixes
- More to come...

# What Host Flash™ Does
Host Flash™ installs a hosts blacklist into your computer. This blacklist consists of bad hosts, undesirable hosts, ad hosts and trackers. All hosts are websites. When installed, the blacklist prevents your computer from accessing content served by the blacklisted web hosts. Host Flash™ is a simple firewall.

# Host Flash™ is interactive and configurable
The interactive set-up program lets you control the host file firewall rules installed by Host Flash™ and lets you manage the actions performed by Host Flash.

Host Flash™ compiles and installs a blacklist of malware, adserver, tracker and cryptominer hosts. This prevents your computer making requests to domains (hosts) that could compromise your computer and privacy. You can choose the host lists to download and install.

Host Flash™ can install your hosts file for you and provide an easy way for you to enable, disable and otherwise manage your system hosts file.

Be aware that hosts file redirect rules can be bypassed by use of a VPN such as the one provided by the Opera browser or by a Tor browser.

Host Flash™

- downloads host name / domain name blacklists from any of one or more of over 20 host blacklist repositories
- merges those lists into one large compilation of bad hosts
- adds your customizable bad hosts blacklist into the mix (.hfblrc)
- removes duplicate bad host entries from the compiled bad hosts list
- removes whitelisted hosts from the compiled list (.hfwlrc and .hfwlwrc)
- copies the hosts file that exists when Host Flash™ is first run to /etc/hosts.hf.original
- copies successive hosts file replacements to /etc/hosts.hf.backup
- option to remove previously installed Host Flash™ firewall from the existing hosts file
- retains the hosts file entries that already exist in the original hosts file so that the hosts file created by Host Flash™ does not remove your own custom hosts file edits (provided they are placed above the Host Flash header)
- can be used in web server environments
- the redirect IP address is configurable

Run Host Flash™ regularly to keep your hosts file up-to-date with new bad hosts.

Run Host Flash™ if you need to undo changes made to the hosts file by Host Flash™

Use Host Flash™ to manage your computer's hosts file.

Make sure manual edits to the hosts file are above the content added by Host Flash™ otherwise Host Flash™ will delete them when the rules are updated.

Updates to the hosts file rules that are managed through Host Flash™ will be respected by Host Flash™ in subsequent funs.

# Requirements
This program needs curl, sed, zip, unzip and p7zip to be installed in the OS environment. Host Flash™ will display an alert if any of these programs is not installed and will prompt you to install them (see Host Flash™ options).

This software is known to work on Debian Linux systems. It may or may not work on other Unix based systems. It is a BASH program so any system with BASH installed should be fine.

# Portability
Host Flash™ will run in many Debian (and probably non Debian) environments like Ubuntu, Kubuntu and Debian. It might work on rooted Android devices, though full BusyBox needs to be installed into Android with a few additional shell scripts (though it is quicker and easier to compile the hosts file on a full Linux machine then transfer the file to Android).

If you want to reuse local Host Flash™ settings in other environments, just move the .hf* files from $HOME to the $HOME of other environments.

# How to Use Host Flash™
Download Host Flash™ from GitHub, run the program, follow the on screen prompts to quickly configure the program and install your new hosts file block list. Custom settings automatically saved by Host Flash™ in realtime.

- Download the program from https://github.com/VR51/host-flash/
- You only need to download the file called `hostflash`
- Run hostflash

Programatically, that is

`wget https://github.com/VR51/host-flash/archive/master.zip ; unzip host-flash-master.zip ; cd host-flash-master ; chmod u+x hostflash ; bash ./hostflash`

To Run Host Flash™, either

Ensure the script is executable then click to run:

* Right-click > properties > Executable OR `chmod u+x hostflash`
* click `hostflash`, or
* type 'bash `hostflash` or `./host-flash.sh` at the command line.

Note: You may need to restart your computer and clear your browser cache(s) for the new hosts file rules to be observed by your OS.

# Host Flash™ is being rewritten (we are on version 3.0.2 now). Information below this point may be slightly out of date.

# Advanced Usage
Whitelist

	The web hosts blocked by the downloaded blacklists may deny you access to a small number of websites that you enjoy visiting.

	The presence of a website in one of the downloaded lists does not necessarily imply the site is malicious. If you trust that a blocked website is safe to view you can 'whitelist' it to prevent Host Flash™ blocking access to it.

	To whitelist a website, add the website's root address to the .hfwlrc file stored in $HOME.

	Notes

		1) DO put each whitelisted domain onto a line of its own within whitelist.txt.

		2) Do add both www and non-www versions of the domain to whitelist.txt to ensure both versions are whitelisted.

		3) DO NOT include the HTTP or HTTPS part of the domain address i.e the protocol is not required.

		4) DO NOT include anything after the TLD part of the domain.

		5) DO use basic Grep regexes to represent spelling variations of the whitelisted host

		GOOD Examples

			example.com
			www.example.com
			example-two.com
			www.example-two.com
			example[[:num:]].com # This represents example[1-9].com

		BAD Examples

			http://example.com # Do not state the protocol e.g. http://, https:// or ftp: etc...
			www.example.com/ # Do not add anything after the TLD e.g. /
			example-two.com/some-page # Do not add anything after the TLD e.g /some-page
			https://www.example-two.com/one.html # Do not state the protocol. Do not state the page

Wildcard Whitelist

	The wildcard whitelist treats any text added to .hfwlwrc as a text fragment to find in any hostname in the hosts file. The search is performed as '[IP ADDRESS][SPACE][anything][HOST FRAGMENT][anything]'.
	
	The regular Whitelist will find and remove only the stated host name from the hosts file searched.
	
	The Wildcard Whitelist will find and remove any host name that includes the host name fragment specified in the whild card whitelist file .hfwlwrc.
	
	The following notes and rules apply to the file .hfwlwrc. Apply the same instructions as explained above for the regular Whitelist with the extra notes that:
	
	6) Try to be as precise as possible when stating the hosts fragment rule to match against host names listed in the hosts file. All matches will be removed from the hosts file.
	
	7) Use basic grep regex patterns to narrow the number of hosts that are likely to match the search fragment.
	
	8) Add a $ character to the end of a host name fragment in the wildcard whitelist if you only want to match sub domains that end with the stated root domain.

		GOOD Examples

			example.com # This will whitelist a.example.com, b.example.com, a.b.example.com and *.example.com.a, *.example.com.b, *.example.com.* etc...
			www.example.com
			example-two.com
			www.example-two.com
			example. # This will whitelist example.com, example.co, example.TLD, *.example.* etc...
			example.com$ # This will whitelist sub domains of example.com. Here example.com is the exact root domain to match against.

		BAD Examples

			http://example.com
			www.example.com/
			example-two.com/some-page
			https://www.example-two.com/one.html

Blacklist

	You may want to block access to more hosts than are included in the bad hosts lists downloaded by Host Flash™.

	To block extra websites (hosts), add their root addresses (e.g. name.tld) to .hfblrc in $HOME.

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

# What to Expect
Your computer will no longer be able to receive data from any of the domains blocked by Host Flash™.

	1) When you try to access a page of a blocked domain you will be greeted by a 'Document Not Found' error message that will be served by your computer. This is normal and is what is supposed to happen.

	2) Some web pages you visit will display their main content but the places where ads would normally display will now be replaced by Document Not Found messages.

	3) Some web pages you visit will display their main content but the places where social media messages normally display will now be replaced by Document Not Found messages.

	4) Many web pages will load faster because your web browser will no longer need to wait for ad content to load. This makes web pages lighter so will save bandwidth too.

# Linux Virtual Machine Hosts and Hypervisor Hosts that Host Windows Guests
If the environment that Host Flash is being used within is a Virtual Machine host or is a Hypervisor Type 1 (bare-metal) host system then be aware that some source host name blacklists that can be used by Host Flash do block or might at times block Microsoft host names (domains). This may prevent or interfere with the proper functioning of Windows Updates. Remove the Microsoft host names from the blocklist if Windows updates fail or halt unexpectredly.

# Remember
If you see a Document Not Found page when you try to visit a website, and you trust the website, add the website's domain to whitelist.txt and rerun host-flash.sh

If you want to block access to additional websites (like social media sites, search engines, adult sites or torrent sites etc...) add their domain names to blocklist.txt

# Quick Note About the IP Address Options

Host Flash™ lets you choose from 4 IP address mapping options. The IP address you choose is the address your computer will call when host names in the list of bad hosts are requested. Here is more information about these options.

0.0.0.0

This IP address is mapped to hosts in some blacklists provided at some hosts repositories. It can be quicker to use 0.0.0.0 instead of other IP addresses because 0.0.0.0 doesn't require the system to wait for a request timeout. This is occasionally also used to resolve a bug in some versions of Windows.

127.0.0.1

This is the typical loopback address of a computer. This is the address normally used to send a request to a bad host (blocked host / website) back to your own computer so that the bad host is never contacted. Use this IP address if 0.0.0.0 is problematic for your OS.
	
# Typical Places for the hosts file to be Installed
For reference, hosts files are typically installed to:

Unix, Unix-like and POSIX: `/etc/hosts`
iOS, Apple Mac: `/private/etc/hosts`
Android:  `/system/etc/hosts`
Windows NT, 2000, XP,[5] 2003, Vista, 2008, 7, 2012, 8, 10: `%SystemRoot%\System32\drivers\etc\hosts`

# Introduction to Host Files and Host Flash™
Host Flash™ Protects Computers from Malware, Phishing Sites, Undesirable Content and Adservers.

Host Flash™ installs a list of Internet host domain names that are known to serve ads, malware or other undesirable to view content.

This list of 'bad host' domains is installed into your computer's hosts file.

The hosts file is typically stored in /etc/hosts and is read by your Linux computer when a request is made to view a domain.

As you probably know, DNS servers tell computers the IP address of a server where a website (host) is located. DNS servers are usually managed by ISPs and are only connected to your computer through the incredibly long cables that connect it to the Internet. What you might not know is that your computer's hosts file overrules the remotely managed DNS servers.

Domain names listed in your computer's hosts file are placed next to an IP address. This IP address is the address of the host (or web server) that your computer will attempt to contact when it needs to reach the domain listed alongside it.

IP address to host name maps in a hosts file look like this one:

		127.0.0.1 example.com
		127.0.0.1 example-two.com
		...

Not all domain names (hosts) are listed in a computer's hosts file. In fact, most domain names are not in it. Only those hosts that need their server IP address(es) to be overriden need to be listed in the local hosts file of your computer.

Your computer will not be able to access, send requests to, or recieve content from the domains that are added by Host Flash™ to your computer's local hosts file.

The domains Host Flash™ adds to your hosts file are mapped to either the local IP address (i.e. loopback address) of your computer or to an IP address you specify when Host Flash™ is run. Requests to visit the hosts listed in the hosts file will never get any further than your computer's own IP address.

With the bad hosts blocklist installed you will see (usually) a Document Not Found error message issued by your web browser when you try to view content hosted at a blocked address. This is the normal and expeted behaviour.

Host Flash™ offers you 4 IP address mapping options:

	a) 127.0.0.1 (default)
	b) 127.255.255.254 (non default)
	c) 0.0.0.0 (standard), and
	d) Custom

Use the default IP address if in doubt over which to use.

If you wanted to, you could use the IP address of another website so that requests to visit bad hosts redirect to something useful.


# Thank You to...
The lists of bad hosts used by Host Flash™ are compiled by, and are available from,

	- hosts-file.net
	- winhelp2002.mvps.org
	- rlwpx.free.fr
	- hostsfile.org
	- malwaredomainlist.com
	- adaway.org
	- someonewhocares.org

The program developer Lee Hodson and all who wrote the Linux scripting guides he has read.

# Stay Up to Date
Updates to Host Flash™ can be found at either

	- https://github.com/VR51/host-flash
	- https://host-flash.com

# Donations
Give donations to paypal.me/vr51

VR51 is the main fiscal sponsor of Host Flash™.
