apt update
apt install -y nginx
mkdir -p /var/www/toto/

#remove default link and create new simlink betweem available and enabled
mv /tmp/toto.conf /etc/nginx/sites-available/
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/toto.conf /etc/nginx/sites-enabled/
touch /var/www/toto/index.php
echo "<?php
phpinfo();
?>" > /var/www/toto/index.php
mv /tmp/index.html /var/www/toto/

#SSL 
apt install -y openssl
openssl req -newkey rsa:2048 -x509 -sha256 -days 3650 -nodes -out toto.crt -keyout toto.key -subj "/C=FR/ST=Ile de France/L=Paris/O=Ecole 42/OU=Ecole 42/CN=toto"
mv toto.crt /etc/ssl/certs/
mv toto.key /etc/ssl/private/

#DATA BASE SQL
#give access to root user no password
apt install -y mariadb-server
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root 
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

#Install php enable server to give php files
apt install -y php7.3-fpm php7.3-mysql
service php7.3-fpm start

#word press
apt install -y wget 
cd /tmp/
wget -c https://wordpress.org/latest.tar.gz
tar -xvzf /tmp/latest.tar.gz
mv wordpress/ /var/www/toto/

#php my admin
apt install -y php-json php-mbstring
mkdir /var/www/toto/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/toto/phpmyadmin
#mv config from template
mv /tmp/config.inc.php /var/www/toto/phpmyadmin/config.inc.php

#Allow access to nginx User
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

service nginx start