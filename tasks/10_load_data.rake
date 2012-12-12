# Load data about our environment from yaml files in our base directory
#
machine_data = File.join(RAKE_ROOT, 'tasks', 'data', 'machine_data.yml')
site_data    = File.join(RAKE_ROOT, 'tasks', 'data', 'site_data.yml')

# Load the data from the data.yml file
begin
  require 'yaml'
  # Various data about our site, that aren't builder specific
  #
  @site_data              ||= YAML.load_file(site_data)
  @base_dir               = @site_data['base_dir']
  @src_dir                = @site_data['src_dir']
  @nim_master             = @site_data['nim_master']
  @nim_local_user         = @site_data['nim_local_user']
  @nim_remote_user        = @site_data['nim_remote_user']
  @distribution_server    = @site_data['distribution_server']
  @setup_script           = @site_data['setup_script']
  @remote_fb_script_path  = @site_data['remote_fb_script_path']
  @distribution_repo_path = @site_data['distribution_repo_path']
  # machine-specific data
  #
  @machine_data           ||= YAML.load_file(machine_data)
  @machine_names          = @machine_data.keys
  @machine_hashes         = @machine_data.values

  # Our builders have the key 'role' set to 'builder'. We make a list
  # of them here so we can define build tasks for each later in build.rake
  #
  @builders = []
  @os_vers  = []
  @machine_names.each do |host|
    data = @machine_data[host]
    if data['role'] == 'builder'
      @builders << host
      @os_vers  << data['os_ver']
    end
  end
rescue
  STDERR.puts "Couldn't load builder data"
  exit 1
end
