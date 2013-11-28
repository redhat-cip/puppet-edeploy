class edeploy::tftpserver (
  $address,
  $serv,
  $rserv,
  $rserv_port,
  $hserv,
  $hserv_port,
  $onfailure,
  $onsuccess,
  $verbose,
  $upload_log,
  $http_path,
  $http_port,
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
