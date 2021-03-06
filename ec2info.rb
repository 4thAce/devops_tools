# Grab AWS info and extract server information from it

class EC2Info

  require 'json'
  def self.serverFromString(inputstring, pretty=false)
    structure = JSON.parse(inputstring) or raise "Badly formed JSON"
    outputhash = Hash.new
    count = 0
    structure["Reservations"].each do |resentry|
         if resentry.has_key?("Instances") && resentry["Instances"][0].has_key?("Tags") then
           resentry["Instances"].each do |aninstance|
             tag = Array.new
             aninstance["Tags"].each do |sometag|
               tag.push(sometag["Value"])
               outputhash[count.to_s] = {
                                    "fqdn" => aninstance["PublicDnsName"],
                                    "PublicIP" => aninstance["PublicIpAddress"],
                                    "PrivateIP" => aninstance["PrivateIpAddress"],
                                    "PrivateDnsName" => aninstance["PrivateDnsName"],
                                    "InstanceId" => aninstance["InstanceId"],
                                    "Tags" => tag.join(', '),
                                    "InstanceType" => aninstance["InstanceType"]
                                      }
               count += 1
             end
           end
         end
    end
    if pretty then
      return JSON.pretty_generate outputhash
    else
      return JSON.generate outputhash
    end
  end

  def self.serverFromFile(inputFile, pretty=false)
    f = File.open(inputFile)
    jsonstream = f.read
    return self.serverFromString(jsonstream,pretty)
  end

  def self.live(pretty=false)
      stream = `aws ec2 describe-instances`
      return self.serverFromString(stream,pretty)
  end

end
