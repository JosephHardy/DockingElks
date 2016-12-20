class jenkins (
	$jenkins_archive = "jenkins_2.1_all.deb",
)

{
        #require java

        Exec {
                path => ["/usr/bin","/bin","/usr/sbin"]
        }
	
	file { "/opt/${jenkins_archive}":
		ensure => present,
		owner => vagrant,
		mode => 755,
		source => "/tmp/shared/jenkins/files/${jenkins_archive}",
		#source => "puppet:///modules/jenkins/${jenkins_archive}",
	}

#        exec { 'copy jenkins' :
#                command => 'sudo cp /tmp/shared/jenkins_2.1_all.deb /opt',
#        }

        exec { 'add key' :
                cwd => '/opt',
                command => 'wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -',
        }

        package { 'jenkins':
                provider => dpkg,
                ensure => installed,
                source => "/opt/jenkins_2.1_all.deb",
                require => Exec['add key']
        }

        service { 'jenkins':
                enable => true,
                ensure => running,
                hasrestart => true,
                hasstatus => true,
                require => Package['jenkins']
        }
}
