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

