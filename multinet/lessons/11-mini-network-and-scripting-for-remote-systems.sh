#!/bin/bash

# This lesson, learn how to create a small network of virtual machines that will simulate a company network. 
# Also learn how to configure SSH key authentication
# Also learn how to execute commands on remote systems via SSH.

# Set up common system

# one server (main administration server) => admin01
# several other servers that used to do the work for the business (web servers, database servers,..) => server01, server02

# Create new folder for set up system

# Change directory to the shellclass folder
# cd /shellclass

# Create a new folder called multinet
# mkdir -p multinet

# Change directory to the multinet folder
# cd multinet 

# Initialize a new Vagrant environment with the CentOS 7 box
# vagrant init jasonc/centos7 

# Config Vagrantfile to create multiple virtual machines

# Put these configurations in the Vagrantfile (located inside Vagrant.configure("2") do |config| )

  # config.vm.define "admin01" do |admin01|
  #   admin01.vn.hostname = "admin01"
  #   admin01.vm.network "private_network", ip: "10.9.8.10"
  # end

  # config.vm.define "server01" do |server01|
  #   server01.vn.hostname = "server01"
  #   server01.vm.network "private_network", ip: "10.9.8.11"
  # end

  # config.vm.define "server02" do |server02|
  #   server02.vn.hostname = "server02"
  #   server02.vm.network "private_network", ip: "10.9.8.12"
  # end

# Note: Some mistakes you can make when configuring the Vagrantfile include:
# 1. Forgetting "" around the ip address in the private_network configuration.
# 2. Miss comma between the ip address and the network type in the private_network configuration.
# 3. Using 'IP' instead of 'ip' in the private_network configuration.

# => Everything in the Vagrantfile needs to be configured exactly as shown above, otherwise the virtual machines will not be created properly.

# Start the virtual machines
# When working with a Vagrant multimachine setup, if you run 'vagrant up' without specifying a machine name, Vagrant will start all the machines defined in the Vagrantfile.

# Start all the virtual machines
# vagrant up 

# Run specific virtual machine
# vagrant up admin01


# Check the status of the virtual machines
# vagrant status

# SSH into the virtual machines

# When working with a vagrant single machine setup, you only need to run 'vagrant ssh' to connect to the virtual machine. Because you only have one virtual machine, Vagrant knows which machine to connect to. 
# vagrant ssh

# However, when working with a multimachine setup, you need to specify the name of the virtual machine you want to connect to.
# vagrant ssh admin01

# Check current server can communicate with others server

# Send 3 packets to the server01 and server02 to check if they are reachable from the admin01 server.
# ping -c 3 192.168.56.11 
# ping -c 3 192.168.56.12

# Resolve the name to an IP address.
# The system will check /etc/hosts file first, then check the DNS server if the name is not found in the /etc/hosts file.

# Look the content of /etc/hosts file

# cat /etc/hosts
# Output:
# 127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
# ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
# 127.0.1.1 admin01 admin01

# format of the file: IP_address hostname alias

# Add the following lines to the /etc/hosts file on the admin01 server to resolve the names of the other servers to their IP addresses.
# You use command called tee with sudo to append some lines to etc/hosts file.

# Learn about tee command: 
# Definition: read from standard input and write to standard output and files.
# Syntax: tee [OPTION]... [FILE]...
# Example: echo "Hello World" | tee hello.txt
# Option: -a, --append: append to the given FILEs, do not overwrite

# Send the following lines to the /etc/hosts file on the admin01 server to resolve the names of the other servers to their IP addresses.
# echo "192.168.56.11 server01" | sudo tee -a /etc/hosts
# echo "192.168.56.12 server02" | sudo tee -a /etc/hosts

# Check the content of /etc/hosts file again
# cat /etc/hosts
# Output:
# 127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
# ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
# 127.0.1.1 admin01 admin01
# 192.168.56.11 server01
# 192.168.56.12 server02

# If you think: why not use command: sudo echo "192.168.56.11 server01" >> /etc/hosts instead of using tee command? Let's try it and see what happens.
# sudo echo "192.168.56.11 server01" >> /etc/hosts
# Output:
# -bash: /etc/hosts: Permission denied

# Explanation: The reason is that the redirection operator (>>) is handled by the shell, not by the sudo command. So, the shell tries to open /etc/hosts for writing as the regular user, which does not have permission to do so. Using tee with sudo allows the command to run with elevated privileges, allowing it to write to /etc/hosts.

# In theory, after you specify the names of the other servers in the /etc/hosts file, you should be able to ping them by name instead of by IP address. Let's test it.
# ping -c 3 server01
# ping -c 3 server02

# We are going to be using this current VM (admin01) as our main adminstration server. We'll running commands from here that will execute on the other virtual machines on the network.

# We want to SSH into those other two systems without a password

# 1. Create an SSH key pair.
# ssh-keygen 

# 2. Put the public key on the remote system.
# Syntax: ssh-copy-id [user@]machine

# ssh-copy-id server01
# ssh-copy-id server02

