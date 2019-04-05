# Class backupexec
#
# This class installs and configures a Symantec BackupExec agent on Linux
#
class backupexec {

  group { 'beoper':
    ensure => present,
  }
  user { 'beuser':
    ensure  => present,
    gid     => '0',
    groups  => 'beoper',
    require => Group['beoper']
  }

  package { 'vrtsralus':
    ensure  => latest,
    require => [ User['beuser'], Apt::Source['rm-apt-repo'] ],
  }

  file { '/etc/VRTSralus/ralus.cfg':
    ensure  => file,
    owner   => 'beuser',
    group   => 'beoper',
    mode    => '0644',
    content => template('backupexec/ralus.cfg.erb'),
    require => Package['vrtsralus'],
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
    require    => Package['vrtsralus'],
  }

  file { '/opt/VRTSralus/data':
    ensure  => 'directory',
    owner   => 'beuser',
    group   => 'beoper',
    mode    => '0770',
    require => Package['vrtsralus'],
  }
}
