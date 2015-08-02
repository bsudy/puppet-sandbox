# -*- mode: ruby -*-
# vi: set ft=ruby :

domain = 'moresby.local'

# ubuntu/trusty64
# puppetlabs/ubuntu-14.04-64-puppet
puppet_nodes = [
  {:hostname => 'puppet',  :ip => '172.16.32.10', :box => 'ubuntu/trusty64', :fwdhost => 8140, :fwdguest => 8140, :ram => 512},
  {:hostname => 'dashboard', :ip => '172.16.32.11', :box => 'ubuntu/trusty64'},
#  {:hostname => 'chat', :ip => '172.16.32.12', :box => 'ubuntu/trusty64'},
]

Vagrant.configure("2") do |config|
  puppet_nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.hostname = node[:hostname] + '.' + domain
      node_config.vm.network :private_network, ip: node[:ip]
      if node[:hostname] == "puppet"
          node_config.vm.synced_folder "provision/manifests", "/etc/puppet/manifests"
          node_config.vm.synced_folder "provision/modules", "/etc/puppet/modules"
          node_config.vm.synced_folder "provision/hieradata", "/etc/puppet/hieradata"
      end
      if node[:fwdhost]
        node_config.vm.network :forwarded_port, guest: node[:fwdguest], host: node[:fwdhost]
      end

      memory = node[:ram] ? node[:ram] : 256;
      node_config.vm.provider :virtualbox do |vb|
        vb.customize [
          'modifyvm', :id,
          '--name', node[:hostname],
          '--memory', memory.to_s
        ]
      end
        
      node_config.vm.provision :shell do |shell|
        shell.inline = "
mkdir -p /etc/puppet/modules;
          (puppet module list | grep puppetlabs-apt) || puppet module install puppetlabs-apt;
          (puppet module list | grep puppetlabs-puppetdb) || puppet module install puppetlabs-puppetdb;
          (puppet module list | grep stephenrjohnson-puppet) || puppet module install stephenrjohnson-puppet;
          (puppet module list | grep puppetlabs-puppet_agent) || puppet module install puppetlabs-puppet_agent"
          
  end

      node_config.vm.provision :puppet do |puppet|
        #puppet.manifests_path = "puppet/manifests"
        #puppet.manifest_file = "default.pp"
        #puppet.hiera_config_path = "puppet/config/hiera.yaml"
        #puppet.options = ["--debug", "--verbose", "--fileserverconfig=/vagrant/fileserver.conf"]
        puppet.manifests_path = 'vagrant_provision/manifests'
        #puppet.module_path = 'provision/modules'
        #puppet.options = ["--debug", "--verbose"]
      end
    end
  end
    
end
