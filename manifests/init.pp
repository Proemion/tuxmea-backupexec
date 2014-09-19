# Class backupexec
#
# This class installs and configures a Symantec BackupExec agent on Linux
#
class backupexec (
) inherits backupexec::params {
  group { 'beoper':
    ensure => present,
  }
  user { 'beuser':
    ensure  => present,
    gid     => '0',
    groups  => 'beoper',
    require => Group['beoper']
  }

  package { $backupexec::params::pkgname:
    ensure  => present,
    require => User['beuser'],
  }

  file { '/etc/VRTSralus/ralus.cfg':
    ensure  => file,
    owner   => 'beuser',
    group   => 'beoper',
    mode    => '0644',
    content => template('backupexec/ralus.cfg.erb'),
    require => Package[$backupexec::params::pkgname],
  }

  file { '/etc/init.d/VRTSralus.init':
    ensure => 'link',
    target => '/opt/VRTSralus/bin/VRTSralus.init',
    before => Service['VRTSralus.init'],
  }

  service { 'VRTSralus.init':
    ensure     => running,
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
    pattern    => '/opt/VRTSralus/bin/beremote',
    require    => Package[$backupexec::params::pkgname],
  }

  file { '/opt/VRTSralus/data':
    ensure  => 'directory',
    owner   => 'beuser',
    group   => 'beoper',
    mode    => '0770',
    require => Package[$backupexec::params::pkgname],
  }
}
