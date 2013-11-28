# == Class: edeploy
#
# Full description of class edeploy here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { edeploy:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class edeploy (
  $rsync_exports = {},
  $rsync_max_connections = '50',
  $webserver_docroot = '/var/www/edeploy',
  $webserver_port = 80
) {

  include edeploy::params
  include stdlib


  # TODO (spredzy) : Move all the code below to a edeploy::prequisite class
  if $::osfamily == 'RedHat' {
    require epel
  }

  package {$edeploy::params::packages :
    ensure => installed,
  }

  class {'edeploy::tftpserver' :
    address => $::ipaddress,
  }

  class {'edeploy::rsyncserver' :
    exports         => $rsync_exports,
    max_connections => $rsync_max_connections,
    address         => $::ipaddress,
  }

  class {'edeploy::webserver' :
    docroot => $webserver_docroot,
    port    => $webserver_port,
  }


}
