class { 'network': }
class { 'network::global':
  hostname => 'pwmgmt.oakclifflabs.net',
} 
network::if::static {  'eth0': 
  ensure => 'up', 
  ipaddress => '192.168.1.16', 
  netmask => '255.255.255.0', 
  gateway => '192.168.1.1', 
} 
class { 'resolv_conf': 
  nameserver => [ '192.168.1.5', '192.168.1.1' ], 
  domain => 'oakclifflabs.net', 
} 
