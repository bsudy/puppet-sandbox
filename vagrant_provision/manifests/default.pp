#
# site.pp - defines defaults for vagrant provisioning
#
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", " /usr/local/bin/" ] }



# use run stages for minor vagrant environment fixes
#stage { 'pre': before => Stage['main'] }

# class { 'repos':   stage => 'pre' }
#class { 'vagrant': stage => 'pre' }

# class { 'networking': }
 
class { 'apt':
  update => {
    frequency => 'daily',
  },
}

apt::source { 'puppetlabs':
  location => 'http://apt.puppetlabs.com',
  repos    => 'main',
  key      => {
    'id'     => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
    'server' => 'pgp.mit.edu',
  }
}

notify { "Hostname: $hostname" : }
if $hostname == "puppet" {
  

  notify { "Puppet master" : }
#  package { 'hiera-ruby' :
#    ensure => absent,
#  } ->
#  package {'puppetmaster':
#    ensure  =>  latest,
#  } ->
#  service {'puppetmaster':
#    ensure => running,
#  }
  
  class { 'puppet::master': 
    autosign => true,
  }
  # Configure puppetdb and its underlying database
#  class { 'puppetdb': 
#    listen_address => '0.0.0.0',
#    require => Package['puppetmaster'],
#    confdir => '/etc/puppetdb/conf.d',
##    puppetdb_version => latest,
#    }
#  # Configure the puppet master to use puppetdb
#  class { 'puppetdb::master::config':
#    terminus_package => 'puppetdb-terminus',  
#  }
    
#  class {'dashboard':
#    dashboard_site    => $fqdn,
#    dashboard_port    => '3000',
#    require           => Package["puppetmaster"],
#  }
  
  
#  class { 'puppetdb': 
#    listen_address => '0.0.0.0',
#    require => Package['puppetmaster'],
#    #puppetdb_version => latest,
#    #listen_address => '*.moresby.local',
#    confdir => '/etc/puppetdb/conf.d',
#    #listen_port => 8080,
#    #ssl_listen_port => 8081,
#  }
#  class { 'puppetdb::master::config':
#    terminus_package => 'puppetdb-terminus',
#    #puppetdb_port   => 8081,
#  }
#  class { 'puppet::master':
#    storeconfigs              => true,
#  }
} else {
  notify { "Puppet client" : }
  host { 'puppet.moresby.local':
    ensure       => 'present',
    host_aliases => ['puppet'],
    ip           => '172.16.32.10',
    target       => '/etc/hosts',
  } ->
  class { 'puppet::agent':
    puppet_server             => "puppet.moresby.local",
    environment               => production,
    puppet_run_interval       => 1,
    splay                     => true,
  } ->
  file { '/var/lib/puppet/state/agent_disabled.lock':
    ensure => 'absent',
  }
}
