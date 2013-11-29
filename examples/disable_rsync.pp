# Disable rsync
#
# Do not install the rsync package
# Do not enable parameters RSERV and RSERV_PORT
# in the PXE boot
#
class {'edeploy' :
  enable_rsync => false,
}
