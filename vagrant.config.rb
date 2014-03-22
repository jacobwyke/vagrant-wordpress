module VagrantConfig		
	#name of the virtual machine (VM)	
	VM_NAME = 'wordpress'
	
	#hostname of the VM
	SERVER_HOSTNAME = 'wordpress.local'
	
  #local port to access the VM's web server
  FORWARD_PORT = '8080'
	
	#amount of memory to assign to the VM
	SERVER_MEM = '256'
	
	#number of CPU's to assign to the VM
	SERVER_CPUS = '1'	
end