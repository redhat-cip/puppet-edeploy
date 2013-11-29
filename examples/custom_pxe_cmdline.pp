# Custom PXE boot command line
#
# Specify the beavior of installation
#
class {'edeploy' :
  verbose    => 1,
  onsuccess  => 'kexec',
  onfailure  => 'console'
  upload_log => 1,
}
