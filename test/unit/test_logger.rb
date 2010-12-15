require File.dirname(__FILE__) + '/../test_helper'

class TestLogger < Test::Unit::TestCase

  class IncludeLogger
    include Secondhand::Logger
  end

  class ExtendLogger
    extend Secondhand::Logger
  end

  def setup
  end

  def test_included_logger
    inst = IncludeLogger.new
    assert inst.respond_to?(:logger)
    assert inst.respond_to?(:warn)
  end
  
  def test_extended_logger    
    klass = ExtendLogger
    assert klass.respond_to?(:logger)
    assert klass.respond_to?(:error)    
  end
  
end

