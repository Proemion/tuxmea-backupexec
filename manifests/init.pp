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
    system   => true,
    gid      => '0',
    groups   => 'beoper',
    password => $be_userpw,
    require  => Group['beoper']
  }

  package { $pkgname:
    ensure  => latest,
    require => User['beuser'],
  }

  file_line { 'backupexec_agent_directory':
    ensure => present,
    path   => '/etc/VRTSralus/ralus.cfg',
    line   => "Software\\Symantec\\Backup Exec For Windows\\Backup Exec\\Engine\\Agents\\Agent Directory List_1=$be_server",
    match  => '^Software\\Symantec\\Backup Exec For Windows\\Backup Exec\\Engine\\Agents\\Agent Directory List_1=.*',
    require => Package[$pkgname],
  }
  file_line { 'backupexec_adverticement_port':
    ensure => present,
    path   => '/etc/VRTSralus/ralus.cfg',
    line   => "Software\\Symantec\\Backup Exec For Windows\\Agent Browser\\TcpIp\\AdvertisementPort=6101",
    match  => '^Software\\Symantec\\Backup Exec For Windows\\Agent Browser\\TcpIp\\AdvertisementPort=',
    require => Package[$pkgname],
  }


  file { '/opt/VRTSralus/bin/VRTSralus.init':
    ensure  => 'file',
    mode    => '0755',
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
