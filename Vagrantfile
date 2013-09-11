# -*- mode: ruby -*-
# vi: set ft=ruby :
require './vagrant.config.rb'
include VagrantConfig

Vagrant.configure("2") do |config|
	#machine type
	config.vm.box = "precise64"
	config.vm.box_url = "http://files.vagrantup.com/precise64.box"
	
	#Port forward - uncomment if you want to forward http from the VM to your localhost - means you can access the wordpres site via http://localhost/
	#config.vm.network :forwarded_port, guest: 80, host: 80, auto_correct: true
	
	#hostname
	config.vm.hostname = SERVER_HOSTNAME
	
	#network location
	config.vm.network :public_network, ip: SERVER_PUBLIC_IP_ADDRESS
	config.vm.network :private_network, ip: SERVER_PRIVATE_IP_ADDRESS
	
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