# In this section, you need understand some concepts about SSH key authentication.

# Host key *check the identity of the remote system*:
# When first time you connect to a remote system via SSH, the remote system will send its public host key to your local system. Your local system will store this host key in a file called known_hosts. The next time you connect to the same remote system, your local system will check the host key against the known_hosts file to ensure that it is connecting to the same remote system and not an imposter.

# Explanation:
# serverA want to connect to serverB via SSH. 
# in the first time, serverA don't know about serverB, so serverB will send its public host key to serverA. You can receive a message like this: 
# The authenticity of host 'serverB (192.168.56.12)' can't be established.
# ECDSA key fingerprint is SHA256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# Are you sure you want to continue connecting (yes/no)? 
# => It means that you can check the fingerprint of the host key to ensure that it is correct. At this point, you can check the host key fingerprint on the remote system to ensure that it is correct. If it is correct, you can type 'yes' to continue connecting. If it is not correct, you should not continue connecting and should investigate why the host key is different. when you type 'yes', the host key will be stored in the known_hosts file on your local system. The next time you connect to the same remote system, your local system will check the host key against the known_hosts file to ensure that it is connecting to the same remote system and not an imposter.
# It means that host key is used to verify the identity of the remote system, 

# User key *check the identity of the user*:

# Normally, when you connect to a remote system via SSH, you will be prompted for a password. This is because the remote system does not know who you are and needs to verify your identity. However, if you have an SSH key pair, you can use the private key to prove your identity to the remote system without needing to enter a password. It mean you don't need to enter a password when you connect to the remote system via SSH.

# Explanation:
# serverA want to connect to serverB via SSH.
# We pass section about host key, now we are in the section about user key.
# When you create the keys by using command ssh-keygen, it will create a private key and a public key in current user's (userA) directory (local server). And after that, you will copy the public key to the remote system (serverB) in user (userB) directory by using command ssh-copy-id. When using ssh-copy-id, You will be prompted for the password of userB on serverB. After you enter the password, the public key will be copied to the remote system (serverB) in userB's directory. Now, when you in userA on serverA and you want to connect to userB on serverB via SSH, the remote system (serverB) will check if the public key of userA is in userB's authorized_keys file. If it is, the remote system (serverB) will use the public key to verify the identity of userA without needing to prompt for a password. This is because the private key of userA is used to prove the identity of userA to the remote system (serverB).

# In case you use userC on serverA to connect to userB on serverB via SSH, If the before you not yet create the keys by using command ssh-keygen for userC, you don't have a private key to prove the identity of userC to the remote system (serverB). It mean, default the key pair is only match one user to one user (userA to userB). If you want to use userC on serverA to connect to userB on serverB via SSH, you need to create a new key pair for userC and copy the public key to userB's authorized_keys file on serverB.

# Run command in the remote system via SSH
# Syntax: ssh [user@]machine [command]

# Example:
# ssh server01 hostname
# Output: server01

# Explanation how the command works:
# 1. connect to the remote system via SSH
# 2. run the command
# 3. disconnect from the remote system and back to the local system

# Example:
# for N in 1 2
# do
#  ssh server0${N} hostname
# done

# Output:
# server01
# server02

# Example:
# cd /vagrant
# echo 'server01' > servers
# echo 'server02' >> servers

# cat servers
# Output:
# server01
# server02

# for SERVER in $(cat servers)
# do
#   ssh ${SERVER} hostname
#   ssh ${SERVER} uptime
# done

# Output:
# server01
#  08:36:59 up  5:21,  0 users,  load average: 0,00, 0,01, 0,05
# server02
#  08:36:59 up  5:20,  0 users,  load average: 0,00, 0,01, 0,05

# Quoting: Where does the command run ?

# Without quotes, part of it runs locally

# ssh server01 hostname; hostname
# Output:
# server01
# admin01

# Explanation: Semicolon separates two commands. It mean the first command finish first ( when it disconnect and return local system, it is done ), and then the second command runs. The first command (ssh server01 hostname) runs on the remote system (server01) and returns the hostname of the remote system. The second command (hostname) runs on the local system (admin01) and returns the hostname of the local system.

# With single quotes (don't need variables expansion), all of it runs remotely

# ssh server01 'hostname; hostname'
# Output:
# server01
# server01

# Explanation: The quotes tell the shell to treat everything inside the quotes as a single command. It mean the all of it runs on the remote system (server01) and returns the hostname of the remote system twice.

# With double quotes (need variables expansion), all of it runs remotely
# CMD1="hostname"
# CMD2="uptime"
# ssh server01 "${CMD1}; ${CMD2}"
# Output:
# server01
# 08:48:23 up  5:32,  0 users,  load average: 0,00, 0,01, 0,05


# ps command
# definition: the ps command is used to view running processes or the process table.
# Syntax: ps [options]
# Options:
# -e: show all processes
# -f: show full format listing

