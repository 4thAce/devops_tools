#!/usr/bin/ruby
# Script to check the status of our RDS instance

lines = `mysql -h toutapp-proddb.c01ai4mq2ltz.us-east-1.rds.amazonaws.com -u root -e "SHOW GLOBAL STATUS\\G"`.to_a

t=Time.now
# Alarm if there is no response
if !File.exists?("/home/deploy/triggered") and lines == '' then
	curl_command <<EOF
	curl -H "Content-type: application/json" -X POST \
	-d '{ "service_key": "5c0050adfd9644a49333571e595fd656", \
	"incident_key": "toutapp-proddb/HTTP", \
	"event_type": "trigger", "description":"No response from RDS database toutapp-proddb", \
	"client":"statusrds.rb","client_url":"http://www1.toutapp.com",\
	"details":{"trigger_time":"#{t.strftime('%Y-%m-%d %H:%M:%S')}","humidity":"moderate"}}' \
	 >  "https://events.pagerduty.com/generic/2010-04-15/create_event.json"
	EOF
	pd_json=`${curl_command}`
else
	trigger=File.open("/home/deploy/triggered",'w')
	trigger.puts("Alert triggerred at #{t.strftime('%Y-%m-%d %H:%M:%S')}")
	trigger.close
end

# We were able to connect to the db, dump it to JSON
out=File.open("/home/deploy/dbstat/db.rds.#{t.strftime('%Y-%m-%d%H:%M:%S')}.json",'w')
output = []
lines.each do |line|
        line.chomp!
	next if /\*\*\*/.match(line)
	pieces = line.split(':')
	if pieces[0] == "Variable_name" then
		output.push('"',"#{pieces[1].lstrip}",'":')
	elsif /Value/.match(pieces[0]) then
		output.push('"',"#{pieces[1].lstrip}",'",')
         end
end
# Remove extra comma
output[-1].chop!
out.puts '{'+output.join('')+'}'
out.close
