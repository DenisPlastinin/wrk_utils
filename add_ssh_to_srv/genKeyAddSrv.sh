#!/bin/bash
Key_Name="user_ssh_key"
/usr/bin/ssh-keygen -P '' -t rsa -f ~/.ssh/$Key_Name
