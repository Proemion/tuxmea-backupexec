# Class backupexec
#
# This class installs and configures a Symantec BackupExec agent on Linux
#
class backupexec (
  $be_server,
  $be_userpw,
  $pkgname = $backupexec::params::pkgname,
  ) inherits backupexec::params {

  group { 'beoper':
    ensure => present,
  }
  user { 'beuser':
    ensure   => present,
    uid      => '305',
    gid      => '0',
    groups   => 'beoper',
    password => $be_userpw,
    require  => Group['beoper']
  }

  package { $pkgname:
    ensure  => latest,
    require => User['beuser'],
  }

  file { '/etc/VRTSralus/ralus.cfg':
    ensure  => file,
    owner   => 'beuser',
    group   => 'beoper',
    mode    => '0644',
    replace => false,
    content => template('backupexec/ralus.cfg.erb'),
    require => Package[$pkgname],
  }

  file { '/etc/init.d/VRTSralus.init':
    ensure  => 'link',
    target  => '/opt/VRTSralus/bin/VRTSralus.init',
    before  => Service['VRTSralus.init'],
    require => Package[$pkgname],
  }

  service { 'VRTSralus.init':
    ensure     => running,
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
    pattern    => '/opt/VRTSralus/bin/beremote',
    require    => Package[$pkgname],
  }

  file { '/opt/VRTSralus/data':
    ensure  => 'directory',
    owner   => 'beuser',
    group   => 'beoper',
    mode    => '0770',
    require => Package[$pkgname],
  }
}
