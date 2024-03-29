# Add a lock file for a version of AIX we're currently building on
# This will prevent us from initiating a build while another is in progress,
# which completely wipes the host
task :lock do
  STDOUT.puts
  STDOUT.puts "# Checking for existing lockfile..."
  os_ver = ENV['OS_VER']
  if File.exist?("#{@base_dir}/.lock_#{os_ver}")
    puts "A lock file exists at '#{@base_dir}/.lock_#{os_ver}', maybe a build is already going?"
    exit 1
  else
    # We have to use sudo here because the export directory is only root writeable
    STDOUT.puts "# Setting lockfile..."
    %x{sudo touch #{@base_dir}/.lock_#{os_ver}}
  end
end

