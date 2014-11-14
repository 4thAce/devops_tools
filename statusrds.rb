#!/usr/bin/ruby
# Script to check the status of our RDS instance

lines = `mysql -h toutapp-proddb.c01ai4mq2ltz.us-east-1.rds.amazonaws.com -u root -e "SHOW GLOBAL STATUS\\G"`.to_a
require 'fileutils'
t=Time.now
# Alarm if there is no response
pipe=open("/var/tmp/logrelay2","w+")   # Nonblocking
if !File.exists?("/home/deploy/triggered") and lines == '' then
	`curl -H "Content-type: application/json" -X POST \
	-d '{ "service_key": "5c0050adfd9644a49333571e595fd656", \
	"incident_key": "toutapp-proddb/HTTP", \
	"event_type": "trigger", "description":"No response from RDS database toutapp-proddb", \
	"client":"statusrds.rb","client_url":"http://www1.toutapp.com",\
	"details":{"trigger_time":"#{t.strftime('%Y-%m-%d %H:%M:%S')}"}}' \
	 >  "https://events.pagerduty.com/generic/2010-04-15/create_event.json"`
	trigger=File.open("/home/deploy/triggered",'w')
	trigger.puts("Alert triggered at #{t.strftime('%Y-%m-%d %H:%M:%S')}")
	trigger.close
else
# We were able to connect to the db, dump it to JSON
	filename="/home/deploy/dbstat/db.rds.#{t.strftime('%Y-%m-%d%H:%M:%S')}.json"
	out=File.open(filename,'w')
	output = []
	keyvalue=[]
	lines.each do |line|
        line.chomp!
		next if /\*\*\*/.match(line)
		pieces = line.split(':')
		if pieces[0] == "Variable_name" then
			keyvalue[0]='"',"rds_#{pieces[1].lstrip}",'":'
			output.push(keyvalue[0])
		elsif /Value/.match(pieces[0]) then
			keyvalue[1]="#{pieces[1].lstrip}"
			if keyvalue.length<1 then
				pipe.puts('""')
			else
			    pipe.puts("{#{keyvalue}}")
            end
    		output.push(keyvalue[1],",")
    	end
	end
	# Remove extra comma
	output[-1].chop!
	out.puts '{'+output.join('')+'}'
	out.close

	pipe.flush
	pipe.close
	#FileUtils.cp(filename,"/var/tmp/logrelay2")
end