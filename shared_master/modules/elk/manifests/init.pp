class elk(
	$elasticsearch_archive ="elasticsearch-5.1.1.deb",
	$kibana_archive = "kibana-5.1.1-amd64.deb",
	$logstash_archive = "logstash-5.1.1.tar.gz"
	)
	{
	#require java

	Exec {
		path => ["/usr/bin", "/bin", "/usr/sbin"]
	}

	#Install Elasticsearch first
	file {"/opt/${elasticsearch_archive}":
		ensure => "present",
		#source => "/tmp/shared/elk/files/${elasticsearch_archive}",
		source => "puppet:///modules/elk/${elasticsearch_archive}",
		owner => vagrant,
		mode => 755,
	}

	exec{'get debian key':
		cwd => "/opt",
		command => "wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -",
		require => File["/opt/${elasticsearch_archive}"],
	}

	package{'install elasticsearch':
		ensure => installed, 
		provider => 'dpkg',
		source => "/opt/${elasticsearch_archive}",
		require => Exec["get debian key"],
	}

	exec{'update elasticstack':
		command => "sudo update-rc.d elasticsearch defaults 95 10",
		require => Package['install elasticsearch'],
	}

	exec{'start elasticsearch':
		command => "sudo -i service elasticsearch start",
		require => Exec['update elasticsearch'],
	}

	#Install Kibana
	file {"/opt/${kibana_archive}":
		ensure => "present",
		#source => "/tmp/shared/elk/files/${kibana_archive}",
		source => "puppet:///modules/elk/${kibana_archive}",
		owner => vagrant,
		mode => 755,
	}

	package{'install kibana':
		ensure => installed, 
		provider => 'dpkg',
		source => "/opt/${kibana_archive}",
		require => File["/opt/${kibana_archive}"],
	}

	exec{'update kibana':
		command => "sudo update-rc.d kibana defaults 96 9",
		require => Package['install kibana'],
	}

	exec{'start elasticsearch':
		command => "sudo -i service kibana start",
		require => Exec['update kibana'],
	}

	#Install Logstash
	
}