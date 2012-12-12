# Check investigates our AIX build sources for any changes
# If there are any, we abort if not overridden
#
aix_src_path = '/srv/aix/pe-aix'
task :check => :lock do
  unless ENV['NO_CHECK'] == '1'
    STDOUT.puts "# Checking for a clean source tree..."
    cd @src_dir do
      describe = %x{git describe --dirty --always}
      if describe.include?('-dirty')
        STDERR.puts "The git tree in #{aix_src_path} is dirty, exiting. Pass NO_CHECK=1 to bypass"
        exit 1
      end
    end
  end
end
