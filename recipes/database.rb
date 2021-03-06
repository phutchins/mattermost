mysql2_chef_gem 'default' do
  action :install
end

mysql_client 'default' do
  action :create
end

if node['mattermost']['database']['remote'] == false
  mysql_service 'mattermost' do
    bind_address '0.0.0.0'
    port '3306'
    version '5.6'
    initial_root_password node['mattermost']['database']['mysql_root']
    action [:create, :start]
  end
end

mysql_connection_info = {
  :host     => node['mattermost']['database']['hostname'],
  :username => 'root',
  :password => node['mattermost']['database']['mysql_root']
}

mysql_database "#{node['mattermost']['database']['database_name']}" do
  connection mysql_connection_info
  action :create
end

mysql_database_user "#{node['mattermost']['database']['username']}" do
  connection 	mysql_connection_info
  password      node['mattermost']['database']['password']
  database_name node['mattermost']['database']['database_name']
  action     	:grant
end
