module Secondhand  
  import org.quartz.CronTrigger
  import org.quartz.SimpleTrigger    
  
  class Trigger    
    
    # Return correct Quartz Trigger
    def self.create(name, opts)
      args = ["#{name}_trigger", Secondhand::DEFAULT_GROUP]
      
      # with_cron trumps other options
      if opts[:with_cron]
        args << opts[:with_cron]
        CronTrigger.new(*(args).compact)
      else
        args << opts[:at] || opts[:on]        
        SimpleTrigger.new(*(args).compact)
      end
    end
    
  end
end
  
  