#!/bin/bash
echo "Installation de GLPI/FusionInventory en cour, veuillez patientez"
glpi_version="9.3.2"
apt-get update -qq && apt-get upgrade -y -qq
apt-get install apache2 php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-imap php7.0-ldap php7.0-mbstring php7.0-gd php7.0-cli php7.0-apcu php7.0-xmlrpc php7.0-xml php7.0-curl mariadb-server mariadb-client php-cas ntp -y -qq
cd /var/www/html
wget --no-check-certificate -qq https://github.com/glpi-project/glpi/releases/download/$glpi_version/glpi-$glpi_version.tgz
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

wget --no-check-certificate -qq https://github.com/fusioninventory/fusioninventory-for-glpi/releases/download/glpi9.3%2B1.3/fusioninventory-9.3+1.3.tar.bz2
tar xjvf fusioninventory-9.3+1.3.tar.bz2
mv fusioninventory/ /var/www/html/glpi/plugins/

# wget --no-check-certificate https://forge.glpi-project.org/attachments/download/2179/GLPI-dashboard_plugin-0.8.2.tar.gz
# tar xzf GLPI-dashboard_plugin-0.8.2.tar.gz
# mv dashboard/ /var/www/html/glpi/plugins/
# wget --no-check-certificate https://github.com/pluginsGLPI/ocsinventoryng/releases/download/1.3.3/glpi-ocsinventoryng-1.3.3.tar.gz
# tar xzf glpi-ocsinventoryng-1.3.3.tar.gz
# mv ocsinventoryng/ /var/www/html/glpi/plugins/
# wget --no-check-certificate https://forge.glpi-project.org/attachments/download/1211/glpi-massocsimport-1.6.1.tar.gz
# tar xzf glpi-massocsimport-1.6.1.tar.gz
# mv massocsimport/ /var/www/html/glpi/plugins/
# wget --no-check-certificate https://forge.glpi-project.org/attachments/download/2143/glpi-archires-2.3.tar.gz
# tar xzf glpi-archires-2.3.tar.gz
# mv archires /var/www/html/glpi/plugins/

echo "Installation de GLPI/FusionInventory terminé !"
echo "lancer firefox localhost pour lancer l'installation WEB de GLPI"
