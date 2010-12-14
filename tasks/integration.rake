namespace :test do
  desc "Run integration test(s)"
  task :integration do
    cmd = "jruby -I.:lib:test -rubygems -e \"Dir['test/integration/*.rb'].each { |f| require f }\" | cat"
    puts cmd
    system cmd
  end
end