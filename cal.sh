#!/bin/bash
curl https://www.google.com/calendar/ical/<<INSERT YOUR URL HERE>>/basic.ics > basic.ics
awk '/^SUMMARY.*$/' basic.ics > basic2.ics #retain summary text and start event start date
sed -i 's/^........//' basic2.ics #remove SUMMARY: 
awk '/^DTSTART.*$/' basic.ics > basic3.ics
sed -i 's/........$//' basic3.ics
paste basic3.ics basic2.ics > basic.ics
awk '!/^.*VALUE=DATE.*$/' basic.ics > basic2.ics #some events in gcal have weird date notation
sed -i 's/:/: /g' basic.ics
sed -i 's/^.........//' basic.ics
DATE="$(date +'%Y%m%d')" #remove past events
awk 'int($1)>="'"$DATE"'"' basic.ics > basic2.ics
sort -k 1 basic2.ics > basic.ics
awk 'NR < 11' basic.ics > cal.ics #limit to 10 upcoming events
sed -i -e 's/^.\{4\}/&\//' cal.ics #add / after year and month 
sed -i -e 's/^.\{7\}/&\//' cal.ics
rm basic.ics #cleanup
rm basic2.ics
rm basic3.ics
