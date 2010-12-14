require File.dirname(__FILE__) + '/../test_helper'

class TestTrigger < Test::Unit::TestCase
  
  def setup
  end

  def test_at
    date = "Dec 10 22:53:35 -0800 2011"
    sched = Secondhand::Trigger.create("some_job", :at => Time.parse(date))
    assert_kind_of Java::OrgQuartz::SimpleTrigger, sched
    assert_equal Time.parse(date), Time.parse(sched.get_start_time.to_s)
  end
  
  def test_with_cron
    exp = "0 0 12 * * ? *"
    sched = Secondhand::Trigger.create("some_cronjob", :with_cron => exp)
    assert_kind_of Java::OrgQuartz::CronTrigger, sched
    assert_equal exp, sched.get_cron_expression
  end
  
end
