#
# Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
#
# Author: Yanis Guenane <yanis.guenane@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# == Class: edeploy
#
# eDeploy base class. This class does the installation of prerequistes,
# the installation of eDeploy itself and its configuration
#
# === Parameters
#
# [*rsync_exports*]
#   (dictionnary) The set of rsync export
#
# [*rsync_max_connections*]
#   (integer) Number of max connections per export
#
# [*enable_rsync*]
#   (boolean) Enable the rsync server
#
# [*webserver_docroot*]
#   (string) Path to store eDeploy python script HTTP accessible (upload.py)
#
# [*webserver_port*]
#   (integer) HTTP Port to reach eDeploy python script (upload.py)
#
# [*enable_http_install*]
#   (boolean) Enable HTTP installation process
#
# [*http_install_docroot*]
#   (string) Path to OS archives (.edeploy) 
#
# [*http_install_port*]
#   (integer) HTTP Port to access OS archives (.edeploy)
#
# [*giturl*]
#   (string) GIT url where the eDeploy project should be retrieved from
#
# [*installdir*]
#   (string) Path where eDeploy will be installed
#
# [*healthdir*]
#   (string) Path for eDeploy health related files
#
# [*configdir*]
#   (string) Path for eDeploy configuration related files
#
# [*logdir*]
#   (string) Path for eDeploy log files
#
# [*hwdir*]
#   (string) Path for eDeploy harware report file
#
# [*lockfile*]
#   (string) Path for eDeplou lock file
#
# [*usepxemngr*]
#   (boolean) Enable pxemngr
#
# [*enable_tftp*]
#   (boolean) Enable tftp server
#
# [*tftproot*]
#   (string) Path for tftp root
#
# [*serv*]
#   (string) IP of the eDeploy server
#
# [*rserv*]
#   (string) IP of the rsync eDeploy server
#
# [*rserv_port*]
#   (integer) Port on which the rsync eDeploy server is listening
#
# [*hserv*]
#   (string) IP of the HTTP eDeploy server
#
# [*hserv_port*]
#   (integer) Port on which the HTTP eDeploy server is listening
#
# [*onfailure*]
#   (string) Action to take on failure
#
# [*onsuccess*]
#   (string) Action to take on success
#
# [*verbose*]
#   (boolean) Enable verbose mode
#
# [*upload_log*]
#   (boolean) Enable log upload
#
# [*http_path*]
#   (string) URL Path for upload.py
#
# [*htpp_port*]
#   (integer) Port on which to query upload.py
#
# [*state*]
#   (hash) State file tuple
#
class edeploy (
  $rsync_exports         = {},
  $rsync_max_connections = '50',
  $enable_rsync          = true,
  $webserver_docroot     = '/var/www/edeploy',
  $webserver_port        = 80,
  $enable_http_install   = true,
  $http_install_docroot  = '/var/lib/debootstrap',
  $http_install_port     = 80,
  $giturl                = 'https://github.com/enovance/edeploy.git',
  $installdir            = '/var/lib',
  $healthdir             = '/var/lib/edeploy/health/',
  $configdir             = '/var/lib/edeploy/config/',
  $logdir                = '/var/lib/edeploy/config/logs',
  $hwdir                 = '/var/lib/edeploy/hw/',
  $lockfile              = '/tmp/edeploy.lock',
  $usepxemngr            = false,
  $enable_tftp           = true,
  $tftproot              = '/var/lib/tftpboot',
  $serv                  = $::ipaddress,
  $rserv                 = $::ipaddress,
  $rserv_port            = 873,
  $hserv                 = $::ipaddress,
  $hserv_port            = 80,
  $onfailure             = 'console',
  $onsuccess             = 'kexec',
  $verbose               = 0,
  $upload_log            = 1,
  $http_path             = '/edeploy',
  $http_port             = 80,
  $state                 = {},
) {

  include stdlib

  validate_bool($enable_rsync)
  validate_bool($enable_tftp)
  validate_bool($enable_http_install)
  validate_bool($usepxemngr)
  validate_hash($rsync_exports)
  validate_hash($state)
  validate_absolute_path($webserver_docroot)
  validate_absolute_path($http_install_docroot)
  validate_absolute_path($installdir)
  validate_absolute_path($healthdir)
  validate_absolute_path($configdir)
  validate_absolute_path($logdir)
  validate_absolute_path($hwdir)
  validate_absolute_path($lockfile)
  validate_absolute_path($tftproot)
  validate_absolute_path($http_path)
  validate_string($onfailure)
  validate_string($onsuccess)
  validate_string($giturl)

  class {'edeploy::prerequisites' :
    address               => $serv,
    enable_tftp           => $enable_tftp,
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
    enable_rsync          => $enable_rsync,
    webserver_docroot     => $webserver_docroot,
    webserver_port        => $webserver_port,
    enable_http_install   => $enable_http_install,
    http_install_docroot  => $http_install_docroot,
    http_install_port     => $http_install_port,
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
    usepxemngr  => $usepxemngr,
    state       => $state,
    require     => Class['edeploy::installation'],
  }

}
