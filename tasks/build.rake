@builders.each do |host|
  data    = @aix_data[host]
  os_ver  = data['os_ver']
  namespace :pe do
    namespace :aix do
      # We assume there's a defined restore task for every host, including all builders
      # We also assume we have one builder defined per AIX OS Level
      namespace "#{os_ver}" do
        desc "Build PE for AIX #{os_ver} on #{host}"
        task "build" => "restore-#{host}" do
          puts ":stuff!"
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

