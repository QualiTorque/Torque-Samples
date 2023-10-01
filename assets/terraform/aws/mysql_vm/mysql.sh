#!/usr/bin/env bash
#SET_ENVIRONMENT_VARIABLES

# Stop Script on Error
set -e

# For Debugging (print env. variables into a file)  
printenv > /var/log/torque-vars-"$(basename "$BASH_SOURCE" .sh)".txt
 
apt-get update -y

# Preparing MYSQL for silent installation
export DEBIAN_FRONTEND="noninteractive"
echo "mysql-server mysql-server/root_password password $DB_PASS" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DB_PASS" | debconf-set-selections


# Installing MYSQL
apt-get install mysql-server -y
#apt-get install mysql-client -y


# Setting up local permission file
mkdir /home/pk;
bash -c "cat >> /home/pk/my.cnf" <<EOL
[client]

## for local server use localhost
host=localhost
user=$DB_USER
password=$DB_PASS
 
[mysql]
pager=/usr/bin/less
EOL

# Creating database
mysql --defaults-extra-file=/home/pk/my.cnf << EOF
CREATE DATABASE ${DB_NAME};
EOF

# Configuring Remote Connection Access: updating sql config to not bind to a specific address
sed -i 's/bind-address/#bind-address/g' /etc/mysql/mysql.conf.d/mysqld.cnf
echo "bind-address = 0.0.0.0" >>/etc/mysql/mysql.conf.d/mysqld.cnf

# granting db access
mysql --defaults-extra-file=/home/pk/my.cnf << EOF
GRANT ALL ON *.* TO ${DB_USER}@'%' IDENTIFIED BY '${DB_PASS}';
EOF

mysql --defaults-extra-file=/home/pk/my.cnf -e "FLUSH PRIVILEGES;"
sleep 5
systemctl restart mysql
