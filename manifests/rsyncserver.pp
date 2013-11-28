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

# == Class: edeploy::rsyncserver
#
# Install and configure the rsync server for eDeploy
#
# === Parameters
#
# [*exports*]
#   Refer to Class['edeploy']
#
# [*max_connections*]
#   (boolean) Enable access log
#
# [*address*]
#   Refer to Class['edeploy']
#
# [*use_xinetd*]
#   (boolean) Use xinted for rysnc service
#
# [*motd_file*]
#   (string) Path to motd file
#
# [*use_chroot*]
#   (string) Enable the use of chroot
#
class edeploy::rsyncserver (
  $exports,
  $max_connections,
  $address,
  $use_xinetd = true,
  $motd_file = 'UNSET',
  $use_chroot = 'yes'
) {

  class {'rsync::server':
    address => $address,
  }

  $defaults = {
    'max_connections' => $max_connections,
  }

  create_resources(rsync::server::module, $exports, $defaults)
}
