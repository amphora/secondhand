require File.dirname(__FILE__) + '/../test_helper'

class TestJob < Test::Unit::TestCase
  
  def setup
    Secondhand.start(1)
    @factory = Secondhand::Job::Factory.instance    
  end

  def test_simple_job_details
    details = Secondhand::Job.create "TestSimpleJob2", TestSimpleJob2
    assert_kind_of Java::OrgQuartz::JobDetail, details
    assert_equal TestSimpleJob2, details.job
  end

  def test_simple_class_job
    details = Secondhand::Job.create "TestSimpleJob", TestSimpleJob
    assert_equal TestSimpleJob, details.job
  end
  
  def test_simple_named_job_block
    details = Secondhand::Job.create "some_job", Proc.new{"Some job text"}
    assert_equal "Some job text", details.job.call
  end
  
  def test_runner_module_on_class
    details = Secondhand::Job.create "TestSimpleJob2", TestSimpleJob2
    assert details.job.respond_to?(:execute)
  end
  
  def test_runner_module_on_block
    details = Secondhand::Job.create "some_other_job", Proc.new{"Some other job text"}    
    assert details.job.respond_to?(:execute)
  end

  # job factory tests
  def test_kind_of
    assert_kind_of Java::OrgQuartz::spi::JobFactory, @factory
    assert_kind_of Secondhand::Job::Factory, @factory
  end
  
  def test_respond_to_new_job
    assert @factory.respond_to?(:new_job)
  end
end