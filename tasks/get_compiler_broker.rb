#!/opt/puppetlabs/puppet/bin/ruby
require 'json'

# Read the JSON data from the file
conf_data = File.read('/etc/puppetlabs/pxp-agent/pxp-agent.conf')

# Parse the JSON data
conf_json = JSON.parse(conf_data)

# Extract the broker URI
broker_uri = conf_json['broker-ws-uris'][0]

# Create a hash with the broker URI
result = { 'broker_uri' => broker_uri }

# Convert the hash to a JSON string
result_json = result.to_json

# Print the JSON string
puts result_json
