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

# == Class: edeploy::installation
#
# Role class to process the installation of eDeploy
#
# === Parameters
#
# [*giturl*]
#   Refer to Class['edeploy']
#
# [*installdir*]
#   (boolean) Enable access log
#
# [*webserver_docroot*]
#   Refer to Class['edeploy']
#
class edeploy::installation (
  $rsync_enable      = $edeploy::rsync_enable,
  $http_enable       = $edeploy::http_enable,
  $tftp_enable       = $edeploy::tftp_enable,
  $required_packages = $edeploy::required_packages,
  $giturl            = $edeploy::giturl,
  $installdir        = $edeploy::installdir,
) {

  package { $required_packages :
    ensure => present,
  }

  if $rsync_enable {
    include ::rsync::server
  }

  if $http_enable {
    include ::apache
  }

  if $tftp_enable {
    include ::tftp
  }

  vcsrepo { "${installdir}/edeploy" :
    ensure   => present,
    provider => git,
    source   => $giturl,
  }

}
