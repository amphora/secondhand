module Secondhand  
  module Jobs
    extend self
        
    # Provide an array-like method to get to the job details
    def [](name)      
      details = scheduler.get_job_detail(name, group)
      details.job if details
    end
    
    def names
      Array(scheduler.get_job_names(DEFAULT_GROUP))
    end
    
    # Shortcuts
    
    def scheduler
      Secondhand.scheduler
    end
    
    def group
      Secondhand::DEFAULT_GROUP
    end
  end    
end