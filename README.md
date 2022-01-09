### Quick installation command
`sudo wget 'https://raw.githubusercontent.com/nonplayerchar/wpize/main/init.sh' && sudo sh init.sh`

### Site Creation command 
`sudo wget 'https://raw.githubusercontent.com/nonplayerchar/wpize/main/site.sh' && sudo sh site.sh`

### Wildcard SSL Generation
sudo certbot certonly --manual --preferred-challenges dns --email "$var02" --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d "*.$var01"
