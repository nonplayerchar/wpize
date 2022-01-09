#! /bin/bash


echo -n "Enter your domain name > "
read var01

echo -n "Enter your email address for ssl certificate generation > "
read var02

echo -n "Enter your mysql-db master password > "
read var06




var03=$(gpw 1 8)         #database name
var04=$(gpw 1 8)         #database username
var05=$(pwgen -s 16 1)   #database password
var06=`sudo cat /root/db-info/db.info` #mysql master password




var011=`echo "$var01" | sudo sed "s/www.//g"`
varwww=`echo "$var01" | grep -q "www." && echo "true" || echo "false"`
varwpvanced=`echo "$var01" | grep -q ".wpvanced.com" && echo "true" || echo "false"`

wp_home="define('WP_HOME', '$var01');"
wp_siteurl="define('WP_SITEURL', '$var01');"



sudo mysql -uroot -p$var06 -e "CREATE DATABASE $var03;"
sudo mysql -uroot -p$var06 -e "CREATE USER '$var04'@'localhost' IDENTIFIED BY '$var05';"
sudo mysql -uroot -p$var06 -e "GRANT ALL ON $var03.* TO '$var04'@'localhost' WITH GRANT OPTION;"
sudo mysql -uroot -p$var06 -e "FLUSH PRIVILEGES;"



sudo cp -r /var/cms/wordpress /var/www/"$var01"
#sudo mv /var/www/"$var01"/wp-config-sample.php /var/www/"$var01"/wp-config.php
sudo wget 'https://raw.githubusercontent.com/nonplayerchar/wpize/main/wp-config.php' -O /var/www/$var01/wp-config.php

sudo sed -i "s/database_name_here/$var03/g" /var/www/$var01/wp-config.php
sudo sed -i "s/username_here/$var04/g" /var/www/$var01/wp-config.php
sudo sed -i "s/password_here/$var05/g" /var/www/$var01/wp-config.php
sudo sed -i "s/$table_prefix = 'wp_';/$table_prefix = '$var01';/g" /var/www/$var01/wp-config.php
sudo sed -i "s/define( 'DB_HOST', 'localhost' );/define( 'DB_HOST', 'localhost' ); define( 'WP_REDIS_HOST', 'localhost' );/g" /var/www/$var01/wp-config.php

sudo perl -i -pe'
   BEGIN {
     @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
     push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
     sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
   }
   s/put your unique phrase here/salt()/ge
 ' /var/www/"$var01"/wp-config.php






###sudo certbot certonly --non-interactive --webroot --email "$var02" --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d "$var01" -w /var/www/$var01
#sudo chown -R www-data:www-data /etc/letsencrypt/live
#sudo chown -R www-data:www-data /etc/letsencrypt/live/$domain





if $varwpvanced;
  then return;
elif $varwww;
  then sudo certbot certonly --non-interactive --webroot --email "$var02" --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d "$var01" -w /var/www/$var01 && ln -s /etc/letsencrypt/live/$var011 /etc/letsencrypt/live/www.$var011;
else 
  sudo certbot certonly --non-interactive --webroot --email "$var02" --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d "$var01" -w /var/www/$var01;
fi








sudo sed -i "s/#sed01/$wp_home/g" /var/www/$var01/wp-config.php
sudo sed -i "s/#sed02/$wp_siteurl/g" /var/www/$var01/wp-config.php







sudo mkdir /root/sites-db-info
echo "wp prefix table is $var01" >> /root/sites-db-info/$var01-db.info
echo "your database name var03: $var03" >> /root/sites-db-info/$var01-db.info
echo "your database username var04: $var04" >> /root/sites-db-info/$var01-db.info
echo "your database password var05: $var05" >> /root/sites-db-info/$var01-db.info
sudo chattr +i /root/sites-db-info/$var01-db.info



echo "-----------------------------"
echo "All Done!"
echo "Great Success!"

