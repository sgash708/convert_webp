#!/bin/bash

# inotify-tools
# REF: https://www.server-world.info/query?os=CentOS_6&p=inotify
sudo su

# webp設定
yum install libwebp-tools
mkdir /var/www/html/webp
wget -c "https://upload.wikimedia.org/wikipedia/commons/2/24/Junonia_orithya-Thekkady-2016-12-03-001.jpg?download" -O /var/www/html/webp/image1.jpg
wget -c "https://upload.wikimedia.org/wikipedia/commons/5/54/Mycalesis_junonia-Thekkady.jpg" -O /var/www/html/webp/image2.jpg
wget -c "https://cdn.pixabay.com/photo/2017/07/18/15/39/dental-care-2516133_640.png" -O /var/www/html/webp/logo.png

# inotify設定
yum install epel-release
yum install inotify-tools
touch /etc/inotifywait.conf/
echo "LOGFILE=/var/log/inotify.log\nMONITOR=/etc\nEVENT=create,delete,modify,move" >> /etc/inotifywait.conf
