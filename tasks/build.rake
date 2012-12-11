
@builders.each do |host|
  desc "Build PE on #{host} builder"
  # We assume there's a defined restore task for every host, including all builders
  task :build => [:clean, "restore-#{host}"] do
    puts "stuff!"
  end
end

