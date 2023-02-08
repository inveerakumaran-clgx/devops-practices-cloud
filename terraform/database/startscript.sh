#! /bin/bash
sudo su
apt update
apt -y install mysql-server
# cat <<EOF > /var/www/html/index.html
# <html><body><p>Accessing metadata value of foo: $METADATA_VALUE</p></body></html>  >>

sudo mysql 
CREATE USER 'virus'@'35.237.204.155' IDENTIFIED BY 'Mysql@1998';
GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on *.* TO 'virus'@'35.237.204.155' WITH GRANT OPTION;
exit

sudo systemctl start mysql