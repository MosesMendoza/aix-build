desc "Clean out build results directories and temporary work dirs"
task :clean => :check do
  os_ver = ENV['OS_VER']
  # These /srv directories are NFS exports that are mounted by the AIX LPARS
  # We just clean locally to remove the amount of ssh communication we have to do
  # with the LPARS
  #
  sh "sudo rm -rf /srv/aix/#{os_ver}/* ; sudo rm -rf /srv/aix/pe-aix/aix-#{os_ver}-{power,srpms}"
end

