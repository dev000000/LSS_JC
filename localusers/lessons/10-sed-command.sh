#!/bin/bash

# This script is learned about the sed command in Linux.

# 1.WHAT IS SED ?

# Learn about Sed and Streams

# Sed = Stream Editor.
# It is used for editing streams
# A Stream is data that travels from:
# - One process to another through a pipe.
# - One file to another as a redirect.
# - One device to another.
# Streams are typically textual data.

# Learn about Sed Usage
# Sed performs text transformantions on streams.
# Examples:
# - Substitute some text for other text.
# - Remove lines.
# - Append text after given lines.
# - Insert text before certain lines.
# Sed differs from other editors such as Vim, Emacs, Nano, which are used interactively.
# Vim can execute these task above with macros, but it needs someone to start Vim and then execute the macros:
# => it make Sed ideal for be used in shell scripts.

# Sed 
# Definition: sed - stream editor for filtering and transforming text
# Syntax: sed [options]... {script} [input-file]...


# 2. THE SUBSTITUTE COMMAND 'S'

# Prepare a data file for demonstration
echo 'Dwight is the assistant regional manager.' > manager.txt

cat manager.txt
# Output:
# Dwight is the assistant regional manager.

# Replace "assistant" with "assitant to the" in the file manager.txt

# -> To do that, you can use the substitute command of sed, which is represented by the letter s.
# Syntax: sed 's/old-text/new-text/' input-file
# Syntax: sed 's/search-pattern/replacement-string/flags' input-file
# s: the substitute command
# search-pattern: the text you want to find. It is actually a regular expression.
# replacement-string: the text you want to replace the search-pattern with.
# flags: optional flags that modify the behavior of the substitute command.
sed 's/assistant/assistant to the/' manager.txt
# Output:
# Dwight is the assistant to the regional manager.

# Important: sed not changed the original file, it's just sending its output via standard output.

# Prove that the original file is not changed
cat manager.txt
# Output:
# Dwight is the assistant regional manager.

# Sed is case sensitive by default.

# Prepare a data file for demonstration
echo 'i love my cat.' > love.txt

# Use sed to replace "my cat" with "my dog" in the file love.txt (MY CAT is in uppercase)
sed 's/MY CAT/my dog/' love.txt
# Output: i love my cat. 

# => 'my cat' is not replaced because 'MY CAT' is not exactly match 'my cat'. if nothing matches, sed doesn't perform any replacement and therefore the text is returned without any changes.

# If you want to perform a case in sensitive search, you need to supply the i or I flag to the substitute command. The i flag makes the search case insensitive, it means that search doesn't care about the case of the letters in the search pattern.

# Bonus: You can use Ctrl + C to stop the execution of a command in the terminal or while typing command but don't want to execute it. It will return you to the command prompt.

# Use the i flag to perform a case insensitive search and replace "my cat" with "my dog" in the file love.txt
sed 's/MY CAT/my dog/i' love.txt
# Output: i love my dog.

# Append extra data to the file love.txt
echo 'This is line 2.' >> love.txt
echo 'my cat is very cute.' >> love.txt

# Check the content of the file love.txt
cat love.txt
# Output:
# i love my cat.
# This is line 2.
# my cat is very cute.

# using sed to replace "my cat" with "my dog" in the file love.txt
sed 's/my cat/my dog/' love.txt
# Output:
# i love my dog.
# This is line 2.
# my dog is very cute.

# What happens with sed reads one line from the file and performs the replacement on that line. Then it reads the next line and performs the replacement on that line. It continues this process until it reaches the end of the file.

# Append extra data to the file love.txt
echo 'i love my cat and my cat loves me. Also my cat loves the sun.' >> love.txt

# Check the content of the file love.txt
cat love.txt
# Output:
# i love my cat.
# This is line 2.
# my cat is very cute.
# i love my cat and my cat loves me. Also my cat loves the sun.

# Run the sed command again to replace "my cat" with "my dog" in the file love.txt
sed 's/my cat/my dog/' love.txt
# Output:
# i love my dog.
# This is line 2.
# my dog is very cute.
# i love my dog and my cat loves me. Also my cat loves the sun.

# =>  By default, sed replaces only the first occurrence of the search pattern in each line. To replace all occurrences of the search pattern in each line, you need to supply the g flag to the substitute command. The g flag stands for global (global replace)
sed 's/my cat/my dog/g' love.txt
# Output:
# i love my dog.
# This is line 2.
# my dog is very cute.
# i love my dog and my dog loves me. Also my dog loves the sun.

# If you want only replace the nth occurrence of the search pattern in each line, you can supply the n flag to the substitute command. The n flag stands for the second occurrence of the search pattern in each line.

