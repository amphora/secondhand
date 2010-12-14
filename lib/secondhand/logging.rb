require 'forwardable'

module Secondhand
  module Logger
    import org.apache.log4j
    extend self  
    
    def logger
      Java::OrgApache::log4j::Logger.get_logger("Secondhand")
    end
    
    def debug(msg)
      logger.log(Level::DEBUG, msg)
    end
    
    def info(msg)
      logger.log(Level::INFO, msg)
    end
    
    def error(msg)
      logger.log(Level::ERROR, msg)
    end
    
    def warn(msg)
      logger.log(Level::WARN, msg)
    end    
    
  end
  
end
