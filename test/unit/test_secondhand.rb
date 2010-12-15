require File.dirname(__FILE__) + '/../test_helper'

class TestSecondhand < Test::Unit::TestCase  
  
  class SimpleJob
    def self.perform
      "Some job text"
    end
  end
  
  class TimedJob < SimpleJob; end
  
  def setup
    # Secondhand.jobs.clear
    Secondhand.start(1)
  end  
    
  def test_simple_class_job
    Secondhand.schedule TestSecondhand::SimpleJob
    assert_equal TestSecondhand::SimpleJob, Secondhand.jobs["TestSecondhand::SimpleJob"]
  end
  
  def test_simple_named_job_block
    Secondhand.schedule "some_job" do
      "Some job text"
    end
    assert Secondhand.jobs["some_job"].is_a? Proc
    assert_equal "Some job text", Secondhand.jobs["some_job"].call
  end

  def test_schedule_simple_job
    date = Time.now + 120 # 120 seconds from now
    Secondhand.schedule TestSecondhand::TimedJob, :at => date
    assert_equal TestSecondhand::TimedJob, Secondhand.jobs["TestSecondhand::TimedJob"]
  end

end