# Example: Replace only the second occurrence of "my cat" with "my dog" in each line of the file love.txt
sed 's/my cat/my dog/2' love.txt
# Output:
# i love my cat.
# This is line 2.
# my cat is very cute.
# i love my cat and my dog loves me. Also my cat loves the sun.

# 3.SAVING THE OUTPUT 
# Sometime, you don't want to just see the output displayed on the terminal, but you want to save that output.

# Option 1: Use redirect the output of sed command to a file.
sed 's/my cat/my dog/g' love.txt > my-new-love.txt

cat my-new-love.txt
# Output:
# i love my dog.
# This is line 2.
# my dog is very cute.
# i love my dog and my dog loves me. Also my dog loves the sun.

# The content of original file love.txt is not changed.
cat love.txt
# Output:
# i love my cat.
# This is line 2.
# my cat is very cute.
# i love my cat and my cat loves me. Also my cat loves the sun.

# Option 2: Use the -i option to edit the file in place. The -i option tells sed to edit the file in place, it means that sed will change the original file directly.
sed -i 's/my cat/my dog/g' love.txt

cat love.txt
# Output:
# i love my dog.
# This is line 2.
# my dog is very cute.
# i love my dog and my dog loves me. Also my dog loves the sun.

# Bonus: If you want to make a backup of the original file before editing it, you can supply an extension to the -i option. The extension will be used to create a backup file with that extension.
# Example: Use the -i.bak option to edit the file in place and create a backup file with the extension .bak
sed -i.bak 's/my dog/my cat/g' love.txt

# Check the content of the file love.txt
cat love.txt # this is the file has been edited
# Output:
# i love my dog.
# This is line 2.
# my dog is very cute.
# i love my dog and my dog loves me. Also my dog loves the sun.

# Check the content of the backup file love.txt.bak
cat love.txt.bak # this is the backup file has been created before editing the original file
# Output:
# i love my cat.
# This is line 2.
# my cat is very cute.
# i love my cat and my cat loves me. Also my cat loves the sun.

# Note: Don't use the space after the -i option, this will cause an error. 

sed -i .bak 's/my dog/my cat/g' love.txt
# Output: sed: -e expression #1, char 1: unknown command: `.'

# if you only want to save the lines where matches were made, you can use 'w' flag and followed by a file name.

sed 's/love/like/gw like.txt' love.txt
# Output:
# i like my dog.
# This is line 2.
# my dog is very cute.
# i like my dog and my dog likes me. Also my dog likes the sun.

cat like.txt
# Output:
# i like my dog.
# i like my dog and my dog likes me. Also my dog likes the sun.

# => sed displays the entire contents of the love.txt file to the screen with any replacements it made and it created a new file named like.txt that only contains the lines where the replacements were performed. 

# 4. CHANGE THE DELIMITER
# If we want to change '/home/jason' to '/export/users/jasonc', The chanllenging thing about this is that the string we want to manipulate have forward slashes in them and we've been using forward slashes as the delimiter in our sed command.

# Option 1: Escape the forward slashes in the string with a backslash.
echo '/home/jason' | sed 's/\/export\/users\/jasonc/'
# Output: /export/users/jasonc

# => This make the command hard to read and understand. It also make it easy to make mistakes on typing the backslashes.

# Option 2: Use a different delimiter.
# sed has a feature that allows you to use any character as the delimiter. the first character that follow the s will be treated as the delimiter.

echo '/home/jason' | sed 's#/home/jason#/export/users/jasonc#'
# Output: /export/users/jasonc

# => In this above command, we used the # character as the delimiter instead of the / character. This make the command easier to read and understand. It also make it less likely to make mistakes on typing the backslashes.
# If you need to use forward slashes in your search pattern or replacement text, choose a different delimiter other than the forward slash.

# 5.REAL-WORLD USES FOR SUBSTITUTE
# - Template files: If you often deploy websites with the same configuration except the site name, create a template with a placeholder and use sed to replace it with the real name at deploy time.
# - Migrating or restoring servers: Find and replace the old hostname with the new one in files under /etc, such as /etc/hosts, /etc/hostname, and others depending on the system.
# - Copying service configuration between hosts (common with clusters): copy the config to the new host, then use sed to change the hostname. Especially handy when the hostname appears many times.

# 6. Delete lines with sed (d command)
# Syntax: sed '/pattern/d' input-file
# The d command tells sed to delete all the lines that match the pattern.

# Review the content of the file love.txt
cat love.txt
# Output:
# i love my dog.
# This is line 2.
# my dog is very cute.
# i love my dog and my dog loves me. Also my dog loves the sun.

# Remove the lines that start with "This" in the file love.txt
sed '/^This/d' love.txt
# Output:
# i love my dog.
# my dog is very cute.
# i love my dog and my dog loves me. Also my dog loves the sun.

