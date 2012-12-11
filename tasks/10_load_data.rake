
# Our NIM master is pretty static, so its not in the yaml file

# commented until we have DNS up
#@nim_master = 'pe-aix-NIM.delivery.puppetlabs.net'
@nim_master = '10.16.77.10'
@nim_user   = 'aixcontroller'

data_file = File.join(RAKE_ROOT, 'machine_data.yml')

# Load the data from the data.yml file
begin
  require 'yaml'
  @aix_data         ||= YAML.load_file(data_file)
  @machine_names    = @aix_data.keys
  @machine_hashes   = @aix_data.values
rescue
  STDERR.puts "Couldn't load builder data"
  exit 1
end

