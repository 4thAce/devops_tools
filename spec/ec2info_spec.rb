require_relative "../ec2info"
require 'rspec/expectations'

RSpec.describe EC2Info do

  it "returns information from a string json" do
    j = '{ "Reservations": [ { "Instances": [{ "PublicDnsName": "ec2-54-91-12-22.compute-1.amazonaws.com", "PublicIpAddress": "54.91.12.22", "InstanceId": "i-ca90e4e1", "Tags": [ { "Value": "Analytics (production) - analytics-app2", "Key": "Name" } ]} ]}]}'
    result = EC2Info.serverFromString(j)
    expect(result).to eq("{\"0\":{\"fqdn\":\"ec2-54-91-12-22.compute-1.amazonaws.com\",\"PublicIP\":\"54.91.12.22\",\"InstanceId\":\"i-ca90e4e1\",\"Tags\":\"Analytics (production) - analytics-app2\"}}")
  end

  it "returns information from a saved json" do
    result = EC2Info.serverFromFile("spec/awstest.json",true)
    expect(result).to match(//)
  end

end
