class maven (
	$maven_home = "/opt/maven",
	$maven_archive = "apache-maven-3.3.9-bin.tar.gz",
	) 
	{
	require java
	Exec {
		path => [ "/usr/bin", "/bin", "/usr/sbin"]
	}
  
	file { "/opt/${maven_archive}":
		ensure => present,
		source => "puppet:///modules/maven/${maven_archive}",
		owner => vagrant,
		mode => 755,
	}
  
	exec { "extract maven":
		command => "tar xfv ${maven_archive}",
		cwd => "/opt/",
		creates => "${maven_home}",
		require => File["/opt/${maven_archive}"]
	}
	exec {'install maven':
		require => Exec ['move maven'],
		logoutput => true,
		command => "update-alternatives --install /usr/bin/mvn mvn ${maven_home}/bin/mvn 1"
	}

}