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

# == Class: edeploy::webserver
#
# Install and configure the web server for eDeploy
#
# === Parameters
#
# [*docroot*]
#   Refer to Class['edeploy']
#
# [*access_log*]
#   (boolean) Enable access log
#
# [*access_file*]
#   Refer to Class['edeploy']
#
# [*error_log*]
#   (boolean) Enable error log
#
# [*error_file*]
#   Refer to Class['edeploy']
#
# [*port*]
#   Refer to Class['edeploy']
#
# [*address*]
#   Refer to Class['edeploy']
#
class edeploy::webserver (
  $docroot     = undef,
  $access_log  = true,
  $access_file = '/var/log/httpd/edeploy_access_log.log',
  $error_log   = true,
  $error_file  = '/var/log/httpd/edploy_error_log.log',
  $port        = 80,
  $address     = undef
) {


  class {'apache' :
    default_vhost => false,
  }
  apache::vhost {'edeploy.example.com' :
    docroot         => $docroot,
    port            => $port,
    options         => ['Indexes','FollowSymLinks','MultiViews', 'ExecCGI'],
    access_log      => $access_log,
    error_log       => $error_log,
    custom_fragment => 'AddHandler cgi-script .cgi .py',
  }

}
