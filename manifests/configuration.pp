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

# == Class: edeploy::configuration
#
# Role class to process the configuration of eDeploy
#
# === Parameters
#
# [*healthdir*]
#   Refer to Class['edeploy']
#
# [*configdir*]
#   (boolean) Enable access log
#
# [*logdir*]
#   Refer to Class['edeploy']
#
# [*hwdir*]
#   (boolean) Enable error log
#
# [*lockfile*]
#   Refer to Class['edeploy']
#
# [*usepxemanager*]
#   Refer to Class['edeploy']
#
# [*state*]
#   Refer to Class['edeploy']
#
class edeploy::configuration (
  $pxemngr_enable                = $edeploy::pxemngr_enable,
  $rsync_enable                  = $edeploy::rsync_enable,
  $http_enable                   = $edeploy::http_enable,
  $edeploy_conf                  = $edeploy::edeploy_conf,
  $boot_conf                     = $edeploy::boot_conf,
  $state                         = $edeploy::state,
  $installdir                    = $edeploy::installdir,
  $rsync_exports                 = $edeploy::rsync_exports,
  $vhost_pyscripts_configuration = $edeploy::vhost_pyscripts_configuration,
  $vhost_install_configuration   = $edeploy::vhost_install_configuration,
) {

  $managed_hosts = [keys($vhost_pyscripts_configuration), keys($vhost_install_configuration)]
  host {$managed_hosts :
    ip => '127.0.0.1',
  }

  file {'/etc/edeploy.conf' :
    ensure  => file,
    content => template('edeploy/etc/edeploy.conf.erb'),
  }

  file {"${edeploy_conf['configdir']}/state" :
    ensure  => file,
    content => template('edeploy/state.erb'),
  }

  if $rsync_enable {
    # Configure the rsync shares
    create_resources('rsync::server::module', $rsync_exports)
  }

  # Configure the vhost to enable the .py scripts
  create_resources('apache::vhost', $vhost_pyscripts_configuration)

  if $http_enable {
    # Configure the vhost to distribute the .edploy file
    create_resources('apache::vhost', $vhost_install_configuration)
  }

  # Configure tftp with proper pxelinux.0 and conf
  if $rsync_enable {
    file { [$::tftp::params::directory, "${::tftp::params::directory}/pxelinux.cfg"] :
      ensure => directory,
      owner  => $::tftp::params::username,
      group  => $::tftp::params::username,
      } ->
      tftp::file { 'pxelinux.0':
        source => 'puppet:///modules/edeploy/tftpserver/pxelinux.0',
        } ->
        tftp::file { 'pxelinux.cfg/default':
          content => template('edeploy/tftpserver/default.erb'),
        }
  }

  # NOTE (spredzy) : Not idempotent, will be move copied everyrun atm.
  #                  Might want to check if content is !=
  file {$vhost_pyscripts_configuration[join(keys($vhost_pyscripts_configuration))]['docroot'] :
    ensure => link,
    target => "${installdir}/edeploy/server/",
  }

}
