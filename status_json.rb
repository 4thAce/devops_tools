#!/usr/bin/ruby
# Take the SHOW GLOBAL STATUS output from mysql and force it into JSON
# Core
database="ec2-54-205-251-134.compute-1.amazonaws.com"
# Linker
database="ec2-54-81-85-214.compute-1.amazonaws.com"

lines = `mysql -h #{database} -u root -e "SHOW GLOBAL STATUS\\G"`.to_a

t=Time.now
# Alarm if there is no response
if !File.exists?("/home/deploy/#{database}-triggered") and lines == '' then
	curl_command <<EOF
	curl -H "Content-type: application/json" -X POST \
	-d '{ "service_key": "5c0050adfd9644a49333571e595fd656", \
	"incident_key": "#{database}/HTTP", \
	"event_type": "trigger", "description":"No response from database #{database}", \
	"client":"statusrds.rb","client_url":"http://www1.toutapp.com",\
	"details":{"trigger_time":"#{t.strftime('%Y-%m-%d %H:%M:%S')}"}}' \
	 >  "https://events.pagerduty.com/generic/2010-04-15/create_event.json"
	EOF
	pd_json=`${curl_command}`
else
	trigger=File.open("/home/deploy/#{database}-triggered",'w')
	trigger.puts("Alert triggerred at #{t.strftime('%Y-%m-%d %H:%M:%S')}")
	trigger.close
end

# We were able to connect to the db, dump it to JSON
out=File.open("/home/deploy/dbstat/db.#{t.strftime('%Y-%m-%d%H:%M:%S')}.json",'w')
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
out.puts '{'+output.join('')+ '}'
out.close