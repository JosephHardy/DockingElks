class java {

        Exec {
                path => ["/usr/bin","/bin","/usr/sbin"]
        }

        exec { 'copy java tar file' :
                command => 'sudo cp /tmp/shared/java.tar.gz /opt/',
        }

        exec { 'extract java tar file' :
                cwd => '/opt',
                command => 'sudo tar zxvf java.tar.gz',
                require => Exec['copy java tar file'],
        }

        exec { 'install java' :
                require => Exec['extract java tar file'],
                command => 'sudo update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_45/bin/java 100',
        }

        exec { 'install javac' :
                require => Exec['extract java tar file'],
                command => 'sudo update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_45/bin/javac 100',
        }
}

