class elk(
	$elasticsearch_archive ="elasticsearch-5.1.1.deb",
	$kibana_archive = "kibana-5.1.1-linux-x86_64.tar.gz",
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
		require => File["/opt/${elasticsearch_archive}"],
	}

	exec{'update elasticstack':
		command => "sudo update-rc.d elasticsearch defaults 95 10",
		require => Package['install elasticsearch'],
	}

	exec{'start elasticsearch':
		command => "sudo -i service elasticsearch start",
		require => Exec['update elasticsearch'],
	}
}