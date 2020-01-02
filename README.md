# borgtools
Simplified interface to borg backup

Intended for use where borg is used to backup the entire system. The repo path and passphrase is saved in a separate file, which for example allows a simple "borgtools list"

NOTE! Git does not save file permissions (other than execution rights), so it's up to the user to set permissions of the BORGPARAM file to avoid any user being able to read the passphrase.
