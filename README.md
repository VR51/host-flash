# Host Flash™

Host Flash™ v3.0.4 beta

Lead Author: Lee Hodson

Website: https://host-flash.com

Donate: paypal.me/vr51

This Release: 25th Oct. 2018

First Written: 18th Oct. 2015

First Release: 2nd Nov. 2015

Copyright Host Flash™ <https://host-flash.com>

License: GPL3

Programmer: Lee Hodson <journalxtra.com>, VR51 <vr51.com>

Use of this program is at your own risk

TO RUN:

- Ensure the script is executable:
-	`Right-click > properties > Executable`
-	OR
-	`chmod u+x hostflash`
- Run with:
-	Command line: `bash hostflash` or `./hostflash`
-	OR
-	File browser: click hostflash

Use Host Flash™ to block computer requests to (and access to) websites (hosts), ad servers, malicious websites and time wasting websites.

Use Host Flash™ to manage the Linux hosts file

Host Flash™ works at the OS level. This means requests from any program or app sent to any flagged external host is blocked.

# New Features
- Rebuilt from the ground up
- Better hosts file management
- Improved performance
- Faster processing time
- Returned to text mode only terminal GUI. Dialog, whiptale and other terminal GUIs were overkill for this app
- New menu system (will be improved once core app is finalised)
- Custom settings are now stored in $HOME/.hf* files (.hfrc, .hfwlrc, .hfwlwrc and .hfblrc)
- Update local custom whitelist or blacklist through the GUI
- Update hosts file with local custom rules without rebuilding the whole list
- Various tweaks and fixes
- More to come...

# What Host Flash™ Does
Host Flash™ blocks computers from accessing content served by specific web hosts. These hosts, for example, could be reported malicious websites, known ad servers, adult websites or torrent sites.

Host Flash™

- downloads host name blacklists from any one or more of 11 host blacklist providers,
- merges those lists into one large compilation of bad hosts,
- adds your custom bad hosts list into the mix (.hfblrc),
- removes duplicate bad host entries from the compiled bad hosts list,
- comments out (unblocks) whitelisted hosts (.hfwlrc and .hfwlwrc),
- copies the hosts file that exists when Host Flash™ is first run to /etc/hosts.hf.original,
- copies successive hosts file replacements to /etc/hosts.hf.backup.
- option to remove previously installed Host Flash™ firewall from the existing hosts file,
- retains the hosts file entries that already exist in the original hosts file so that the hosts file created by Host Flash™ does not remove your own custom hosts file edits (provided they are placed above the Host Flash header).

Host Flash™ is interactive.

The interactive set-up program lets you control the host file firewall rules installed by Host Flash™ and control the actions performed by Host Flash.

You will not be able to access sites blocked by Host Flash™. The exception to this rule is that a VPN can be used to bypass the firewall.

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

- Download the program from https://github.com/VR51/host-flash/archive/master.zip
- Unzip host-flash-master.zip
- Enter the directory 'host-flash-master'
- Run hostflash

Programatically, that is

`wget https://github.com/VR51/host-flash/archive/master.zip ; unzip host-flash-master.zip ; cd host-flash-master ; sh hostflash`

To Run Host Flash™, either

Ensure the script is executable they click to run:

* Right-click > properties > Executable OR `chmod u+x hostflash`
* click `hostflash`, or
* type 'bash `hostflash` or `./host-flash.sh` at the command line.

Note: You may need to restart your computer and clear your browser cache(s) for the new hosts file rules to be observed by your OS.

# Host Flash™ is being rewritten (we are on version 3.0.2 now). Information below this point may be slightly out of date.

# Advanced Usage
Whitelist

	The web hosts blocked by the downloaded blocklists may deny you access to a small number of websites that you enjoy visiting.

	The presence of a website in one of the downloaded lists does not necessarily imply the site is malicious. If you trust that a blocked website is safe to view you can 'whitelist' it to prevent Host Flash™ blocking access to it.

	To whitelist a website, add the website's root address to the .hfwlrc file stored in $HOME.

	Notes

		1) DO put each whitelisted domain onto a line of its own within whitelist.txt.

		2) Do add both www and non-www versions of the domain to whitelist.txt to ensure both versions are whitelisted.

		3) DO NOT include the HTTP or HTTPS part of the domain address i.e the protocol is not required.

		4) DO NOT include anything after the TLD part of the domain.

		5) DO end the root domain with dot (.) if all gTLD or ccTLD versions of the domain are to be whitelisted

		GOOD Examples

			example.com
			www.example.com
			example-two.com
			www.example-two.com
			example.

		BAD Examples

			http://example.com
			www.example.com/
			example-two.com/some-page
			https://www.example-two.com/one.html

Wildcard Whitelist

	This applies to the file .hfwlwrc. Apply the same instructions as explained above for the regular Whitelist.

	The difference between the regular Whitelist and the Wildcard Whitelist is that hostnames added to .hfwlwrc are removed from the hosts blocklist along with any subdomains. The subdomains are discovered in the blocklist automatically.

		GOOD Examples

			example.com
			www.example.com
			example-two.com
			www.example-two.com
			example.

		BAD Examples

			http://example.com
			www.example.com/
			example-two.com/some-page
			https://www.example-two.com/one.html

Blocklist

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

127.0.0.1

	This is the normal loopback address of a computer. This is the address normally used to send a request to a bad host (blocked host / website) back to your own computer so that the bad host is never contacted. Select this IP address unless you know better for your own purposes.

0.0.0.0

	This IP address is mapped to hosts in some blacklists provided by some sources. Can be quicker to use 0.0.0.0 instead of other IP addresses because 0.0.0.0 doesn't requqire the system to wait for a request timeout. This is occasionally also used to resolve a bug in some versions of Windows. This IP address is included for those who might prefer to use it.

127.255.255.254

	This IP address is included for my own convenience. I redirect all blocked hosts to a home server virtual host that listens to all ports on loopback address 127.255.255.254. This allows me to tell my home server to serve a minimally styled 404 message in place of ugly browser Document Not Found error messages. Has a visible affect on mod_pagespeed's cache too... (mod_pagespeed caches the request).

Custom

	If you wish, use a custom IP address to redirect bad hosts to websites of your choosing such as Google or any other host with its own dedicated IP address.

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
