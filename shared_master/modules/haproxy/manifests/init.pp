class haproxy {
	Exec {
		path => ["/usr/bin", "/bin", "/usr/sbin"]
	}

	exec { 'install build-essential' :
		command => 'sudo apt-get install -y build-essential',
	}

	exec { 'install libssl' :
                command => 'sudo apt-get install -y libssl-dev',
        }

	exec { 'install libpcre' :
                command => 'sudo apt-get install -y libpcre++-dev',
        }

	exec { 'create user' :
		command => 'sudo useradd haproxy',
	}

	exec { 'copy haproxy' :
		cwd => '/tmp/shared',
		command => 'sudo cp /tmp/shared/haproxy-1.7.1.tar.gz /opt',
	}

	exec { 'extract haproxy' :
                cwd => '/opt',
                command => 'sudo zxvf haproxy-1.7.1.tar.gz',
		require => Exec['extract haproxy'],
        }

	exec { 'compile haproxy' :
		cwd => '/opt/haproxy-1.7.1',
		command => 'sudo make TARGET=linux2628 CPU=native USE_STATIC_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1',
		require => Exec['extract haproxy'],
	}

	exec { 'install haproxy' :
		cwd => '/opt/haproxy-1.7.1',
		command => 'sudo make install',
		require => Exec['compile haproxy'],
	}

	file { '/etc/init.d/haproxy' :
		ensure => present,
		source => 'puppet:///modules/haproxy/haproxy',
		require => Exec['install haproxy'],
	}

	exec { 'make directory' :
		command => 'sudo mkdir /etc/haproxy',
	}

	file { '/etc/haproxy/haproxy.cfg' :
                ensure => present,
                source => 'puppet:///modules/haproxy/haproxy.cfg',
                require => Exec['make directory'],
        }
}
