#! /bin/bash


echo -n "Theme Slug > "
read theme_slug

echo -n "Initial site > "
read i

echo -n "Final site > "
read f



while [ $i -le $f ]
do

###########################################################################################
var01="site$i.internal.wpvanced.com"
cd /var/www/$var01
# --path=`path/to/wordpress` or run `wp core download`
wp theme install $theme_slug --activate --allow-root
cd
echo "$var01 done!"
###########################################################################################
i=$((i+1))

done

