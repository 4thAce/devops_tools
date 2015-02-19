Some tooling to help manage Toutapp infrastructure

* eytrans -- Class to generate Engine Yard on AWS server list
* eyrun.sh -- Convenience script to target Production and Staging environments
* ec2info -- Class to generate list of standalone AWS servers
* ec2run.sh - Convenience script to pretty-print the AWS list
* hipchat_replication.sh - Watch how far the RDS replica is from the master db
* linkerreplication.sh - Monitor sync between linker master and slave
* replicationstatus.sh - Dump core replication sttaus to a file
* status_json.rb - Put mysql SHOW GLOBAL STATUS to a json file
* killstalejobs - Template for killing stuck workers
* failedrestartcheck.sh - See who failed to restart their resques

= Prerequisites

* awscli (install this using the python-pip package)
* engineyard (install this as a local gem and set up authentication)