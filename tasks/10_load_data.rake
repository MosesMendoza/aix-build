
# Our NIM master is pretty static, so its not in the yaml file

# commented until we have DNS up
#@nim_master = 'pe-aix-NIM.delivery.puppetlabs.net'
@nim_master = '10.16.77.10'
@nim_user   = 'aixcontroller'

# @setup_script is the nim first boot script file, located in the
# current directory
@setup_script = File.join('/', 'srv', 'aix', 'pe-aix', 'setup.sh')

data_file = File.join(RAKE_ROOT, 'machine_data.yml')

# Load the data from the data.yml file
begin
  require 'yaml'
  @aix_data         ||= YAML.load_file(data_file)
  @machine_names    = @aix_data.keys
  @machine_hashes   = @aix_data.values

  # Our builders have the key 'builder' set to 'true'. We make a list
  # of them here so we can define build tasks for each later in build.rake
  #
  @builders = []
  @os_vers  = []
  @machine_names.each do |host|
    data = @aix_data[host]
    if data['builder'] == 'true'
      @builders << host
      @os_vers  << data['os_ver']
    end
  end

rescue
  STDERR.puts "Couldn't load builder data"
  exit 1
end

