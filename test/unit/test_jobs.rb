require File.dirname(__FILE__) + '/../test_helper'

class TestJobs < Test::Unit::TestCase
  
  def setup
    Secondhand.start(1)
  end
  
  def test_bracket_method
    # jobs aren't in this list until they are scheduled - quartz limitation
    Secondhand.schedule TestSimpleJob
    assert_equal TestSimpleJob, Secondhand::Jobs["TestSimpleJob"]
  end
  
  def test_names
    Secondhand.schedule TestSimpleJob2
    assert Secondhand::Jobs.names.include?("TestSimpleJob2")
  end
    
end