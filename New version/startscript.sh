#! /bin/bash
sudo su
apt update
apt -y install mysql-server
cat <<EOF > /var/www/html/index.html
<html><body><p>Accessing metadata value of foo: $METADATA_VALUE</p></body></html>