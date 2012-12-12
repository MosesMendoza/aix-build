@builders.each do |host|
  data            = @machine_data[host]
  os_ver          = data['os_ver']
  ip              = data['ip']
  namespace :pe do
    namespace :aix do
      # We assume there's a defined restore task for every host, including all builders
      # We also assume we have one builder defined per AIX OS Level
      namespace "#{os_ver}" do
        desc "Build PE for AIX #{os_ver} on #{host}"
        task "build" => "restore-#{host}" do
          STDOUT.puts "# Building packages for #{os_ver} on #{host}..."
          sh "ssh -o StrictHostKeyChecking=no #{@nim_remote_user}@#{ip} \
          'pushd #{@base_dir}/#{os_ver} ; \
          cp -pr #{@src_dir}/* . ; \
          make all ; \
          popd'"
        end
      end
    end
  end
end

# An :all task outside the namespaces
desc "Build PE rpms for all versions of AIX"
task :all do
  @os_vers.each do |os_ver|
    Rake::Task["pe:aix:#{os_ver}:build"].invoke
  end
end

