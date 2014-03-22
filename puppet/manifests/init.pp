#Variables
$hostName = 'wordpress.local'
$databaseRootPassword = 'thisismypassword'
$databaseName = 'wordpress'
$databaseUser = 'username'
$databasePassword = 'password'

#DONT EDIT PAST THIS POINT

if ! $::osfamily {
  case $::operatingsystem {
    'RedHat', 'Fedora', 'CentOS', 'Scientific', 'SLC', 'Ascendos', 'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL': {
      $osfamily = 'RedHat'
    }
    'ubuntu', 'debian': {
      $osfamily = 'Debian'
    }
    'SLES', 'SLED', 'OpenSuSE', 'SuSE': {
      $osfamily = 'Suse'
    }
    'Solaris', 'Nexenta': {
      $osfamily = 'Solaris'
    }
    default: {
      $osfamily = $::operatingsystem
    }
  }
}

class repository {	
	#Refresh the list of packages
	exec { 'apt-get-update':
		command => 'apt-get update',
		path    => ['/bin', '/usr/bin'],
	}

	#add the add-apt-repository binary
	package { 'python-software-properties':
		ensure => latest,
		require => [
			Exec['apt-get-update'],
		]
	}
	
	#Adds the PPA for php 5.4
	exec { 'add-ppa':
		path    => '/bin:/usr/bin',
		command => 'add-apt-repository ppa:ondrej/php5-oldstable',
		require => [
			Package['python-software-properties'],
		]
	}
	
	#Refresh the list of packages again
	exec { 'apt-get-update2':
		command => 'apt-get update',
		path    => ['/bin', '/usr/bin'],
		require => [
			Exec['add-ppa'],
		]
	}

	#Update all packages
	exec { 'apt-get-upgrade':
		command => 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade',
		path    => ['/bin', '/usr/bin'],
		timeout	=> 0,
		returns	=> [0,1],
		require => [
			Exec['apt-get-update2'],
		]
	}
}

class system {
	#set the timezone to UTC
	class { 'timezone': timezone => 'UTC', }

	#set /etc/hosts
	host { $hostName:
		ip 	=> '127.0.0.1',
		name 	=> $hostName,
		ensure	=> 'present',
	}
}

class wordpress {
	file { '/vagrant/puppet/files/scripts/installWordpress.sh':
		mode	=> '0755',
	}
	
	exec { 'installWordpress':
		command	=> '/vagrant/puppet/files/scripts/installWordpress.sh',
		path   	=> ['/bin', '/usr/bin', '/usr/sbin'],
		require => [
			Package['apache2'],
			File['/vagrant/puppet/files/scripts/installWordpress.sh']
		]
	}
}

class apache {
	package { 'apache2':
		ensure => latest,
	}
	file { '/etc/apache2/mods-enabled/expires.load':
		ensure => 'link',
		target => '/etc/apache2/mods-available/expires.load',
		notify  => Service['apache2'],
		require => [
			Package['apache2'],
		]
	}
	file { '/etc/apache2/mods-enabled/rewrite.load':
		ensure => 'link',
		target => '/etc/apache2/mods-available/rewrite.load',
		notify  => Service['apache2'],
		require => [
			Package['apache2'],
		]
	}
	service { 'apache2':
		ensure  => running,
		require => [
			Package['apache2'],
		]
	}
}

class mysql-setup {
	class { 'mysql::server':
		config_hash => { 
			'root_password' => $databaseRootPassword,
			bind_address => false, 
		}
	}
	
	#add other users and database if those variables are set
	if($databaseUser){
		database_user { "${databaseUser}@%":
			password_hash => mysql_password($databasePassword),
			require => Class['mysql::server'],
		}
		database_grant { "${databaseUser}@%":
			privileges => ['all'],
			require => [
				Class['mysql::server'],
				Database_user["${databaseUser}@%"],
			],
		}
		database_user { "${databaseUser}@localhost":
			password_hash => mysql_password($databasePassword),
			require => Class['mysql::server'],
		}
		database_grant { "${databaseUser}@localhost":
			privileges => ['all'],
			require => [
				Class['mysql::server'],
				Database_user["${databaseUser}@localhost"],
			],
		}
	}

	if($databaseName){
		database { [
				$databaseName
			]:
			ensure	=> present,
			charset => 'utf8',
			require => Class['mysql::server'],
		}
	}
}

class php {
	package { 'php5':
		ensure => latest,
		notify  => Service['apache2'],
	}
	package { 'php5-mysql':
		ensure 	=> latest,
		require => Package['php5'],
		notify  => Service['apache2'],
	}

	file { '/etc/php5':
		ensure 	=> directory,
		recurse => true,
		force 	=> true,
		source  => '/vagrant/puppet/files/etc/php5',
		group 	=> 'root',
		owner	=> 'root',
		mode	=> '0644',
		require => [
			Package['php5'],
			Package['apache2'],
		],
		notify  => Service['apache2'],
	}
}

stage { 
	pre: before => Stage[main] 
}
 
class { 'repository':
	stage => pre
}

include system
include apache
include wordpress
include mysql-setup
include php