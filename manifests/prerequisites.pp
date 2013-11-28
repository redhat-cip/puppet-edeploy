class edeploy::prerequisites (
    $address,
    $tftproot,
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
    $rsync_exports,
    $rsync_max_connections,
    $webserver_docroot,
    $webserver_port
) {

  require devtools
  include edeploy::params

  package {$edeploy::params::packages :
    ensure => installed,
  }
  # NOTE (spredzy) : Wheezy profile is missing in RHEL 6.4 debootstrap package
  #                  It's being create here. A request upstream might be done.
  if $::osfamily == 'RedHat' {
    file {'/usr/share/debootstrap/scripts/wheezy' :
      ensure  => 'link',
      target  => '/usr/share/debootstrap/scripts/sid',
      require => Package[$edeploy::params::packages],
    }
  }

  class {'edeploy::tftpserver' :
    address    => $address,
    directory  => $tftproot,
    serv       => $serv,
    rserv      => $rserv,
    rserv_port => $rserv_port,
    hserv      => $hserv,
    hserv_port => $hserv_port,
    onfailure  => $onfailure,
    onsuccess  => $onsuccess,
    verbose    => $verbose,
    upload_log => $upload_log,
    http_path  => $http_path, 
    http_port  => $http_port,
    require    => Package[$edeploy::params::packages],
  }
  class {'edeploy::rsyncserver' :
    exports         => $rsync_exports,
    max_connections => $rsync_max_connections,
    address         => $address,
    require         => Class['edeploy::tftpserver'],
  } ->
  class {'edeploy::webserver' :
    docroot => $webserver_docroot,
    port    => $webserver_port,
    require => Class['edeploy::rsyncserver'],
  }

}
