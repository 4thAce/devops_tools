#!/usr/bin/ruby
require 'fileutils'
lines = `mysql -h ec2-54-81-85-214.compute-1.amazonaws.com -u root -e "SHOW GLOBAL STATUS\\G"`.to_a
t=Time.now
filename="/home/deploy/dbstat/db.#{t.strftime('%Y-%m-%d%H:%M:%S')}.json"
out=File.open(filename,'w')
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

FileUtils.cp(filename,"/var/tmp/logrelay2")