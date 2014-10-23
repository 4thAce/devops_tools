# Grab AWS info and extract server information from it

class EC2Info

  require 'json'
  def self.serverFromString(inputstring, pretty=false)
    structure = JSON.parse(inputstring) or raise "Badly formed JSON"
    outputhash = Hash.new
    count = 0
    structure["Reservations"].each do |resentry|      
         tag = Array.new
         if resentry.has_key?("Instances") && resentry["Instances"][0].has_key?("Tags") then
           resentry["Instances"][0]["Tags"].each do |sometag|
             tag.push(sometag["Value"])
           end
         end
         outputhash[count.to_s] = {
                                "fqdn" => resentry["Instances"][0]["PublicDnsName"],
                                "PublicIP" => resentry["Instances"][0]["PublicIpAddress"],
                                "PrivateIP" => resentry["Instances"][0]["PrivateIpAddress"],
                                "PrivateDnsName" => resentry["Instances"][0]["PrivateDnsName"],
                                "InstanceId" => resentry["Instances"][0]["InstanceId"],
                                "Tags" => tag.join(', ')
                                  }
         count += 1
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
