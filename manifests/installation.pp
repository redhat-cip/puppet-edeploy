class edeploy::installation (
  $giturl,
  $installdir,
  $webserver_docroot,
) {

  exec { "git clone ${giturl} ${installdir}/edeploy" :
    unless => "ls ${installdir}/edeploy",
    path   => ['/usr/bin', '/bin'],
  } 
  exec { "git pull origin" :
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
