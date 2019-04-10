tuxmea-backupexec
=================

Puppet module for Symantec BackupExec agent. Should work on RedHat and Debian based systems. 
Currently vrtsralus v20.0.1188.1863 is used.

Requirements:
 1. ``` vrtsralus ``` installable via repository or manuall installed (not available in a public repository)
 2. defined variables in ~/hieradata/common.yaml (```backupexec::be_server``` and ```backupexec::be_userpw```)
 
 #### What does the modul do? 
 
 1. Create a local group ```beoper```
 2. Create a local user ```beuser```
 3. Ensure that the package ```vrtsralus``` is installed in the latest version, if not it will install it (Assuming you have a repository from where it can be installed)
 4. Define the Backupexec Server and Port in the config file
 5. Checks that needed files are present and have the correct user rights
 
 
