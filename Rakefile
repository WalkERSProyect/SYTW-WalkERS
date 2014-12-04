task :default => :test

desc "Run the WalkERS server"
task :server do
  sh "bundle exec ruby walkers.rb"
end

desc "run test examples"
task :test do
  sh "ruby ./test/test.rb"
end


