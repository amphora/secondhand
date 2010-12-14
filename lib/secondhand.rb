require 'java'

# If JRuby::Rack::VERSION is defined then Secondhand is in a servlet. 
# Secondhand does not need to require jar archives in this case
# as those should be in WEB-INF/lib and already in the classpath
unless defined?(JRuby::Rack::VERSION)
  # jars
  require 'quartz/log4j-1.2.14.jar'
  require 'quartz/quartz-1.8.4.jar'
  require 'quartz/slf4j-api-1.6.0.jar'
  require 'quartz/slf4j-log4j12-1.6.0.jar'
end

require 'secondhand/logging'
require 'secondhand/job'
require 'secondhand/jobs'
require 'secondhand/scheduler'
require 'secondhand/trigger'
require 'secondhand/version'

module Secondhand
  import java.lang.System
  import org.quartz.impl.StdScheduler
  import org.quartz.impl.StdSchedulerFactory

  extend Scheduler
  extend self  
  
  # Raised when the scheduler is used before being initialized
  class NoSchedulerError < RuntimeError; end  
  
  DEFAULT_GROUP = "SECONDHAND"
  DEFAULT_THREAD_COUNT = 5
  @scheduler = nil
  
  def reset_thread_count
    @thread_count = DEFAULT_THREAD_COUNT
  end
  
  def thread_count=(threads)
    @thread_count = threads
  end
  
  def thread_count
    reset_thread_count unless @thread_count
    @thread_count
  end
  
  def start(threads = nil)
    initialize_scheduler(threads)
    scheduler.start
  end
  alias_method :run, :start

  def initialize_scheduler(threads = nil)
    @thread_count = threads if threads
    # Quartz uses this property to set the number of worker threads
    System.set_property("org.quartz.threadPool.threadCount", @thread_count.to_s)
    # Stop Quartz from looking for updates
    System.set_property("org.quartz.scheduler.skipUpdateCheck", "true")
    # Initialize the default scheduler
    @scheduler = StdSchedulerFactory.default_scheduler
    # Set up our custom job factory
    @scheduler.job_factory = Job::Factory.instance
  end

  def schedule(job, opts={}, &block)
    name = job.to_s
    scheduler.schedule_job(Job.create(name, block ? block : job), Trigger.create(name, opts))
  end

  # Shortcuts
  
  # Raise an error if the scheduler isn't ready - with Quartz we have an order
  # of operations to follow. This also lets us pass the threads in with .start
  def scheduler
    raise NoSchedulerError, "Scheduler isn't initialized. Call Secondhand.start before scheduling jobs." unless @scheduler 
    @scheduler
  end
  
  def jobs
    Jobs
  end
  
  def job_names
    Jobs.names
  end
  
end