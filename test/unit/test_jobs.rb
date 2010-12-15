require File.dirname(__FILE__) + '/../test_helper'

class TestJobs < Test::Unit::TestCase
  
  class SimpleJob
    def self.perform
      "TestJobs"
    end
  end
  
  class SimpleJob2 < SimpleJob; end
  
  def setup
    Secondhand.start(1)
  end
  
  def test_bracket_method
    # jobs aren't in this list until they are scheduled - quartz limitation
    Secondhand.schedule TestJobs::SimpleJob
    assert_equal TestJobs::SimpleJob, Secondhand::Jobs["TestJobs::SimpleJob"]
  end
  
  def test_names
    Secondhand.schedule TestJobs::SimpleJob2
    assert Secondhand::Jobs.names.include?("TestJobs::SimpleJob2")
  end
    
end