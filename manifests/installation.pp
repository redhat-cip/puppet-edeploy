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
  $giturl            = undef,
  $installdir        = undef,
  $webserver_docroot = undef,
) {

  exec { "git clone ${giturl} ${installdir}/edeploy" :
    unless => "ls ${installdir}/edeploy",
    path   => ['/usr/bin', '/bin'],
  }
  exec { 'git pull origin' :
    onlyif  => "ls ${installdir}/edeploy",
    path    => ['/usr/bin', '/bin'],
    cwd     => "${installdir}/edeploy",
    require => Exec["git clone ${giturl} ${installdir}/edeploy"],
  }

  # NOTE (spredzy) : Not idempotent, will be move copied everyrun atm.
  #                  Might want to check if content is !=
  exec { "cp ${installdir}/edeploy/server/*.py ${webserver_docroot}/" :
    path    => '/bin',
    require => [Exec['git pull origin'], Apache::Vhost['edeploy.example.com']],
  }

}
