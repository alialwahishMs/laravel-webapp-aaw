#!/bin/bash 

ssh-keygen -A
mkdir -p /run/sshd
/usr/sbin/sshd
php artisan serve --host=0.0.0.0 --port=80