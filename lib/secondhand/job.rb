require 'singleton' # for factory

module Secondhand
  import org.quartz.JobDetail
  import org.quartz.spi.JobFactory
  
  module Job    
    
    def self.create(name, work)
      # Store the job and work for our job factory impl      
      Details.new(name, Secondhand::DEFAULT_GROUP, work)
    end
    
    # Quartz croaks with a Ruby created JobClass so, hijack the job here
    # and bend it to our will
    class Details < Java::OrgQuartz::JobDetail
      attr_accessor :job
      
      def initialize(name, group, work)
        super()
        # name & group are required by Quartz
        set_name name.to_s
        set_group group.to_s
        # add the execute method if needed
        work.extend Job::Runner unless work.respond_to?(:execute)
        @job = work
        self
      end
      
      # Override validate so Quartz doesn't throw an error about the JobClass
      def validate; end

    end

    # Thin wrapper around a job to provide the expected Quartz interface
    module Runner
      def execute(context = nil)
        self.respond_to?(:call) ? self.call : self.perform        
      end
    end

    # Create custom JobFactory to hand out jobs from a Ruby collection
    # and not from the Quartz job list. Avoids problems with JRuby and
    # interfaces to and from Ruby.
    class Factory
      include Singleton
      include JobFactory        
      
      # Quartz calls new_job on the factory to get the job details
      #  * event = execution-time data about the job (from Quartz)
      def new_job(event)      
        # Get a job from the factory - Quartz calls #execute(context) on this      
        event.get_job_detail.job  
      end
    end
    
  end
end