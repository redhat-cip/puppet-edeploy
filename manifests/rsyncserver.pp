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
