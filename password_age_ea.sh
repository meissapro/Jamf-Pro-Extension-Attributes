#!/bin/bash
#userToCheck="stephenweinstein"
lastUser=`/usr/bin/last -1 -t console | awk '{print $1}'`

passwordDateTime=$( dscl . read /Users/${lastUser} accountPolicyData | sed 1,2d | /usr/bin/xpath "/plist/dict/real[preceding-sibling::key='passwordLastSetTime'][1]/text()" 2> /dev/null | sed -e 's/\.[0-9]*//g' )
((passwordAgeDays = ($(date +%s) - $passwordDateTime) / 86400 ))
echo "<result>${passwordAgeDays}</result>"