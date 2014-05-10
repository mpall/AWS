cd ~
curl -L https://www.opscode.com/chef/install.sh | bash
wget http://github.com/opscode/chef-repo/tarball/master
tar -zxf master
mv opscode-chef-repo* chef-repo
rm master
cd chef-repo/
mkdir .chef
echo "cookbook_path [ '/root/chef-repo/cookbooks' ]" > .chef/knife.rb
knife cookbook create phpapp
cd cookbooks

knife cookbook site download apache2
tar zxf apache2*
rm apache2*.tar.gz
knife cookbook site download apt
tar zxf apt*
rm apt*.tar.gz
knife cookbook site download iptables
tar zxf iptables*
rm iptables*.tar.gz
knife cookbook site download logrotate
tar zxf logrotate*
rm logrotate*.tar.gz
knife cookbook site download pacman
tar zxf pacman*
rm pacman*.tar.gz

echo "depends \"apache2\"" >> phpapp/metadata.rb

echo "

include_recipe \"apache2\"

apache_site \"default\" do
  enable true
end
" >> phpapp/recipes/default.rb

cd ..

echo "file_cache_path \"/root/chef-solo\"
cookbook_path \"/root/chef-repo/cookbooks\"
role_path \"/root/chef-repo/roles\"
" > solo.rb



echo "{
  \"mysql\": {\"server_root_password\": \"808052769e2c6d909027a2905b224bad\", \"server_debian_password\": \"569d1ed2d46870cc020fa87be83af98d\", \"server_repl_password\": \"476911180ee92a2ee5a471f33340f6f4\"},
  \"run_list\": [ \"recipe[apt]\", \"recipe[phpapp]\" ]
}" > web.json


chef-solo -c solo.rb -j web.json


#MySQL
cd cookbooks
knife cookbook site download mysql 4.1.2
tar zxf mysql*
rm mysql-*.tar.gz

echo "depends \"mysql\", \"4.1.2\"" >> phpapp/metadata.rb

echo "
include_recipe \"mysql::client\"
include_recipe \"mysql::server\"
" >> phpapp/recipes/default.rb


knife cookbook site download openssl
tar zxf openssl*.tar.gz
rm openssl*.tar.gz
knife cookbook site download build-essential
tar zxf build-essential-*.tar.gz
rm build-essential-*.tar.gz
knife cookbook site download homebrew
tar zxf homebrew-*.tar.gz
rm homebrew-*.tar.gz
knife cookbook site download windows
tar zxf windows-*.tar.gz
rm windows-*.tar.gz
knife cookbook site download chef_handler
tar zxf chef_handler-*.tar.gz
rm chef_handler-*.tar.gz

MAY NOT NEED THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
MANUAL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
EDIT FILE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
cookbooks/mysql/attributes/server.rb
default['mysql']['server_root_password']        = 'iloverandompasswordsbutthiswilldo'
default['mysql']['server_repl_password']        = 'iloverandompasswordsbutthiswilldo'
default['mysql']['server_debian_password']      = 'iloverandompasswordsbutthiswilldo'

cd ..
chef-solo -c solo.rb -j web.json


cd cookbooks/
knife cookbook site download php
tar zxf php*.tar.gz
rm php*.tar.gz


knife cookbook site download xml
tar zxf xml-*.tar.gz
knife cookbook site download yum
tar zxf yum-*.tar.gz
knife cookbook site download yum-epel
tar zxf yum-epel-*.tar.gz
knife cookbook site download powershell
tar zxf powershell-*.tar.gz
knife cookbook site download iis
tar zxf iis-*.tar.gz
rm *.tar.gz


echo "depends \"php\"" >> phpapp/metadata.rb

echo "
#
# Cookbook Name:: phpapp
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


include_recipe \"apache2\"
include_recipe \"mysql::client\"
include_recipe \"mysql::server\"
include_recipe \"php\"
include_recipe \"php::module_mysql\"
include_recipe \"apache2::mod_php5\"

apache_site \"default\" do
  enable true
end 
" > phpapp/recipes/default.rb


echo "
<?php phpinfo(); ?>
" > /var/www/test.php

