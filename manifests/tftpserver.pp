class edeploy::tftpserver (
  $address,
  $port = $tftp::params::port,
  $directory = $tftp::params::directory,
  $username = $tftp::params::username,
  $options = $tftp::params::options,
  $inetd = $tftp::params::inetd
) inherits tftp::params {

  class {'tftp' :
    address   => $address,
    port      => $port,	
    directory => $directory,
    username  => $username,
    options   => $options,
    inetd     => $inetd
  } ->
  tftp::file { 'pxelinux.0':
    source => 'puppet:///modules/edeploy/tftpserver/pxelinux.0',
  } ->
  file {"${directory}/pxelinux.cfg" :
    ensure => directory,
    owner  => $username,
    group  => $username,
  } ->
  tftp::file { 'pxelinux.cfg/default':
    content => template('edeploy/tftpserver/default.erb'),
  }

}
