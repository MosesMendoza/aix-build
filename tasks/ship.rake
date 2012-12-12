# @distribution_server is defined in 10_load_data.rake
desc "Ship built AIX rpms to #{@distribution_server}"
task :ship do
  Rake::Task[:check].execute
  if ENV['NO_CHECK']
    STDERR.puts "Shipping is disabled if NO_CHECK is set. Try without NO_CHECK"
    exit 1
  else
    check_var('PE_VER', ENV['PE_VER'])
    # @distribution_repo_path has a string, _pe_ver_, that we gsub out with
    # the PE version to get the right remote path
    @distribution_repo_path.gsub!('_pe_ver_', ENV['PE_VER'])
    remote_path = "#{@distribution_repo_path}/#{ENV['PE_VER']}/repos/"
    @os_vers.each do |os_ver|
      results_dir = "#{@base_dir}/#{os_ver}"
      if File.exist?("#{results_dir}/aix-#{os_ver}-power")
        rsync_to("#{results_dir}/aix-#{os_ver}-power", @distribution_server, remote_path)
      end
      if File.exist?("#{results_dir}/aix-#{os_ver}-srpms")
        rsync_to("#{results_dir}/aix-#{os_ver}-srpms", @distribution_server, remote_path)
      end
    end
  end
end

