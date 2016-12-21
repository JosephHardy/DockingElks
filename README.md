# DockingElks

1. Clone git repository: https://github.com/JosephHardy/DockingElks

2. The following binary files should be added to the shared_master/binaries directory:

- apache-tomcat-7.0.73.tar.gz
- daq-2.0.6.tar.gz
- elasticsearch-5.1.1.deb
- haproxy-1.7.1.tar.gz
- java.tar.gz
- jenkins_2.1_all.deb
- jira.bin
- kibana_5.1.1-linux-x86_64.tar.gz
- logstash-5.1.1.tar.gz
- maven.tar.gz
- nexus-3.0.2-02-unix.tar.gz
- packer_0.12.1_linux_amd64.zip
- snort-2.9.9.0.tar.gz

3. Git bash within the DockingElks directory and run the command 'vagrant up'










Note:
Add any installation files to the binaries folder in shared_master. Bootstrap should copy it to the correct folder on the machine. If not add it to the list at the bottom of bootstrap_master in the same format

Any files needed by the installation process, access in this format

    #Install Kibana
    file {"/opt/${kibana_archive}":
        ensure => "present",
        source => "puppet:///modules/elk/${kibana_archive}",
        owner => vagrant,
        mode => 755,
    	require => Exec['start elasticsearch'],
    }
    
