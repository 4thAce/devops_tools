#!/usr/bin/ruby
require 'fileutils'
#lines = `mysql -h ec2-54-81-85-214.compute-1.amazonaws.com -u root -e "SHOW GLOBAL STATUS\\G"`.to_a
lines = `mysql -h ec2-107-22-132-132.compute-1.amazonaws.com -u root -e "SHOW GLOBAL STATUS\\G"`.to_a
t=Time.now
filename="/home/deploy/dbstat/db.#{t.strftime('%Y-%m-%d%H:%M:%S')}.json"
pipe=open("/var/tmp/logrelay2","w+")   # Nonblocking
out=File.open(filename,'w')
output = []
keyvalue=[]
lines.each do |line|
        line.chomp!
		next if /\*\*\*/.match(line)
		pieces = line.split(':')
		if pieces[0] == "Variable_name" then
			keyvalue[0]='"',"prod_#{pieces[1].lstrip}",'":'
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
out.puts '{'+output.join('')+ '}'
out.close

pipe.flush
pipe.close
#FileUtils.cp(filename,"/var/tmp/logrelay2")