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

# == Class: edeploy::params
#
# eDeploy parameters
#
class edeploy::params {

  $rsync_enable   = true
  $http_enable    = true
  $tftp_enable    = true
  $pxemngr_enable = false
  $state          = {}

  $giturl         = 'https://github.com/enovance/edeploy.git'
  $installdir     = '/var/lib'

  $rsync_exports  = {
    'install' => {
      'path'    => "${edeploy::params::installdir}/install/",
      'comment' => 'The install path',
    },
    'metadata' => {
      'path'    => "${edeploy::params::installdir}/metadata/",
      'comment' => 'The metadata path',
    },
  }

  $edeploy_conf = {
    'healthdir'   => "${edeploy::params::installdir}/edeploy/health",
    'configdir'   => "${edeploy::params::installdir}/edeploy/config",
    'logdir'      => "${edeploy::params::installdir}/edeploy/config/logs",
    'hwdir'       => "${edeploy::params::installdir}/edeploy/hw",
    'lockfile'    => '/tmp/edeploy.lock',
    'usepxemngr'  => $edeploy::params::pxemngr_enable,
    'pxemngrurl'  => 'http://192.168.122.1:8000/',
    'metadataurl' => 'http://192.168.122.1/',
  }

  $boot_conf      = {
    'serv'       => $::ipaddress,
    'rserv'      => $::ipaddress,
    'rserv_port' => 873,
    'hserv'      => $::ipaddress,
    'hserv_port' => 80,
    'onfailure'  => 'console',
    'onsucess'   => 'kexec',
    'verbose'    => 0,
    'upload_log' => 1,
    'http_path'  => '/install',
    'http_port'  => 80,
  }

  $vhost_pyscripts_configuration = {
    'edeploy.test.enovance.com' => {
      'docroot'         => '/var/www/edeploy',
      'port'            => 80,
      'options'         => ['Indexes', 'FollowSymlinks', 'MultiViews', 'ExecCGI'],
      'custom_fragment' => 'AddHandler cgi-script .cgi .py',
    }
  }

  $vhost_install_configuration = {
    'install.edeploy.test.enovance.com' => {
      'docroot' => '/var/lib/deboostrap',
      'port'    => 80,
      'options' => ['Indexes', 'FollowSymLinks', 'Multiviews'],
    }
  }

  case $::osfamily {
    'RedHat': {
      $packages = ['python-mock', 'python-netaddr', 'python-ipaddr', 'pigz', 'debootstrap', 'qemu-kvm', 'git', 'ansible']
    }
    'Debian': {
      $packages = ['python-mock', 'python-netaddr', 'python-ipaddr', 'pigz', 'debootstrap', 'qemu-kvm', 'yum', 'qemu-utils', 'alien', 'python-openstack.nose-plugin', 'git', 'ansible']
    }
    default: {
      fail("Unsupported OS : ${::osfamily}")
    }
  }

}
