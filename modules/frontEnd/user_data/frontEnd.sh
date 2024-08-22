#!/bin/bash

sudo apt update -y 

sudo apt install -y apache2 wget unzip

sudo systemctl start apache2 

sudo systemctl enable apache2 

cd /tmp

wget https://www.free-css.com/assets/files/free-css-templates/download/page296/neogym.zip

unzip *.zip

sudo rm -rf *.zip

sudo rm -rf /var/www/html/*

sudo cp -r *-html/* /var/www/html/

sudo rm -rf /tmp/*-html

sudo systemctl restart apache2
