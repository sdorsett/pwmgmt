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

class { 'timezone':
  timezone => 'UTC',
}

lvm::volume { 'datalv':
    ensure => present,
    vg => 'datavg',
    pv => '/dev/sdb',
    fstype => 'ext4',
    size => '9G',
    before => File['/opt/ManageEngine'],
}
file { 
  '/opt/ManageEngine':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode  => 0755,
}
fstab { 'datavg-datalv':
  source => '/dev/mapper/datavg-datalv',
  dest   => '/opt/ManageEngine',
  type   => 'ext4',
  before => Exec['/bin/mount -a'], 
}

exec {'/bin/mount -a':
#  require 
}
  
# Class['lvm::module'] -> File['/opt/ManageEngine'] -> Class['fstab'] -> Exec['/bin/mount-a']
