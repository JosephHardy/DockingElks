node default {
	include java
	include maven
}

node 'elkAgent.qac.local'{
	include elk
	}
	
node 'snortAgent.qac.local' {
	include snort
	}
	
node 'jiraAgent.qac.local' {
	include jira
	include jenkins
}

node 'packerAgent.qac.local'{
	include packer
	include nexus
	include tomcat
	}