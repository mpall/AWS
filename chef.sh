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

knife cookbook site download database
tar zxf database-*.tar.gz
knife cookbook site download postgresql
tar zxf postgresql-*.tar.gz
knife cookbook site download xfs
tar zxf xfs-*.tar.gz
knife cookbook site download aws
tar zxf aws-*.tar.gz
rm *.tar.gz
knife cookbook site download mysql-chef_gem
tar zxf mysql-chef_gem-*.tar.gz
rm *.tar.gz


echo "depends \"database\"" >> phpapp/metadata.rb

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
include_recipe \"mysql::ruby\"

apache_site \"default\" do
  enable true
end

mysql_database node['phpapp']['database'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end 
" > phpapp/recipes/default.rb


echo "
default[\"phpapp\"][\"database\"] = \"phpapp\"
" > phpapp/attributes/default.rb

#sudo netstat -tap | grep mysql


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
include_recipe \"mysql::ruby\"

apache_site \"default\" do
  enable true
end

mysql_database node['phpapp']['database'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node['phpapp']['db_username'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  password node['phpapp']['db_password']
  database_name node['phpapp']['database']
  privileges [:select,:update,:insert,:create,:delete]
  action :grant
end
 
" > phpapp/recipes/default.rb

echo "
default[\"phpapp\"][\"database\"] = \"phpapp\"
default[\"phpapp\"][\"db_username\"] = \"phpapp\"
" > phpapp/attributes/default.rb

echo "{
  \"mysql\": {\"server_root_password\": \"808052769e2c6d909027a2905b224bad\", \"server_debian_password\": \"569d1ed2d46870cc020fa87be83af98d\", \"server_repl_password\": \"476911180ee92a2ee5a471f33340f6f4\"},
  \"phpapp\": {\"db_password\": \"212b09752d173876a84d374333ae1ffe\"},
  \"run_list\": [ \"recipe[apt]\", \"recipe[phpapp]\" ]
}" > web.json


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
include_recipe \"mysql::ruby\"

apache_site \"default\" do
  enable true
end

mysql_database node['phpapp']['database'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node['phpapp']['db_username'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  password node['phpapp']['db_password']
  database_name node['phpapp']['database']
  privileges [:select,:update,:insert,:create,:delete]
  action :grant
end


wordpress_latest = Chef::Config[:file_cache_path] + \"/wordpress-latest.tar.gz\"

remote_file wordpress_latest do
  source \"http://wordpress.org/latest.tar.gz\"
  mode \"0644\"
end

directory node[\"phpapp\"][\"path\"] do
  owner \"root\"
  group \"root\"
  mode \"0755\"
  action :create
  recursive true
end

execute \"untar-wordpress\" do
  cwd node['phpapp']['path']
  command \"tar --strip-components 1 -xzf \" + wordpress_latest
  creates node['phpapp']['path'] + \"/wp-settings.php\"
end

 
" > phpapp/recipes/default.rb


echo "
default[\"phpapp\"][\"database\"] = \"phpapp\"
default[\"phpapp\"][\"db_username\"] = \"phpapp\"
default[\"phpapp\"][\"path\"] = \"/var/www/phpapp\"
" > phpapp/attributes/default.rb



IN THE 'Templates' section on the we page


