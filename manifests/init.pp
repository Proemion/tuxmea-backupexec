# Class backupexec
#
# This class installs and configures a Symantec BackupExec agent on Linux
#
class backupexec {
    include backupexec::params
    include backupexec::install
    include backupexec::config
    include backupexec::service
    Class['backupexec::params'] ->
      Class['backupexec::install'] ->
      Class['backupexec::config'] ->
      Class['backupexec::service']
}