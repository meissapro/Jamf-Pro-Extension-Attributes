#!/bin/sh
ADPath() {
    ADConnectionCheck=$(dsconfigad -show)
    ADComputerName=$(dsconfigad -show | grep "Computer Account" | awk '{print $4}')
    ADComputerOU=$(dscl /Search read /Computers/"$ADComputerName" dsAttrTypeNative:distinguishedName 2> /dev/null | sed -e 's/dsAttrTypeNative:distinguishedName://g' | tr -d "\n" | sed -n 's/OU\=//gp' | sed -n 's/DC\=//gp' | sed -n 's/CN\=//gp')

    if [[ -n "$ADConnectionCheck" ]]; then

        if [[ -n "$ADComputerOU" ]]; then

            IFS=',' read -r -a ADArray <<< "$ADComputerOU"
            for (( i=${#ADArray[@]}-1,j=0 ;i>=1;i--,j++ ));
            do
                ADReverseArray[j]="/"${ADArray[i]}
                unset ADReverseArray[0]
                unset ADReverseArray[2]
            done
            ADPath="$(echo ${ADReverseArray[@]} | tr -d " ")"

            echo "<result>$ADPath</result>"
        else
            echo "<result>Location Error</result>"
        fi
    else
        echo "<result>Bind Error</result>"
    fi
}

ADPath