#
# Use Basho via APT to PACKAGECLOUD repository
#
package 'apt-transport-https'

apt_repository 'basho-riak' do
  uri 'https://packagecloud.io/basho/riak/ubuntu/'
  distribution node['lsb']['codename']
  components ['main']
  key 'https://packagecloud.io/gpg.key'
  retries 2
  retry_delay 30
  action :add
end

package 'riak'

#
# - Stop riak service to customize configuration files
# - Don't enable riak service at server boot time
#
service 'riak' do
  supports status: true, restart: true
  action [:disable, :stop]
end

template '/etc/riak/riak.conf' do
  source 'riak.conf.erb'
  owner 'riak'
  group 'riak'
  mode 0644
end

execute 'remove Bashio APT package source' do
  command 'rm -f /etc/apt/sources.list.d/basho-riak-source.list'
end
