class edeploy::configuration (
  $healthdir,
  $configdir,
  $logdir,
  $hwdir,
  $lockfile,
  $userpxemngr
) {

  file {'/etc/edeploy.conf' :
    ensure  => file,
    content => template('edeploy/etc/edeploy.conf.erb'),
  }

}
