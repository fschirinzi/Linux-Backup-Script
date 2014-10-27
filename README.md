**Author: Francesco Schirinzi**

**Email: fschirinzi25@gmail.com**

**Date: 27.10.2014**

This Script is for backupping folders, files and MYSQL databases.

## Requirements
### Local
* privat ssh-key
* read and exute privileges on script and conf dir for the user wich runs the cronjob
* read and write privileges on local backup folder for the user wich runs the cronjob

## Remote
* read privileges for the files that have to be backupped
* the public ssh-key of the privat ssh-key
 

## Tested environment
Name | Description
------------ | -------------
OS | Ubuntu 12.04
User | test
