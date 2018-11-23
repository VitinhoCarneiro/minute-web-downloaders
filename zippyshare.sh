#!/bin/sh
# ZippyShare download script v4
while read url; do wget -O - $url | grep "dlbutton')" | sed 's/.*\"\(\/d\/[a-zA-Z0-9]*\/\)\"+.\([0-9]*\)%\([0-9]*\) + a() + b() + c() + d + 5\/5.+\"\(.*\)\";/\1 \2 \3 \4/g' | awk '{hash = ($2 % $3) + 1 + 2 + 3 + 4 + 5/5; print $1hash$4}' | xargs -n1 printf "$(echo $url | sed 's/http[s]\?\:\/\/\(www[0-9]*[.]zippyshare[.]com\).*/\1/gm')%s" | xargs -n1 wget; done

