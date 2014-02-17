# add hostname and eth0 network configurations
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

# add domain & nameservers to /etc/resolv.conf
class { 'resolv_conf': 
  nameserver => [ '192.168.1.5', '192.168.1.1' ], 
  domain => 'oakclifflabs.net', 
} 

# set time to to UTC
class { 'timezone':
  timezone => 'UTC',
}

# add LVM volume, group & format with ext4
lvm::volume { 'datalv':
    ensure => present,
    vg => 'datavg',
    pv => '/dev/sdb',
    fstype => 'ext4',
    size => '9G',
    before => File['/opt/ManageEngine'],
}

# ensure directory for fstab mount is present
file { 
  '/opt/ManageEngine':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode  => 0755,
}

# add /etc/fstab entry to mount LVM source to /opt/ManageEngine
fstab { 'datavg-datalv':
  source => '/dev/mapper/datavg-datalv',
  dest   => '/opt/ManageEngine',
  type   => 'ext4',
  before => Exec['/bin/mount -a'], 
}

# run 'mount -a' to re-read the /etc/fstab file 
exec {'/bin/mount -a':}

# add 'compat-libstdc++-296' package
package {'compat-libstdc++-296':
  ensure => 'installed',
}

