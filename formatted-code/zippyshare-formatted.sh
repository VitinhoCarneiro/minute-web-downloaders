#!/bin/sh
# ZippyShare download script v4 - prettified version
# For studying and better code comprehension. Even though it works just as well.
while read url;
do 
	wget -O - $url | 
		# Find the section containing the download button Javascript function
		grep "dlbutton')" | 
		# Parse the necessary values for generating the URL
		sed 's/.*\"\(\/d\/[a-zA-Z0-9]*\/\)\"+.\([0-9]*\)%\([0-9]*\) + a() + b() + c() + d + 5\/5.+\"\(.*\)\";/\1 \2 \3 \4/g' | 
		# Breakdown of the regex:
		#### .*\" - matches everything up to a quote symbol
		#### \(\/d\/[a-zA-Z0-9]*\/\) - captures the beginning of the resource URL which is
		# written in verbatim and looks something like this: /d/qr2tiqa4/
		#### \"+. - matches the closing quote, a plus symbol and the opening parenthesis for 
		# the hash expression
		#### ([0-9]*\)%\([0-9]*\) - captures the numerical values in the hash expression
		# separately.
		####  + a() + b() + c() + d + 5\/5.+\" - matches the rest of the hash expression
		# which is just a bunch of weird function calls to functions which always return
		# the same values. (what were they thinking?)
		#### \(.*\)\"; - captures the file name to put in the end of the URL

		# Calculate the hash and assemble the URL resource indicator
		awk '{hash = ($2 % $3) + 1 + 2 + 3 + 4 + 5/5; print $1hash$4}' | 
		# The constants above are the return values of a(), b() and c(), the value
		# of d, and the constant 5/5, which are always the same for every page.

		# Append the URL resource indicator to the URL's domain name
		xargs -n1 printf "$(echo $url | sed 's/http[s]\?\:\/\/\(www[0-9]*[.]zippyshare[.]com\).*/\1/gm')%s" | 
		
		xargs -n1 wget;
done

