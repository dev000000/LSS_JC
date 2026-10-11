#!/bin/bash

# This script shows the attackers from a log file. (Script for documents\Exercise-06-Parsing-Log-Files-05.pdf)

LIMIT='10'
LOG_FILE="${1}"

# Make sure a file was supplied as an argument.
if [[ ! -e "${LOG_FILE}" ]]
then
  echo "Cannot open log file: ${LOG_FILE}" >&2
  exit 1
fi
# Display the CSV header.
echo "Count,IP,Location"

# Display the list of attackers with the number of failed login attempts, their IP address, and their location.

# Option 1:
# Loop through the list of failed attempts and corresponding IP addresses.
# grep 'Failed password for' "${LOG_FILE}" |
# awk '{print $( NF - 3)}' |
# sort |
# uniq -c |
# # If the number of failed attempts is greater than the limit, display count, IP, and location.
# awk -v limit="${LIMIT}" '$1 > limit' |
# sort -rn |
# awk '{
# cmd = "geoiplookup " $2 " | awk -F '\'','\'' '\''{print $NF}'\'' | cut -c 2-" 
# cmd | getline location
# close(cmd)
# print $1 "," $2 "," location}'

# Option 2:
grep 'Failed password for' "${LOG_FILE}" |
awk '{print $( NF - 3)}' |
sort |
uniq -c |
sort -nr |
while read COUNT IP
do
  # If the number of failed attempts is greater than the limit, display count, IP, and location.
  if [[ "${COUNT}" -gt ${LIMIT} ]]
  then
    LOCATION=$(geoiplookup "${IP}" | awk -F ',' '{print $NF}' | cut -c 2-)
    echo "${COUNT},${IP},${LOCATION}"
  fi
done

exit 0