# Remove the lines that contain "love" in the file love.txt
sed '/love/d' love.txt
# Output:
# This is line 2.
# my dog is very cute.


# Sometimes when working with a configuration file with many lines, you may want to strip out the comments and blank lines to compact the output. 

# Create an example configuration file to demonstrate
echo '# User to run service as.' > config
echo 'User apache' >> config
echo >> config
echo '# Group to run service as.' >> config
echo 'Group apache' >> config

# Check the content of the file config
cat config
# Output:
# # User to run service as.
# User apache

# # Group to run service as.
# Group apache

# Remove the comments
sed '/^#/d' config
# Output:
# User apache

# Group apache

# Note: search-pattern is actually a regular expression. The ^ character is a special character in regular expressions that matches the beginning of a line. In above command, i use ^# to match all lines that start with the # character. It also avoid accidentally removing configuration lines that contain the # character in the middle of the line.

# Remove the blank lines
sed '/^$/d' config
# Output:
# # User to run service as.
# User apache
# # Group to run service as.
# Group apache

# At this point, you know how to remove comments and blank lines separately. You need to combine the two commands into one command to remove both comments and blank lines at the same time.

# 7. RUN MULTIPLE SED COMMANDS IN THE SAME TIME

# option 1: separate the commands with a semicolon (;)
sed '/^#/d ; /^$/d' config
# Output:
# User apache
# Group apache

# => For each line, sed will perform the first command which is to delete the lines that start with the # character. Then it will perform the second command which is to delete the blank lines. It will continue this process until it reaches the end of the file.

# option 2: Use the -e option to sed one for each sed command to execute.
sed -e '/^#/d' -e '/^$/d' config
# Output:
# User apache
# Group apache

# option 3: use the file containing the sed commands with the -f option.

# create a file named script.sed and add the following commands to it:
echo '/^#/d' > script.sed
echo '/^$/d' >> script.sed

# Note: You must place each sed command on a separate line in the file script.sed. Each line in the file script.sed is treated as a separate sed command.

# Check the content of the file script.sed
cat script.sed
# Output:
# /^#/d
# /^$/d

# Run the sed command with the -f option to execute the commands in the file script.sed on the file config
sed -f script.sed config
# Output:
# User apache
# Group apache

# 8. ADDRESSES IN SED
# Addresses determine on what lines the sed command will be executed on. If no address is specified, the sed command will be executed on all lines. 

# An address is specified before the sed command.
# The simplest of addresses is a line number.

# Display the content of the config file.
cat config
# Output:
# # User to run service as.
# User apache

# # Group to run service as.
# Group apache

# Will only execute against line two of the file.
sed '2 s/apache/httpd/' config
# Output:
# # User to run service as.
# User httpd

# # Group to run service as.
# Group apache

# => As you can see, the search pattern of Apache was replaced by HTTPD only on the second line./.There's also a match on the last line of the file, but that was left alone because it didn't match the address of line two.

# You also can not using space after the address, it display the same result as above.
sed '2s/apache/httpd/' config
# Output:
# # User to run service as.
# User httpd

# # Group to run service as.
# Group apache

# You can also use a regular expression as an address. 

# Example: You want to replace the word "apache" with "httpd" only on the lines that contain 'Group' in the file config. You can use the following command:
sed '/Group/ s/apache/httpd/' config
# Output:
# # User to run service as.
# User apache

# # Group to run service as.
# Group httpd

# => You can see, apache only changed to httpd on the line that contains 'Group'. The other line that contains 'apache' was left alone because it didn't match the address of '/Group/'.

# You can also specify a range by separating two addresses with a comma. The sed command will be executed on all lines between the two addresses, including the lines that match the addresses.

# Example: You want to replace the word "run" with "execute" only on the line ones through three of the file config. You can use the following command:
sed '1,3 s/run/execute/' config
# Output:
# # User to execute service as.
# User apache

# # Group to run service as.
# Group apache

# => Only the occurrences of "run" on lines one is replaced with "execute". The other occurrences of "run" on lines four was left alone because it didn't match the address of '1,3'.

# You can also use regular expressions instead of line numbers to specify a range.

# Example: You want to change 'run' to 'execute' starting with the line that matches # User and ending at the next blank line.

sed '/^# User/,/^$/ s/run/execute/' config
# Output:
# # User to execute service as.
# User apache

# # Group to run service as.
# Group apache

# => There was only one match for the range of lines that started with the line that matches # User and ended at the next blank line. The occurrence of "run" on that line was replaced with "execute". The other occurrences of "run" on lines four was left alone because it didn't match the address of '/^# User/,/^$/'.