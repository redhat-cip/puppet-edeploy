puppet-edeploy (Work in progress)
=================================
 
The puppet edeploy module sets the ground for a user to use edeploy. It installs all the prerequisites (rsync server, http server, tftp server), it installs eDeploy itself and configure it. *What it does not* is to compile any specific role. This duty is left for the eDeploy administrator.
 
Installation
------------
 
eDeploy puppet module comes with sane defaults for each value, but if needed eDeploy instalation can be fully customized
 
```
    class {'edeploy' :
      rsync_exports     => {'install' => {'path' => '/var/lib/debootstrap/install', 'comment' => 'The Install Path'},
                            'metadata' => {'path' => '/var/lib/debootstrap/metadata', 'comment' => 'The Metadata Path'},},
      onfailure         => 'console',
      rserv_port        => 873,
      http_port         => 80,
      http_path         => '/',
      upload_log        => 1,
      onsuccess         => 'kexec',
      webserver_docroot => '/var/www/edeploy',
      steate            => {'vm-centos' => '*', 'hp' => '4'},
    }
```
 
