# DockingElks

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
    
