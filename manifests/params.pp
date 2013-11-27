# == Class: edeploy::params
#
# eDeploy parameters
#
class edeploy::params {


  case $::osfamily {
    'RedHat': {
      $packages = ['python-mock', 'python-netaddr', 'python-ipaddr', 'pigz', 'debootstrap', 'qemu-kvm']
    }
    'Debian': {
      $packages = ['python-mock', 'python-netaddr', 'python-ipaddr', 'pigz', 'debootstrap', 'qemu-kvm', 'yum', 'qemu-utils', 'alien', 'python-openstack.nose-plugin']
    }
    default: {
      fail("Unsupported OS : $::osfamily")
    }
  }

}
