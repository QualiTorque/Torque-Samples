#!/usr/bin/env bash
#SET_ENVIRONMENT_VARIABLES

# Stop Script on Error
set -e

# For Debugging (print env. variables into a file)  
printenv > /var/log/torque-vars-"$(basename "$BASH_SOURCE" .sh)".txt

# Update packages and Upgrade system
echo "****************************************************************"
echo "Updating System"
echo "****************************************************************"
apt-get update -y


echo "****************************************************************"
echo "Installing Apache"
echo "****************************************************************"
apt-get install apache2 apache2-utils -y
systemctl enable apache2
systemctl start apache2


echo "****************************************************************"
echo "Installing PHP Modules"
echo "****************************************************************"
apt-get install php7.0 php7.0-mysql libapache2-mod-php7.0 php7.0-cli php7.0-cgi php7.0-gd -y



echo "****************************************************************"
echo "Installing Wordpress"
echo "****************************************************************"
echo "****************************************************************"
echo "Installing Wordpress from latest wordpress release"
echo "****************************************************************"
wget -c http://wordpress.org/latest.tar.gz -O wordpress.tar.gz 
tar -xzvf wordpress.tar.gz
rsync -av wordpress/* /var/www/html/
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/
rm /var/www/html/index.html


echo "****************************************************************"
echo "Configuring database access"
echo "****************************************************************"
cd /var/www/html || exit
mv wp-config-sample.php wp-config.php

sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
sed -i "s/username_here/$DB_USER/g" wp-config.php
sed -i "s/password_here/$DB_PASS/g" wp-config.php
sed -i "s/localhost/$DB_HOSTNAME/g" wp-config.php

systemctl restart apache2.service


