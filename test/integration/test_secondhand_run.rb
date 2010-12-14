require File.dirname(__FILE__) + '/../test_helper'

class TestSecondhandRun < Test::Unit::TestCase  
  
  def setup
    Secondhand.reset_thread_count    
    org.apache.log4j.BasicConfigurator.configure
  end

  def test_five_second_cron_job    
    Secondhand.start(1)
    assert Secondhand.started?
    
    # This job will say 'something' every 5 seconds
    Secondhand.schedule SaySomething, :with_cron => "0/5 * * * * ?"    
    assert_equal SaySomething, Secondhand.jobs["SaySomething"]
    
    # This job will say 'block something' every 10 seconds
    Secondhand.schedule "my_block", :with_cron => "0/10 * * * * ?" do
      puts "block something [10 sec]"
    end

    # This job will say 'One shot job!' as soon as it is scheduled
    Secondhand.schedule "one_shot" do
      puts "One shot job!"
    end
        
    puts "sleeping while the scheduler runs ..."
    sleep 20
    
    Secondhand.stop
  end

end

class SaySomething
  # You could add the logging methods to your class
  # extend Secondhand::Logger
  
  def self.perform
    puts "something [5sec]"  
    # Or you can just call the logger
    # Secondhand::Logger.info "something [5sec] --> through Log4J"
    
    # With extend Logging from above
    # self.info "another thing ==> through Log4j"
  end
end
