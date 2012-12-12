desc "Clean out build results directories and temporary work dirs"
task :clean => :check do
  os_ver = ENV['OS_VER']
  # The @base_dir directories are NFS exports that are mounted by the AIX LPARS
  # We just clean locally to remove the amount of ssh communication we have to do
  # with the LPARS
  #
  STDOUT.puts "# Cleaning build target directories..."
  %x{sudo rm -rf #{@base_dir}/#{os_ver}/*}
end

