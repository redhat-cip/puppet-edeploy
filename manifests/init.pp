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

  include stdlib

  class {'edeploy::prerequisites' :
    address               => $::ipaddress,
    tftproot              => $tftproot,
    serv                  => $serv,
    rserv                 => $rserv,
    rserv_port            => $rserv_port,
    hserv                 => $hserv,
    hserv_port            => $hserv_port,
    onfailure             => $onfailure,
    onsuccess             => $onsuccess,
    verbose               => $verbose,
    upload_log            => $upload_log,
    http_path             => $http_path, 
    http_port             => $http_port,
    rsync_exports         => $rsync_exports,
    rsync_max_connections => $rsync_max_connections,
    webserver_docroot     => $webserver_docroot,
    webserver_port        => $webserver_port,
  }
  class {'edeploy::installation' :
    giturl            => $giturl,
    installdir        => $installdir,
    webserver_docroot => $webserver_docroot,
    require           => Class['edeploy::prerequisites'],
  }
  class {'edeploy::configuration' :
    healthdir   => $healthdir,
    configdir   => $configdir,
    logdir      => $logdir,
    hwdir       => $hwdir,
    lockfile    => $lockfile,
    userpxemngr => $userpxemngr,
    require     => Class['edeploy::installation'],
  }

}
