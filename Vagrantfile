# -*- mode: ruby -*-
# vi: set ft=ruby :
require './vagrant.config.rb'
include VagrantConfig

Vagrant.configure("2") do |config|
	#machine type
	config.vm.box = "precise64"
	config.vm.box_url = "http://files.vagrantup.com/precise64.box"
	
	#port forward the VM's web server port to a local port set in the config file (default is 8080)
	config.vm.network :forwarded_port, guest: 80, host: FORWARD_PORT, auto_correct: true
	
	#hostname
	config.vm.hostname = SERVER_HOSTNAME
	
	#set machine resources
	config.vm.provider :virtualbox do |v|
		v.customize [
			"modifyvm", :id,
			"--memory", SERVER_MEM,
			"--name", VM_NAME,
			"--cpus", SERVER_CPUS
		]
	end
	
	#use puppet to provsion the machine
	config.vm.provision :puppet do |puppet|
		puppet.manifests_path = "puppet/manifests"
		puppet.manifest_file  = "init.pp"
		puppet.module_path = "puppet/modules"
		#puppet.options = "--verbose --debug"
	end
end