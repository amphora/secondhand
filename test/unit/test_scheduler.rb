require File.dirname(__FILE__) + '/../test_helper'

class TestScheduler < Test::Unit::TestCase
  import org.quartz.impl.StdScheduler
  
  def setup    
    Secondhand.reset_thread_count    
  end
  
  def test_default_thread_count    
    assert_equal 5, Secondhand.thread_count
  end
  
  def test_thread_count_setter    
    Secondhand.thread_count = 2
    assert_equal 2, Secondhand.thread_count
  end
    
  def test_scheduler_instance
    Secondhand.initialize_scheduler
    assert_instance_of StdScheduler, Secondhand.scheduler
    assert_equal Secondhand.scheduler, Secondhand.scheduler    
  end
  
  def test_state_and_argument
    sh = Secondhand
    sh.start(1)
    assert sh.running?
    assert sh.started?
    assert_equal 1, sh.thread_count
  end
  
end