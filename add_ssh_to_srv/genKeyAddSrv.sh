#!/bin/bash
Key_Name="user_ssh_key"
# generate key 
/usr/bin/ssh-keygen -P '' -b 4096 -t rsa -f ~/.ssh/$Key_Name
# add key to host 
# need to install sshpass "sudo apt install sshpass"
# sshpass -p "password" ssh -o StrictHostKeyChecking=no -i ../.ssh/user_ssh_key user@host
