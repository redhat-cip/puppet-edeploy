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
  $rsync_enable                  = $edeploy::params::rsync_enable,
  $http_enable                   = $edeploy::params::http_enable,
  $tftp_enable                   = $edeploy::params::tftp_enable,
  $pxemngr_enable                = $edeploy::params::pxemngr_enable,
  $giturl                        = $edeploy::params::giturl,
  $installdir                    = $edeploy::params::installdir,
  $rsync_exports                 = $edeploy::params::rsync_exports,
  $required_packages             = $edeploy::params::packages,
  $edeploy_conf                  = $edeploy::params::edeploy_conf,
  $boot_conf                     = $edeploy::params::boot_conf,
  $state                         = $edeploy::params::state,
  $vhost_pyscripts_configuration = $edeploy::params::vhost_pyscripts_configuration,
  $vhost_install_configuration   = $edeploy::params::vhost_install_configuration,
) inherits edeploy::params {

  include stdlib
  include epel

  validate_bool($rsync_enable)
  validate_bool($tftp_enable)
  validate_bool($http_enable)
  validate_bool($pxemngr_enable)

  validate_absolute_path($installdir)

  validate_array($required_packages)

  validate_hash($state)
  validate_hash($rsync_exports)
  validate_hash($edeploy_conf)
  validate_hash($boot_conf)
  validate_hash($vhost_pyscripts_configuration)
  validate_hash($vhost_install_configuration)

  class {'edeploy::installation' : } ->
    class {'edeploy::configuration' : }

}