# Example:
# ssh server01 "ps -ef | head -3"
# Output:
# UID        PID  PPID  C STIME TTY          TIME CMD
# root         1     0  0 03:15 ?        00:00:00 /usr/lib/systemd/systemd --switched-root --system --deserialize 21
# root         2     0  0 03:15 ?        00:00:00 [kthreadd]

# => the command 'ps -ef ' and 'head -3' runs on the remote system.

# ssh server01 ps -ef | head -3
# Output:
# UID        PID  PPID  C STIME TTY          TIME CMD
# root         1     0  0 03:15 ?        00:00:00 /usr/lib/systemd/systemd --switched-root --system --deserialize 21
# root         2     0  0 03:15 ?        00:00:00 [kthreadd]

# => the command 'ps -ef' runs on the remote system, but the command 'head -3' runs on the local system.

# Exit status of the command run via SSH
# ssh exits with the exit status of the remote command or with 255 if an error occurred.

# Example:
# ssh server03 uptime 
# Output:
# ssh: Could not resolve hostname server03: Name or service not known

# echo $?
# Output: 255

# => you can check the exit status 255 to distinguish an SSH error from an error that's coming from a remote command.

# ssh server02 uptime 
# Output:
#  09:58:28 up  6:41,  0 users,  load average: 0,00, 0,01, 0,05

# echo $?
# Output: 0

# If you want any non-zero exit statuses to be returned if errors occur in the pipeline on remote system, you can use set -o pipefail in the remote command. This will cause the SSH command to return a non-zero exit status if any command in the pipeline fails.

# set [-abefhkmnptuvxBCHP] [-o option-name] [--] [arg ...]
# Set or unset values of shell options and positional parameters.
# Change the value of shell attributes and positional parameters, or display the names and values of shell variables.

# pipefail: the return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status.

# => this is something to keep in mind if you wanna make sure that every command in a pipeline was successful on the remote system.

# When working with a Vagrant multimachine setup, similar to the 'vagrant up' command, if you run 'vagrant halt' without specifying a machine name, Vagrant will halt all the machines defined in the Vagrantfile.
# Halt all the virtual machines
# vagrant halt

# Halt specific virtual machine
# vagrant halt admin01

# Note: 
# 1. This relationship that we set up between the systems with SSH authentication, it's a one-way relationship.We can SSH into server01 and server02 from admin01, but not the other way around.
# It's a common practice to have these one-way relationships so that you can designate an administration server (admin01) to do all your admin work from.
# Of course, you can set things up to go the other way (e.g. server01 -> admin01), but you'll have to do all the steps again on that server:
# - add host entries to /etc/hosts
# - generate keys (ssh-keygen)
# - copy the public key to where you want to log into (ssh-copy-id)

# 2. A critical distinction when using sudo with ssh: WHERE sudo runs decides WHO you are.

# Case 1: sudo runs on the REMOTE system
# ssh server01 sudo id
# Output:
# uid=0(root) gid=0(root) groups=0(root)

# Explanation:
# 1. ssh is executed on the local system (admin01) as the current user (vagrant).
# 2. We are connected to server01 as the vagrant user (no password needed, because we copied vagrant's public key to server01 before).
# 3. The command 'sudo id' is executed as the vagrant user on server01. sudo gives us root privileges on server01, so the id we get back is the root id.

# Case 2: sudo runs on the LOCAL system
# sudo ssh server01 id
# Output:
# The authenticity of host 'server01 (192.168.56.11)' can't be established.
# ECDSA key fingerprint is SHA256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# Are you sure you want to continue connecting (yes/no)? yes
# Warning: Permanently added 'server01,192.168.56.11' (ECDSA) to the list of known hosts.
# root@server01's password:        <= enter the root password of server01 (in this lab: vagrant)
# uid=0(root) gid=0(root) groups=0(root)

# Explanation:
# 1. sudo makes us root first on the local system (admin01), then ssh is executed as the root user.
# 2. We are connecting to server01 as the root user. It's as if we're running 'ssh server01' as root.
# 3. The command 'id' is executed as the root user on server01.

# Why does it ask about the host key again? Because root has its own known_hosts file (/root/.ssh/known_hosts), separate from vagrant's (/home/vagrant/.ssh/known_hosts).
# Why does it ask for a password? Because root on admin01 doesn't have an SSH key pair, and there is no public key in root's authorized_keys on server01. The key pair we created belongs to vagrant only (same as the userC example in the User key section above).

# => Same output, but a very different way to get it:
#    ssh server01 sudo id   => connect as vagrant, then become root on server01   (no password)
#    sudo ssh server01 id   => become root on admin01, then connect as root       (need root's password of server01)

# If you want to run 'sudo ssh' without a password, you have to generate SSH keys for the root user and copy the public key to the destination servers, like we did before with the vagrant user.
# sudo ssh-keygen
# sudo ssh-copy-id server01
# sudo ssh-copy-id server02

# 3. Some Linux systems are configured so that root logins aren't allowed (PermitRootLogin no in /etc/ssh/sshd_config). On these systems, you have to connect as a normal user and then run sudo on the remote system (Case 1) instead of connecting as root (Case 2).
