#!/bin/bash

# REF: https://www.server-world.info/query?os=CentOS_6&p=inotify
sudo su

# webp
yum install libwebp-tools

# inotify
yum install epel-release
yum install inotify-tools
