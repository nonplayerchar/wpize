#! /bin/bash

echo -n "Theme Slug > "
read theme_slug


echo -n "Initial site > "
read i


echo -n "Final site > "
read f



while [ $i -le $f ]
do











###########################################################################################33333



var01="site$i.internal.wpvanced.com"



cd /var/www/$var01
wp theme install $theme_slug --activate --allow-root





###########################################################################################33333
















i=$((i+1))

done

