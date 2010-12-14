require 'forwardable'

module Secondhand  
  module Scheduler
    extend Forwardable
    extend self
    
    # Add some friendly faces
    def_delegators :scheduler,  :shutdown,
                                :stop,
                                :stop_now,
                                :started?,
                                :running?,
                                :paused?,
                                :standing_by?,
                                :shutdown?,
                                :stopped?
                                
                                
    
    # Add some sugar on StdScheduler
    class Java::OrgQuartzImpl::StdScheduler
      def run
        start
      end
      
      def stop_now
        shutdown
      end
      
      def stop
        shutdown(true) # waits for all jobs to finish
      end
      
      def running?
        is_started
      end
      
      def paused?
        is_in_standby_mode
      end
      alias_method :standing_by?, :paused?
      
      def stopped?
        is_shutdown
      end      
      
    end
    
  end 
end