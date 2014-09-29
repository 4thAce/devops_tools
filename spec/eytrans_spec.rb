require_relative "../eytrans"
require 'rspec/expectations'

RSpec.describe EYTrans do

#  before do
#    # nothing
#  end

  it "returns the server in passed json" do
    j = '{"engineyard": { "environment": { "instances": [ { "name": "ResqueAndRedis", "public_hostname": "ec2-23-22-12-137.compute-1.amazonaws.com", "components": [], "role": "util", "id": "i-0a41a827" }]}}}'
    result = EYTrans.serverFromString(j).split("\n").join('')
    expect(result).to eq("{\"0\":{\"name\":\"ResqueAndRedis\",\"hostname\":\"ec2-23-22-12-137.compute-1.amazonaws.com\",\"role\":\"util\",\"id\":\"i-0a41a827\"}}")
  end

  it "returns single server info with extraneous stuff" do
    j='{"engineyard": {"environment":{"instances":[{"name": "Resque1", "public_hostname": "ec2-23-22-12-137.compute-1.amazonaws.com", "components": [{"key": "ssmtp"}, { "tags": [ "product=cloud", "ey.domain=api.engineyard.com", "ey.server.id=368984", "ey.environment.id=83991", "sso_id=a3cd666b-2547-47b1-be87-7ca0618d330a" ], "key": "appfirst" }, { "domain": "api.engineyard.com", "instance_id": 368984, "key": "appfirst_tags" } ],"hostname": "domU-12-31-39-0B-34-54.compute-1.internal", "role": "util","id": "i-d210def8"}]}}}'
    result = EYTrans.serverFromString(j).split("\n").join('')
    expect(result).to eq("{\"0\":{\"name\":\"Resque1\",\"hostname\":\"ec2-23-22-12-137.compute-1.amazonaws.com\",\"role\":\"util\",\"id\":\"i-d210def8\"}}")
  end

  it "returns single server info from file" do
    result = EYTrans.serverFromFile("spec/singleserver.json").split("\n").join('')
    expect(result).to eq("{\"0\":{\"name\":\"ResqueAndRedis\",\"hostname\":\"ec2-23-22-12-137.compute-1.amazonaws.com\",\"role\":\"util\",\"id\":\"i-1511df3f\"}}")
  end

  it "returns multiple servers" do
    result = EYTrans.serverFromFile("spec/multiple.json").split("\n").join('')
    expect(result).to eq("{\"0\":{\"name\":null,\"hostname\":\"ec2-54-204-106-1.compute-1.amazonaws.com\",\"role\":\"app\",\"id\":\"i-1511df3f\"},\"1\":{\"name\":\"ResqueAndRedis\",\"hostname\":\"ec2-23-22-12-137.compute-1.amazonaws.com\",\"role\":\"util\",\"id\":\"i-0a41a827\"},\"2\":{\"name\":\"Resque1\",\"hostname\":\"ec2-54-81-23-111.compute-1.amazonaws.com\",\"role\":\"util\",\"id\":\"i-d210def8\"},\"3\":{\"name\":null,\"hostname\":\"ec2-23-21-102-199.compute-1.amazonaws.com\",\"role\":\"app_master\",\"id\":\"i-3e4ca513\"},\"4\":{\"name\":\"Cacher\",\"hostname\":\"ec2-54-198-215-4.compute-1.amazonaws.com\",\"role\":\"util\",\"id\":\"i-d65aef87\"},\"5\":{\"name\":\"mysql_55\",\"hostname\":\"ec2-54-166-132-198.compute-1.amazonaws.com\",\"role\":\"db_master\",\"id\":\"i-6ba88584\"},\"6\":{\"name\":\"new\",\"hostname\":\"ec2-54-234-195-11.compute-1.amazonaws.com\",\"role\":\"db_slave\",\"id\":\"i-9b9441b6\"}}")
  end

  it "talks to staging" do
    result = EYTrans.live("ToutStaging").split("\n").join('')
    expect(result).to match(/ResqueAndRedis/)
    expect(result).to match(/Resque1/)
    expect(result).to match(/Cacher/)
    expect(result).to match(/mysql_55/)
    expect(result).to match(/db_slave/)
    expect(result).to match(/app_master/)
    expect(result).to match(/util/)
    expect(result).to match(/db_master/)
    expect(result).to match(/db_slave/)
  end

end
