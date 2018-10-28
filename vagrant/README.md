# Using the vagrant box
* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Install [Vagrant](https://www.vagrantup.com/downloads.html)

## macOS (homebrew)
```
$ brew install virtualbox vagrant
```

In a terminal (Windows users can use powershell)
```
$ vagrant init --minimal lennyt/silica --box-version 0.0.1
$ vagrant up
$ vagrant ssh
vagrant@vagrant-ubuntu-trusty-64:~$ cd silica
vagrant@vagrant-ubuntu-trusty-64:~/silica$ pytest
```

# Building the vagrant box
This should only be done when changing the Vagrantfile or if you wish to
provision a custom vagrant box from scratch. Most users should use the
pre-built box using the instructions above.
```
vagrant up
vagrant package
```
