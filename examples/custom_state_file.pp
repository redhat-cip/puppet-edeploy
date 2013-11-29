# Custom state file
#
# Specifying a custom state file
#
class {'edeploy' :
  state => {'hp' => '4', 'vm-debian' => '*', 'dell-storage' => '8', 'dell-compute' => '0'}
}
