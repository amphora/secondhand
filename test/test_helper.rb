$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "/../lib"))

require 'test/unit'
require 'time'

# project
require 'secondhand'

# BasicConfigurator.configure uses a ConsoleAppender by default
# uncomment to see all the Quartz logging magic!
# org.apache.log4j.BasicConfigurator.configure

## NullAppender silences log4j messages
import org.apache.log4j.varia.NullAppender
org.apache.log4j.BasicConfigurator.configure(NullAppender.new)

module TestHelper
  #
end

class Test::Unit::TestCase
  include TestHelper
end