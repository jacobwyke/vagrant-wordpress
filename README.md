Vagrant WordPress
================

[Vagrant](http://www.vagrantup.com/) VM for an Ubuntu Precise (12.04) box running the latest [WordPress](http://wordpress.org/) version.

This will launch a virtual machine running the latest release of WordPress on PHP 5.4.

Tested with Vagrant 1.3.1.

#Config#
There are some config options available in '[vagrant.config.rb](https://github.com/jacobwyke/vagrant-wordpress/blob/master/vagrant.config.rb)' which allow you to easily change the IP address the VM uses.

All config variables are exaplained in '[vagrant.config.rb](https://github.com/jacobwyke/vagrant-wordpress/blob/master/vagrant.config.rb)'.

There are some additional variables you can change in the '[/puppet/manifests/init.pp](https://github.com/jacobwyke/vagrant-wordpress/blob/master/puppet/manifests/init.pp)' file to change the database username/password that are created.

By default a root mysql user will be setup with the password 'thisismypassword' and a database called 'wordpress' will be created with a username 'username' and default password of 'password'.

#Installation#
Run:

	vagrant up

Go to: [http://10.0.1.60](http://10.0.1.60)

Click to 'Create a Configuration File'.

All the default values for the database are correct unless you have changed them in '[/puppet/manifests/init.pp](https://github.com/jacobwyke/vagrant-wordpress/blob/master/puppet/manifests/init.pp)'.

Database Name: 	wordpress

User Name:	username

Password:	password

Database Host:	localhost

Table Prefix:	wp_

Click 'Submit' and then 'Run the install'. Add the site information and install WordPress.

You will now have a version of the latest WordPress up and running at [http://10.0.1.60](http://10.0.1.60).

#Troubleshooting#

Virtual machine defaults to 10.0.1.60.

If you get a server 500 message when attempting to view graphite try to provision the VM again with:

	vagrant provision
