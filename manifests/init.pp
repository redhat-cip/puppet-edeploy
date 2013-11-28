# == Class: edeploy
#
# Full description of class edeploy here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { edeploy:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class edeploy (
  $rsync_exports = {},
  $rsync_max_connections = '50',
  $webserver_docroot = '/var/www/edeploy',
  $webserver_port = 80,
  $giturl = 'https://github.com/enovance/edeploy.git',
  $installdir = '/var/lib',
  $healthdir = '/var/lib/edeploy/health/',
  $configdir = '/var/lib/edeploy/config/',
  $logdir = '/var/lib/edeploy/config/logs',
  $hwdir = '/var/lib/edeploy/hw/',
  $lockfile = '/tmp/edeploy.lock',
  $userpxemngr = false,
  $tftproot = '/var/lib/tftpboot',
  $serv = $::ipaddress,
  $rserv = undef,
  $rserv_port = undef,
  $hserv = undef,
  $hserv_port = undef,
  $onfailure = undef,
  $onsuccess = undef,
  $verbose = undef,
  $upload_log = undef,
  $http_path = undef, 
  $http_port = undef
) {

  include edeploy::params
  include stdlib


  # TODO (spredzy) : Move all the code below to a edeploy::prequisite class
  include devtools

  package {$edeploy::params::packages :
    ensure => installed,
  }

  # NOTE (spredzy) : Wheezy profile is missing in RHEL 6.4 debootstrap package
  #                  It's being create here. A request upstream might be done.
  if $::osfamily == 'RedHat' {
    file {'/usr/share/debootstrap/scripts/wheezy' :
      ensure => 'link',
      target => '/usr/share/debootstrap/scripts/sid',
    }
  }

  class {'edeploy::tftpserver' :
    address    => $::ipaddress,
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
  }

  class {'edeploy::rsyncserver' :
    exports         => $rsync_exports,
    max_connections => $rsync_max_connections,
    address         => $::ipaddress,
  }

  class {'edeploy::webserver' :
    docroot => $webserver_docroot,
    port    => $webserver_port,
  }

  # TODO (spredzy) : Move all the code below to edeploy::installation class
  
  exec { "git clone ${giturl} ${installdir}/edeploy" :
    unless => "ls ${installdir}/edeploy",
    path   => ['/usr/bin', '/bin'],
  } 
  exec { "git pull origin" :
    onlyif  => "ls ${installdir}/edeploy",
    path    => ['/usr/bin', '/bin'],
    cwd     => "${installdir}/edeploy",
    require => Exec["git clone ${giturl} ${installdir}/edeploy"],
  } 
 
  # NOTE (spredzy) : Not idempotent, will be move copied everyrun atm.
  #                  Might want to check if content is !=
  exec { "cp ${installdir}/edeploy/server/*.py ${webserver_docroot}/" :
    path    => '/bin',
    require => Exec['git pull origin'],
  }

  # TODO (spredzy) : Move all the code below to edeploy::configuration class
  file {'/etc/edeploy.conf' :
    ensure  => file,
    content => template('edeploy/etc/edeploy.conf.erb'),
  }

}
