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

The distributed vagrant box likely contains an out of date installation of
Silica. To get the latest code, run `git pull` inside the `silica` directory.
Also, you may need to update dependencies with `pip install -r
requirements.txt` and `pip install -e .`.  If any non Python dependencies such
as coreir have been updated or added since the box was last distributed, you
should consult the installation documentation on how to get the latest
versions.

# Building the vagrant box
This should only be done when changing the Vagrantfile or if you wish to
provision a custom vagrant box from scratch. Most users should use the
pre-built box using the instructions above.
```
vagrant up
vagrant package
```
