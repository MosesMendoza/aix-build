
# restore an AIX partition
#
def bos_inst_restore(args = {})
  nim_master      = args[:nim_master]
  nim_master_user = args[:nim_master_user]
  nim_user        = args[:nim_user]
  nim_client      = args[:nim_client]
  type            = args[:type]
  spot            = args[:spot]
  mksysb          = args[:mksysb]
  fb_script       = args[:fb_script]
  os_ver          = args[:os_ver]

  # the ready file is generated by the builder after a restore
  #
  ready_file = File.join("/srv/aix/#{os_ver}/.ready")

  # Remove the ready file if it exists
  #
  sh "sudo rm -f #{ready_file}" if File.exist?(ready_file)

  # Initiate the restore via remote command
  #
  cmd = ["sudo su - aixcontroller -c \"ssh -t #{nim_master_user}@#{nim_master} 'nim -o bos_inst"]
  cmd << [ "-a source=#{type}", "-a spot=#{spot}", "-a mksysb=#{mksysb}", "-a boot_client=yes"]
  # fb_script, the first boot script, is optional
  cmd << "-a fb_script=#{fb_script}" if fb_script
  cmd << "#{nim_client}'\""
  #sh cmd.flatten.join(' ')
  puts cmd.flatten.join(' ')

  # Sit in our polling loop until we have a ready file
  #
  STDOUT.sync = true
  STDOUT.puts
  STDOUT.print "Restoring builder"
  until File.exist?(ready_file)
    STDOUT.print '.'
    sleep 1.2
  end
  STDOUT.puts "Builder restored"
  sh "sudo rm -f #{ready_file}"
end

# Define a restoration task for every builder we have defined
# in machine_data.yaml. The nim_master, nim_master_user,
# nim_user, and type are either static or global, hence they're
# not taken from the yaml file but rather just defined here or
# in 10_load_data.rake
#
@machine_names.each do |host|
  desc "Restore #{host} builder, pass NO_FB to prevent first run script"
  task "restore-#{host}" do
    data = @aix_data[host]
    args = {
      :nim_master       => @nim_master,
      :nim_master_user  => 'root',
      :nim_user         => @nim_user,
      :nim_client       => data['nim_client'],
      :type             => 'mksysb',
      :spot             => data['spot'],
      :mksysb           => data['mksysb'],
      :fb_script        => (ENV['NO_FB'] ? nil : data['fb_script']),
      :os_ver           => data['os_ver'],
    }
    ENV['OS_VER'] = data['os_ver']
    Rake::Task['clean'].invoke
    bos_inst_restore(args)
  end
end

