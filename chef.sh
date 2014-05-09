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
" > solo.rb

echo "{
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




cd ..
chef-solo -c solo.rb -j web.json