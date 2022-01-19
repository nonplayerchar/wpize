#! /bin/bash



echo -n "Initial site > "
read i


echo -n "Final site > "
read f



while [ $i -le $f ]
do










###################################################################################################################



var01="site$i.internal.wpvanced.com"
var13=avavance
var14=avavance443@gmail.com
var15=avavance
var03=$(gpw 1 8)         #database name
var04=$(gpw 1 8)         #database username
var05=$(pwgen -s 16 1)   #database password
var06=`sudo cat /root/db-info/db.info` #mysql master password





sudo mysql -uroot -p$var06 -e "CREATE DATABASE $var03;"
sudo mysql -uroot -p$var06 -e "CREATE USER '$var04'@'localhost' IDENTIFIED BY '$var05';"
sudo mysql -uroot -p$var06 -e "GRANT ALL ON $var03.* TO '$var04'@'localhost' WITH GRANT OPTION;"
sudo mysql -uroot -p$var06 -e "FLUSH PRIVILEGES;"


sudo cp -r /var/cms/wordpress /var/www/"$var01"


###########permissions###############
sudo chown -R www-data:www-data /var/www/"$var01"
sudo chmod -R 0755 /var/www/"$var01"
sudo chmod -R 0440 /var/www/"$var01"/wp-config.php
#####################################



sudo sed -i "s/database_name_here/$var03/g" /var/www/$var01/wp-config.php
sudo sed -i "s/username_here/$var04/g" /var/www/$var01/wp-config.php
sudo sed -i "s/password_here/$var05/g" /var/www/$var01/wp-config.php


sudo perl -i -pe'
   BEGIN {
     @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
     push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
     sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
   }
   s/put your unique phrase here/salt()/ge
 ' /var/www/"$var01"/wp-config.php





cd /var/www/$var01 
wp core install --url=$var01 --title=Wpize-Site --admin_user=$var13 --admin_email=$var14 --admin_password=$var15 --allow-root




sudo sed -i "s/#sed01/define('WP_HOME', 'https:\/\/$var01');/g" /var/www/$var01/wp-config.php
sudo sed -i "s/#sed02/define('WP_SITEURL', 'https:\/\/$var01');/g" /var/www/$var01/wp-config.php



echo "your database name var03: $var03" >> /root/sites-db-info/$var01-db.info
echo "your database username var04: $var04" >> /root/sites-db-info/$var01-db.info
echo "your database password var05: $var05" >> /root/sites-db-info/$var01-db.info
# sudo chattr +i /root/sites-db-info/$var01-db.info ## optional

##############################################################################################################################################







i=$((i+1))

done






