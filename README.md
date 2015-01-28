**Author: Francesco Schirinzi**

**Email: fschirinzi25@gmail.com**

**Date: 27.10.2014**

**Please feel free to contribute to this project ;)**

This script is for backupping folders, files and MySQL databases.

## Requirements
#### Local
* privat ssh-key
* read and exute privileges on script and conf dir for the user wich runs the cronjob
* read and write privileges on local backup folder for the user wich runs the cronjob

#### Remote
* read privileges for the files that have to be backupped
* the public ssh-key of the privat ssh-key
 

## Installation
#### File structure
Path | permissions
--- | ---
./scripts | rwx
./scripts/bkp_script.sh | rwx
./scripts/del_script.sh | rwx
./scripts/config/ | rw
./scripts/config/srv1.conf | rw
./scripts/config/srv2.conf | rw
./scripts/config/... | rw

