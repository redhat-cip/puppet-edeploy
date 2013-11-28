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
  $healthdir,
  $configdir,
  $logdir,
  $hwdir,
  $lockfile,
  $usepxemngr,
  $state
) {

  file {'/etc/edeploy.conf' :
    ensure  => file,
    content => template('edeploy/etc/edeploy.conf.erb'),
  }

  file {"${configdir}/state" :
    ensure  => file,
    content => template('edeploy/state.erb'),
  }

}
