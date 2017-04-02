#!/bin/bash
glpi_version="9.1.2"
apt-get install -y apache2 php5 libapache2-mod-php5 php5-mysql php5-imap php5-ldap php5-gd php5-curl mysql-server mysql-client ntp
cd /var/www/html
wget --no-check-certificate https://github.com/glpi-project/glpi/releases/download/$glpi_version/glpi-$glpi_version.tgz
tar xvf glpi-$glpi_version.tgz
chown -R www-data:www-data /var/www/html/glpi/
chmod -R 777 /var/www/html/glpi/
touch /etc/apache2/sites-available/glpi.conf
echo '<VirtualHost *:80>
  ServerName localhost
  DocumentRoot /var/www/html/glpi/
 <Directory /var/www/html/glpi>
        AllowOverride All
        Order allow,deny
        Options Indexes
        Allow from all
 </Directory>
</VirtualHost>' >> /etc/apache2/sites-available/glpi.conf
a2ensite glpi
/etc/init.d/apache2 reload
service ntp start

read -p "Enter your MySQL root password: " rootpass
read -p "Database name: " dbname
read -p "Database username: " dbuser
read -p "Enter a password for user $dbuser: " userpass
echo "CREATE DATABASE $dbname;" | mysql -u root -p$rootpass
echo "CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$userpass';" | mysql -u root -p$rootpass
echo "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost';" | mysql -u root -p$rootpass
echo "FLUSH PRIVILEGES;" | mysql -u root -p$rootpass
echo "New MySQL database is successfully created"

wget --no-check-certificate https://forge.glpi-project.org/attachments/download/2179/GLPI-dashboard_plugin-0.8.2.tar.gz
tar xzf GLPI-dashboard_plugin-0.8.2.tar.gz
mv dashboard/ /var/www/html/glpi/plugins/
wget --no-check-certificate https://github.com/pluginsGLPI/ocsinventoryng/releases/download/1.3.3/glpi-ocsinventoryng-1.3.3.tar.gz
tar xzf glpi-ocsinventoryng-1.3.3.tar.gz
mv ocsinventoryng/ /var/www/html/glpi/plugins/
wget --no-check-certificate https://forge.glpi-project.org/attachments/download/1211/glpi-massocsimport-1.6.1.tar.gz
tar xzf glpi-massocsimport-1.6.1.tar.gz
mv massocsimport/ /var/www/html/glpi/plugins/
wget --no-check-certificate https://forge.glpi-project.org/attachments/download/2143/glpi-archires-2.3.tar.gz
tar xzf glpi-archires-2.3.tar.gz
mv archires /var/www/html/glpi/plugins/
