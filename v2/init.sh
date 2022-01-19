#! /bin/bash






echo -n "Enter amount of ram you want to allow to PHP (Syntax - {in mb} without postfix | integer) > "
read phpmemory

echo -n "Enter amount of ram you want to allow to Opache(Syntax - {in mb} without postfix | integer) > "
read opcachememory



echo -n "Have you Configured Wildcard SSL? (y / n) > "
read yorn

varyorn=`echo "$yorn" | grep -q "y" && echo "true" || echo "false"`

if $varyorn;
  then echo -n "Enter Wildcard Domain > " && read var01;
fi


echo -n "Press 'y' to continue > "
read varinput
echo "Yy" | grep -q "$varinput" && echo "continuing..." || echo "exiting..."
echo "Yy" | grep -q "$varinput" || exit 1




sudo apt-get update
sudo apt-get install software-properties-common -y
sudo apt-get install certbot -y
sudo apt-get install cron -y
sudo apt-get install nginx -y
sudo apt-get install mariadb-server -y
sudo apt-get install mariadb-client -y

sudo apt-get install pwgen -y
sudo apt-get install gpw -y

var06=$(pwgen -s 16 1)   #mysql password




#mariadb conf
sudo mysqladmin password "$var06"
sudo mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -u root -e "DROP DATABASE IF EXISTS test;"
sudo mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"





# PHP install & setup
echo | sudo add-apt-repository ppa:ondrej/php
echo | sudo add-apt-repository ppa:ondrej/nginx-mainline
sudo apt-get update

sudo apt-get install php8.0-fpm php8.0-common php8.0-mysql php8.0-gmp php8.0-curl php8.0-intl php8.0-mbstring php8.0-xmlrpc php8.0-gd php8.0-xml php8.0-cli php8.0-zip php8.0-soap php8.0-imagick php8.0-redis -y

sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 128M/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/post_max_size = 8M/post_max_size = 128M/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/short_open_tag = Off/short_open_tag = On/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/allow_url_include = Off/allow_url_include = On/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo = 0/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/max_execution_time = 30/max_execution_time = 300/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/max_input_time = 60/max_input_time = 300/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;max_input_vars = 1000/max_input_vars = 128/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/memory_limit = 128/memory_limit = $phpmemory/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;date.timezone =/date.timezone = $timezone/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;date.timezone =/date.timezone = Asia\/Kolkata/g" /etc/php/8.0/fpm/php.ini
#sudo sed -i "s/;date.timezone =/date.timezone = America\/Chicago/g" /etc/php/8.0/fpm/php.ini

# PHP Zend Opcache
sudo sed -i "s/;opcache.enable=1/opcache.enable=1/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;zend_extension=opcache/zend_extension=opcache/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;opcache.memory_consumption=128/opcache.memory_consumption=$opcachememory/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;opcache.interned_strings_buffer=8/opcache.interned_strings_buffer=16/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;opcache.max_accelerated_files=10000/opcache.max_accelerated_files=16229/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;opcache.max_wasted_percentage=5/opcache.max_wasted_percentage=10/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;opcache.mmap_base=/opcache.mmap_base=0x20000000/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;opcache.file_cache=/opcache.file_cache=\/var\/www\/.opcache/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;opcache.max_file_size=0/opcache.max_file_size=16M/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;opcache.validate_timestamps=1/opcache.validate_timestamps=1/g" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;opcache.revalidate_freq=2/opcache.revalidate_freq=0/g" /etc/php/8.0/fpm/php.ini




# SSL Dhparam setup
cd /etc/ssl
sudo openssl dhparam -out dhparam.pem 2048
cd
mkdir /etc/ssl/trusted
sudo wget 'https://letsencrypt.org/certs/isrgrootx1.pem'  -O /etc/ssl/trusted/chain.pem

# Correct owners for ssl dirs
sudo chown -R www-data:www-data /etc/ssl/
sudo chown -R www-data:www-data /etc/ssl/dhparam.pem
sudo chown -R www-data:www-data /etc/letsencrypt/


# Nginx Setup
sudo apt-get install nginx -y
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.original
sudo rm -r /etc/nginx/sites-enabled
sudo rm -r /etc/nginx/sites-available
sudo rm -r /etc/nginx/snippets
sudo rm -r /etc/nginx/conf.d
sudo rm /etc/nginx/fastcgi.conf
sudo rm /etc/nginx/fastcgi_params
sudo rm /etc/nginx/proxy_params
sudo rm /etc/nginx/scgi_params
sudo rm /etc/nginx/uwsgi_params 

sudo mkdir /etc/nginx/sites
sudo mkdir /etc/nginx/fastcgi

sudo wget --no-check-certificate 'https://raw.githubusercontent.com/nonplayerchar/wpize/main/nginx-v1.1.conf' -O /etc/nginx/nginx.conf
sudo wget --no-check-certificate 'https://raw.githubusercontent.com/nonplayerchar/wpize/main/domain-v1.1.conf' -O /etc/nginx/sites/domain-dynamic.conf

if $varyorn;
  then sudo wget --no-check-certificate 'https://raw.githubusercontent.com/nonplayerchar/wpize/main/domain-wildcard-v1.1.conf' -O /etc/nginx/sites/$var01-wildcard.conf && sudo sed -i "s/domain/$var01/g" /etc/nginx/sites/$var01-wildcard.conf;
fi

sudo wget --no-check-certificate 'https://raw.githubusercontent.com/nonplayerchar/wpize/main/fastcgi-php.conf' -O /etc/nginx/fastcgi/fastcgi-php.conf

sudo mkdir -p /var/www

###########permissions###############
sudo chown -R www-data:www-data /var/www/
#####################################




# CMS
mkdir /var/cms
cd /var/cms/
wget 'https://wordpress.org/latest.tar.gz' -O /var/cms/wordpress.tar.gz
tar -zxf /var/cms/wordpress.tar.gz
#sudo cp /var/cms/wordpress/wp-config-sample.php /var/cms/wordpress/wp-config.php
sudo wget 'https://raw.githubusercontent.com/nonplayerchar/wpize/main/wp-config.php' -O /var/cms/wordpress/wp-config.php
#sudo cp /var/cms/wordpress/wp-config.php /var/cms/wordpress/wp-config-base.php
rm /var/cms/wordpress.tar.gz


###################### wp cli install #######################
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
#############################################################



# Package Update
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get clean -y
sudo apt-get autoclean -y
sudo apt autoremove -y




# Restrating services
sudo systemctl enable mariadb
sudo systemctl enable nginx
sudo systemctl enable php8.0-fpm


sudo systemctl restart mariadb
sudo systemctl restart nginx
sudo systemctl restart php8.0-fpm




# Saving db info to root dir
sudo mkdir /root/db-info
sudo mkdir /root/sites-db-info
echo "$var06" >> /root/db-info/db.info
sudo chattr +i /root/db-info/db.info




echo "-----------------------------"
echo "reconsider following variables in /etc/php/8.0/fpm/php.ini based on server capability & PHP.NET DOCS: "
echo "1.opcache.interned_strings_buffer"
echo "2.opcache.max_accelerated_files"
echo "3.Due to a bug in sed please reconfigure PHP timzone correctly"

echo "reconsider following variables in /etc/nginx/nginx.conf: "
echo "1.2.hash & buffer sizes"

echo "-----------------------------"
echo "All Done!"
echo "Great Success!"

