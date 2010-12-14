# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{secondhand}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Don Morrison"]
  s.date = %q{2010-12-13}
  s.email = %q{elskwid@gmail.com}
  s.extra_rdoc_files = ["README.md"]
  s.files = ["LICENSE", "Rakefile", "README.md", "test/integration", "test/test_helper.rb", "test/unit", "test/integration/test_secondhand_run.rb", "test/unit/test_job.rb", "test/unit/test_jobs.rb", "test/unit/test_logger.rb", "test/unit/test_scheduler.rb", "test/unit/test_secondhand.rb", "test/unit/test_trigger.rb", "lib/quartz", "lib/secondhand", "lib/secondhand.rb", "lib/quartz/log4j-1.2.14.jar", "lib/quartz/quartz-1.8.4.jar", "lib/quartz/slf4j-api-1.6.0.jar", "lib/quartz/slf4j-log4j12-1.6.0.jar", "lib/secondhand/job.rb", "lib/secondhand/jobs.rb", "lib/secondhand/logging.rb", "lib/secondhand/scheduler.rb", "lib/secondhand/trigger.rb", "lib/secondhand/version.rb"]
  s.homepage = %q{http://yoursite.example.com}
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Secondhand is a ruby-friendly wrapper around the Quartz Job Scheduler. Create jobs, tell Secondhand when they should run, then sit back and enjoy.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
