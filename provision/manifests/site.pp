# self-manage the puppet master server
node 'puppet' { }

##### CLIENTS
notify { "Puppet on ${hostname} node.": }

node 'dashboard.moresby.local' {
  notify { "Debug output on ${hostname} node.": }
  class { 'helloworld': }
}

node 'client2' { }
