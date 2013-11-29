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

# == Class: edeploy::tftpserver
#
# Install and configure the tftp server for eDeploy
#
# === Parameters
#
# [*address*]
#   Refer to Class['edeploy']
#
# [*serv*]
#   (boolean) Enable access log
#
# [*rserv*]
#   Refer to Class['edeploy']
#
# [*rserv_port*]
#   (boolean) Enable error log
#
# [*hserv*]
#   Refer to Class['edeploy']
#
# [*hserv_port*]
#   Refer to Class['edeploy']
#
# [*onfailure*]
#   Refer to Class['edeploy']
#
# [*onsuccess*]
#   Refer to Class['edeploy']
#
# [*verbose*]
#   Refer to Class['edeploy']
#
# [*upload_log*]
#   Refer to Class['edeploy']
#
# [*http_path*]
#   Refer to Class['edeploy']
#
# [*http_port*]
#   Refer to Class['edeploy']
#
# [*port*]
#   (integer) Port the tftp server will listen on
#
# [*directory*]
#   Refer to Class['edeploy']
#
# [*username*]
#   (string) Username of the tftp process owner
#
# [*options*]
#   (string) List of options
#
# [*inetd*]
#   (boolean) Enable inetd
#
class edeploy::tftpserver (
  $address    = undef,
  $serv       = undef,
  $rserv      = undef,
  $rserv_port = undef,
  $hserv      = undef,
  $hserv_port = undef,
  $onfailure  = undef,
  $onsuccess  = undef,
  $verbose    = undef,
  $upload_log = undef,
  $http_path  = undef,
  $http_port  = undef,
  $port       = $tftp::params::port,
  $directory  = $tftp::params::directory,
  $username   = $tftp::params::username,
  $options    = $tftp::params::options,
  $inetd      = $tftp::params::inetd
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
