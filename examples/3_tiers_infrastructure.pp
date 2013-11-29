# 3 tiers eDeploy infrastructure
#
# - An eDeploy server (192.168.122.4)
# - An OS store server (192.168.122.3)
# - An eDeploy client
#
class {'edeploy' :
  rserv             => '192.168.122.3',
  rserv_port        => 873,
  hserv             => '192.168.122.3',
  hserv_port        => 80,
  serv              => '192.168.122.4',
  http_port         => 80,
  http_path         => '/',
  webserver_docroot => '/var/www/edeploy',
  state             => {'hp' => '4', 'vm-debian' => '*', 'dell-storage' => '8', 'dell-compute' => '0'}
}
