#parameterised for future change/updates
class snort($snort_archive	= 'snort-2.9.9.0.tar.gz',
			$snort_folder	= 'snort-2.9.9.0',
			$snort_daq		= 'daq-2.0.6.tar.gz',
			$snort_daq_fol	= 'daq-2.0.6'){

	Exec {
		path	=>	['/usr/bin', '/usr/sbin', '/bin'],
		returns =>	[0, 2, 14, 100],
	}

#INSTALL SNORT START
	#INSTALL DEPENDENCIES
	#ensure folder exits
	file { '/opt/snort/' : 
		ensure	=> directory,
		before	=> Package['ethtool']
	}
	
	package { 'ethtool' : 
		ensure 	=> present,
		require	=> File['/opt/snort'],
		before	=> Package['build-essential'],
	}

	package { 'build-essential' : 
		ensure 	=> present,
		require => Package['ethtool'],
		before	=> Package['libpcap-dev'],
	}

	package { 'libpcap-dev' : 
		ensure 	=> present,
		require => Package['build-essential'],
		before	=> Package['libpcre3-dev'],
	}

	package { 'libpcre3-dev' : 
		ensure 	=> present,
		require => Package['libpcap-dev'],
		before	=> Package['libdumbnet-dev'],
	}

	package { 'libdumbnet-dev' : 
		ensure 	=> present,
		require => Package['libpcre3-dev'],
		before	=> Package['bison'],
	}

	package { 'bison' : 
		ensure 	=> present,
		require => Package['libdumbnet-dev'],
		before	=> Package['flex'],
	}

	package { 'flex' : 
		ensure 	=> present,
		require => Package['bison'],
		before	=> Package['zlib1g-dev'],
	}

	package { 'zlib1g-dev' : 
		ensure  => present,
		require => Package['flex'],
		before	=> Package['liblzma-dev'],
	}

	package { 'liblzma-dev' : 
		ensure 	=> present,
		require => Package['zlib1g-dev'],
		before	=> Package['openssl'],
	}

	package { 'openssl' : 
		ensure 	=> present,
		require => Package['liblzma-dev'],
		before	=> Package['libssl-dev'],
	}

	package { 'libssl-dev' : 
		ensure  => present,
		require => Package['openssl'],
		before	=> File["/opt/snort/${snort_archive}"],
	}
	#INSTALL DEPENDENCIES END

#FOLDER START	
	# EXTRACT ARCHIVE
	file { "/opt/snort/${snort_archive}" : 
		ensure  => present,
		source  => "puppet:///modules/snort/${snort_archive}",
		require => Package['libssl-dev'],
		before	=> File["/opt/snort/${snort_daq}"]
	}

	file { "/opt/snort/${snort_daq}" : 
		ensure  => present,
		source  => "puppet:///modules/snort/${snort_daq}",
		require => File["/opt/snort/${snort_archive}"],
		before	=> Exec['extract_snort'],
	}

	exec { 'extract_snort' :
		cwd	=> '/opt/snort/',
		command	=> "sudo tar zxvf ${snort_archive}",
		require	=> File["/opt/snort/${snort_snort_daq}"],
		before	=> Exec['extract_snort_daq'],
	}

	exec { 'extract_snort_daq' :
		cwd	=> '/opt/snort/',
		command	=> "sudo tar zxvf ${snort_daq}",
		require	=> Exec['extract_snort'],
		before	=> Exec['disable_eth_feature1'],
	}
	# EXTRACT END
#FOLDER END

#INSTALL BEGIN
	#DISABLE LRO AND GRO ON ETHERNET ADAPTER
	exec { 'disable_eth_feature1' : 
	command	=> "sudo bash -c \"echo 'post-up ethtool -K eth0 lro off' >> /etc/network/interfaces\"",
	require	=> Exec['extract_snort_daq'],
	}

	exec { 'disable_eth_feature2' : 
	command	=> "sudo bash -c \"echo 'post-up ethtool -K eth0 gro off' >> /etc/network/interfaces\"",
	require	=> Exec['disable_eth_feature1'],
	}
	#NETORK CONFIG END

	#COMPILE SNORT DAQ AND INSTALL
	exec { 'install_daq' : 
		cwd		=> "/opt/snort/${snort_daq_fol}",
		command	=> "sudo bash -c '/opt/snort/${snort_daq_fol}/configure && make && make install'",
		require	=> Exec['disable_eth_feature2'],
		#user 	=> "root",
	}

	#COMPILE SNORT AND INSTALL
	exec { 'install_snort' : 
		cwd		=> "/opt/snort/${snort_folder}",
		command	=> "sudo bash -c '/opt/snort/${snort_folder}/configure --enable-sourcefire && make && make install'",
		require	=> Exec['install_daq'],
		#user 	=> "root",
	}
	#INTALL END
#INSTALL END END

#CONFIGURING SNORT
	#RUN COMMAND TO UPDATE SHARED LIBS
	exec { 'update_lib' : 
		command	=> 'sudo ldconfig',
		require	=> Exec['install_snort'],
	}

	#CREATE SYMLINK FOR SNORT SERVICE
	exec { 'sym_snort' : 
		command	=> 'sudo ln -s /usr/local/bin/snort /usr/sbin/snort',
		require	=> Exec['update_lib'],
	}

	# CREATE SNORT USER AND GROUP
	exec { 'grp_snort' : 
		command	=> 'sudo groupadd snort',
		require	=> Exec['sym_snort'],
	}

	exec { 'usr_snort' : 
		command	=> 'sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort',
		require	=> Exec['grp_snort'],
	}
	# CREATE SNORT USER END

	#CREATE RESPECTIVE SNORT FOLDERS
	file { '/opt/snort/mkdir.sh' : 
		ensure 	=> present,
		source  => 'puppet:///modules/snort/mkdir.sh',
		require	=> Exec['usr_snort'],
	}

	#update shell script permissions
	exec { 'mkdir_perm' : 
		cwd		=> '/opt/snort',
		command	=> 'sudo chmod a+x /opt/snort/mkdir.sh',
		require	=> File['/opt/snort/mkdir.sh'],
	}

	exec { 'snort_mkdir' : 
		cwd		=> '/opt/snort',
		command	=> "sudo bash -c '/opt/snort/mkdir.sh'",
		require	=> Exec['mkdir_perm'],
	}

	#CREATE FOLDERS END

	# ENSURING SNORT HAS LATEST COMMUNITY SIGNATURE DEFINITIONS
	exec { 'update_snort_download' : 
		cwd		=> "/opt/snort/${snort_folder}",
		command	=> 'sudo wget https://www.snort.org/rules/community',
		require	=> Exec['snort_mkdir'],
	}

	exec { "update_snort" : 
		cwd		=> "/opt/snort/${snort_folder}",
		command	=> 'sudo tar -xvfz community.tar.gz -C /etc/snort/rules',
		require	=> Exec['update_snort_download'],
	}
	#UPDATE SNORT END

	#COPY CONFIG FILE FOR SNORT
	file {'/etc/snort/snort.conf' : 
		ensure  => present,
		source  => 'puppet:///modules/snort/snort.conf',
		require => Exec['update_snort'],
	}

	#UPDATE PERMISSIONS FOR SNORT USER
	exec { 'update_perm1' : 
		command	=> 'sudo chown -R snort:snort /etc/snort',
		require	=> File['/etc/snort/snort.conf'],
	}

	exec { "update_perm2" : 
		command	=> "sudo chown -R snort:snort /var/log/snort",
		require	=> Exec['update_perm1'],
	}

	exec { "update_perm3" : 
		command	=> "sudo chown -R snort:snort /usr/local/lib/snort_dynamicrules",
		require	=> Exec['update_perm2'],
	}
	#UPDATE PERMISSIONS END	

	#CREATE SNORT SERVICE
	#COPY snort.init file
	file { '/etc/init/snort.init' : 
		ensure  => present,
		source  => 'puppet:///modules/snort/snort.init',
		require	=> Exec['update_perm3'],
	}

	#RENAME snort.init FILE
	exec { "rename_config" : 
		cwd		=> '/etc/init',
		command	=> 'sudo mv ./snort.init ./snort.conf',
		require	=> File['/etc/init/snort.init'],
	}

	#UPDATE snort.conf Permissions
	exec { "update_ex" : 
		command	=> 'sudo chmod a+x /etc/init/snort.conf',
		require	=> Exec['rename_config'],
	}

	#CHECK snort.conf EXECUTABLE
	exec { "check_ex" : 
		command	=> 'initctl list | grep snort',
		require	=> Exec['update_ex'],
	}

	#RESTART snort SERVICE
	exec { 'restart_snort' : 
		command	=> 'snort stop/waiting',
		require	=> Exec['check_ex'],
	}
}
