#!/bin/bash

# This script shows the attackers from a log file. (Script for documents\Exercise-06-Parsing-Log-Files-05.pdf)
FILE_LOG="${1}"

# Make sure a file was supplied as an argument.
if [[ ! -e "${FILE_LOG}" ]]
then
  echo "Cannot open log file: ${FILE_LOG}" >&2
  exit 1
fi
# Display the CSV header.
echo "Count,IP,Location"

# Display the list of attackers with the number of failed login attempts, their IP address, and their location.

# Loop through the list of failed attempts and corresponding IP addresses.
grep 'Failed password for' "${FILE_LOG}" |
awk '{print $( NF - 3)}' |
sort |
uniq -c |
# If the number of failed attempts is greater than the limit, display count, IP, and location.
awk '$1 > 10' |
sort -rn |
awk '{
cmd = "geoiplookup " $2 " | awk -F '\'','\'' '\''{print $NF}'\'' | cut -c 2-" 
cmd | getline location
close(cmd)
print $1 "," $2 "," location}'

exit 0