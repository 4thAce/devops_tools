# Talk to Engine Yard, grab the dna.json, extract information from it

class EYTrans

  require 'json'
  def self.serverFromFile(textfile,pretty=false)
    f = File.open(textfile)
    jsonstream = f.read
    return self.serverFromString(jsonstream,pretty)
  end

  def self.serverFromString(inputstring,pretty=false)
    inputary = inputstring.split("\n")
    # Read the lines and trim everything before the intial open brace
    foundbrace = false
    cleanary = Array.new
    inputary.each do |oneline|
      foundbrace = true if oneline[0] == '{'
      cleanary.push(oneline) if foundbrace
    end    
    # Parse the json and extract the instance info
    structure = JSON.parse(cleanary.join('')) or raise "Badly formed JSON"
    outputhash = Hash.new
    count = 0
    structure["engineyard"]["environment"]["instances"].each do |entry|
      outputhash[count.to_s] = {
                            "name" => entry["name"], 
                            "hostname" => entry["public_hostname"], 
                            "private_hostname" => entry["private_hostname"], 
                            "role" => entry["role"],
                            "id" => entry["id"]
                           }
      count += 1 
    end
    if pretty then
      return JSON.pretty_generate outputhash
    else
      return JSON.generate outputhash
    end
  end

  def self.live(environment,pretty=false)
    if (environment == "ToutStaging") or (environment == "ToutProduction") or (environment == "Linker") or (environment == "LinkerStaging") or (environment == "LinkerProduction") or (environment == "ToutImagerProduction") then
      stream = `/usr/local/bin/ey ssh 'sudo cat /etc/chef/dna.json' -e "#{environment}" `
      return self.serverFromString(stream,pretty)
    else
       raise "Unrecognized environment #{environment}"
    end
  end
end
