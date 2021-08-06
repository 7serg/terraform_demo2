#!/bin/bash

sudo apt-get -y update

sudo apt install -y apache2

sudo systemctl start apache2

echo "Hello world from $(hostname -f)" >> /var/www/html/index.html
