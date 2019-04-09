# Class backupexec::params
#
# set distribution specific variables
#
class backupexec::params {
  case $::osfamily {
    'RedHat': {
      $pkgname = 'VRTSralus'
    }
	  'Ubuntu': {
      $pkgname = 'vrtsralus'
    }
	  'Debian': {
      $pkgname = 'vrtsralus'
    }
    default: {
      fail ("Your OS : ${::operatingsystem} is not supported.")
    }
  }
}
