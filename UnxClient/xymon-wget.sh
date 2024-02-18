#!/bin/sh

export WGETRC=$XYMONHOME/etc/wget-config

# First parameter is XYMSRV
if test -z "$1"
then
   echo Xymon wget client
   echo Usage: $0  RECIPIENT DATA
   echo RECIPIENT: IP-address, hostname or URL
   echo DATA: Message to send, or "-" to read from stdin
   exit
else
   XYMSRV=$1
fi

# Second parameter is the message to be sent
if test -z "$2"
then
   echo Xymon wget client
   echo Usage: $0 RECIPIENT DATA
   echo RECIPIENT: IP-address, hostname or URL
   echo DATA: Message to send, or "-" to read from stdin
   exit
else
   messageOption=$2
fi

# If XYMSRV=0.0.0.0, use XYMSERVERS
if test "$XYMSRV" = "0.0.0.0"
then
   if test -z "$XYMSERVERS"
   then
      echo Abort: XYMSERVERS variable not set
      exit
   fi
else
   XYMSERVERS=$XYMSRV
fi

# If the messageOption is - or @, read the message from STDIN
if test "$messageOption" = "-" -o "$messageOption" = "@"
then
   message=$(cat -)
else
   message=$messageOption
fi

## Loop the servers in XYMSRV and sent the message with wget
for XYM in $XYMSERVERS
do
   # Sent message line bij line if - is specified as command line option
   if test "$messageOption" = "-"
   then
      # Set IFS to newline so we can read the message line by line
      IFS='
'
      for line in $message
      do
         echo "$line" > $XYMONHOME/tmp/wget.$$
         wget \
            --post-file=$XYMONHOME/tmp/wget.$$ \
            --quiet \
            -O - \
            https://$XYM$XYMURL
         rm $XYMONHOME/tmp/wget.$$
      done
   else
      # Als we een file meekrijgen als message, dan gaan we deze file gewoon posten
      # Wordt gebruikt vanuit de Inventory.pl
      if test -f "$message"
      then
         wget \
            --post-file=$message \
            --quiet \
            -O - \
            https://$XYM$XYMURL
      else
         echo "$message" > $XYMONHOME/tmp/wget.$$
         wget \
            --post-file=$XYMONHOME/tmp/wget.$$ \
            --quiet \
            -O - \
            https://$XYM$XYMURL
         rm $XYMONHOME/tmp/wget.$$
      fi
   fi
done
