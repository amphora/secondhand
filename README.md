Secondhand
==========

Secondhand is a ruby-friendly wrapper around the [Quartz Job Scheduler][0].
Create jobs, tell Secondhand when they should run, then sit back and enjoy. 

_Secondhand is JRuby only what with Quartz being Java and all._


Overview
--------

Secondhand was created to:

* provide a clean API to job scheduling (with few, if any, dependencies)
* give you more control over job resource utilization/allocation 
* take advantage of the Quartz service

You can schedule jobs that will run right away, on a specific date, or use
a repeating schedule with a familiar cron syntax. Secondhand allows you to 
adjust the number of Quartz worker threads, and create jobs in a way that makes 
sense in your environment.

Secondhand does not try to be a full interface to all the power and
capabilities of Quartz. Think of it more like a nice subset that allows you
to have robust job scheduling without learning all about Quartz. (You can always
get to the underlying objects and tinker if you need to.)

Like Resque, Jobs in Secondhand can be any class or module that responds to 
`perform` and, like some of the other Quartz+Ruby libraries out there, a job 
can be a block/proc. (Secondhand jobs don't take parameters [yet].)


Workers 
-------

Quartz spawns worker threads to execute jobs when triggers are fired. Secondhand 
defaults to 5 workers as recommended in the Quartz documentation - while Quartz 
defaults to 10. Note: Quartz will block itself if all worker threads are busy 
when a trigger fires.


Jobs
----

A job in Secondhand might look like this:

    class Scan
      def self.perform # class method
        do_some_work
        log_it
        do_some_more_work
        close_connections
      end
    end

    # To run this job immediately you would use:

    Secondhand.schedule Scan


### OR

You can go with the block syntax for an immediate job:

    Secondhand.schedule :the_scan do
      do_some_work
      log_it
      do_some_more_work
      close_connections
    end

This scheduled job is added to the Quartz scheduler and associated with a 
trigger. In the case of the jobs above, the trigger is a `SimpleTrigger` that
executes immediately.

*Important* 
Each job must have a unique name. Secondhand calls #to_s on the first 
parameter and uses that for the job name. This means that you can't schedule the
same class twice [yet].

While the block syntax is nice to look at it does have some drawbacks. Object 
allocation happens when the block is created and references to these objects
are held for the lifetime of the block. In our case, this lifetime is while 
the Quartz service is running since the job is scheduled, stored, and called by 
a trigger. 

Having the ability to just schedule a class/module that responds to `perform` as
a job means that only a reference to that constant is held by the Quartz service
and object allocation happens when `perform` is executed. 

Thinking of these jobs as atomic units of work may help when deciding how they
should be scheduled in your application.

## Persisted Jobs

Secondhand just uses the default Quartz RAM job scheduler. This provides no 
durability for jobs to live after your application exists. It is up to you to 
make sure they get rescheduled.


Usage
-----

The scheduler must be started before you schedule jobs.

    Secondhand.start(NUM_THREADS)

Then you get to scheduling ...

... job that runs immediately after being scheduled:

    Secondhand.schedule JobClass

... block that runs immediately:

    Secondhand.schedule :some_job do
      # some job stuff
    end
  
... job that runs on Friday, Dec 10 at 11:53:35 PST:

    Secondhand.schedule JobClass, :at => "Fri Dec 10 22:53:35 -0800 2010" 

... job that runs two minutes from now:

    Secondhand.schedule JobClass, :at => Time.now + 120
  
... job that runs every 15 seconds every day:

    Secondhand.schedule JobClass, :with_cron => "0/15 * * * * ? *"
  
## :at

Pass in the :at options to provide a specific moment in time for a job to be 
triggered. This is useful when you want to run a job once - perhaps in response
to some user input.

## :with_cron

Use :with_cron to provide Secondhand with a cron expression that indicates when
a job should be triggered. This expression is passed straight to Quartz so all
options are supported. Just send in a string with the following format:

_From the Quartz CronExpression documentation:_

> Cron expressions are comprised of 6 required fields and one optional field 
> separated by white space. The fields respectively are described as follows:

    Field Name        Allowed Values    Allowed Special Characters

    Seconds           0-59              , - * /
    Minutes           0-59              , - * /
    Hours             0-23              , - * /
    Day-of-month      1-31              , - * ? / L W
    Month             1-12 or JAN-DEC   , - * /
    Day-of-Week       1-7 or SUN-SAT	 	, - * ? / L #
    Year (Optional)   empty, 1970-2199  , - * /
  
> The `*` character is used to specify all values. For example, "*" in the 
> minute field means "every minute".
> 
> The `?` character is allowed for the day-of-month and day-of-week fields. It 
> is used to specify 'no specific value'. This is useful when you need to 
> specify something in one of the two fields, but not the other.
> 
> The `-` character is used to specify ranges For example "10-12" in the hour 
> field means "the hours 10, 11 and 12".
> 
> The `,` character is used to specify additional values. For example 
> "MON,WED,FRI" in the day-of-week field means "the days Monday, Wednesday, 
> and Friday".
> 
> The `/` character is used to specify increments. For example "0/15" in the 
> seconds field means "the seconds 0, 15, 30, and 45". And "5/15" in the seconds 
> field means "the seconds 5, 20, 35, and 50". Specifying '*' before the '/' is 
> equivalent to specifying 0 is the value to start with. Essentially, for each 
> field in the expression, there is a set of numbers that can be turned on or 
> off. For seconds and minutes, the numbers range from 0 to 59. For hours 0 to 
> 23, for days of the month 0 to 31, and for months 1 to 12. The "/" character 
> simply helps you turn on every "nth" value in the given set. Thus "7/6" in the 
> month field only turns on month "7", it does NOT mean every 6th month, please 
> note that subtlety.
> 
> The `L` character is allowed for the day-of-month and day-of-week fields. This 
> character is short-hand for "last", but it has different meaning in each of 
> the two fields. For example, the value "L" in the day-of-month field means 
> "the last day of the month" - day 31 for January, day 28 for February on 
> non-leap years. 
> If used in the day-of-week field by itself, it simply means "7" or "SAT". But 
> if used in the day-of-week field after another value, it means "the last xxx 
> day of the month" - for example "6L" means "the last friday of the month". 
> When using the 'L' option, it is important not to specify lists, or ranges of 
> values, as you'll get confusing results.
> 
> The `W` character is allowed for the day-of-month field. This character is 
> used to specify the weekday (Monday-Friday) nearest the given day. As an 
> example, if you were to specify "15W" as the value for the day-of-month field, 
> the meaning is: "the nearest weekday to the 15th of the month". So if the 15th 
> is a Saturday, the trigger will fire on Friday the 14th. If the 15th is a 
> Sunday, the trigger will fire on Monday the 16th. If the 15th is a Tuesday, 
> then it will fire on Tuesday the 15th. However if you specify "1W" as the 
> value for day-of-month, and the 1st is a Saturday, the trigger will fire on 
> Monday the 3rd, as it will not 'jump' over the boundary of a month's days. 
> The 'W' character can only be specified when the day-of-month is a single day, 
> not a range or list of days.
> 
> The `L` and `W` characters can also be combined for the day-of-month 
> expression to yield `LW`, which translates to "last weekday of the month".
> 
> The `#` character is allowed for the day-of-week field. This character is used 
> to specify "the nth" XXX day of the month. For example, the value of "6#3" in 
> the day-of-week field means the third Friday of the month (day 6 = Friday and 
> "#3" = the 3rd one in the month). Other examples: "2#1" = the first Monday of 
> the month and "4#5" = the fifth Wednesday of the month. Note that if you 
> specify "#5" and there is not 5 of the given day-of-week in the month, then 
> no firing will occur that month. If the '#' character is used, there can only 
> be one expression in the day-of-week field ("3#1,6#3" is not valid, since 
> there are two expressions).
> 
> The legal characters and the names of months and days of the week are not case 
> sensitive.
> 
> NOTES:
> 
> Support for specifying both a day-of-week and a day-of-month value is not 
> complete (you'll need to use the '?' character in one of these fields).
> Overflowing ranges is supported - that is, having a larger number on the left 
> hand side than the right. You might do 22-2 to catch 10 o'clock at night until 
> 2 o'clock in the morning, or you might have NOV-FEB. It is very important to 
> note that overuse of overflowing ranges creates ranges that don't make sense 
> and no effort has been made to determine which interpretation CronExpression 
> chooses. An example would be "0 0 14-6 ? * FRI-MON".


Installation
------------

  Coming soon to a command line near you.
  

## Quartz

Version supported in this release: 1.8.4

_Other version may work, but the tests and jars included are for 1.8.4._

All the jars needed for Quartz are in `lib\quartz`. They are used by Secondhand
unless JRuby::Rack is detected. If JRuby::Rack is present, it is assumed that
you will have the jars under WEB-INF or get them on the classpath however you
choose to.


What's in a name?
----------------
Secondhand was inspired from several other Quartz+Ruby implementations:
  
  * quartz-jruby: <https://github.com/artha42/quartz-jruby>
  * jruby-quartz: <https://github.com/techwhizbang/jruby-quartz>
  
Chiefly, quartz-jruby demonstrated what was needed to get the Quartz JobFactory
replaced with a Ruby class and playing nicely with the other components. Thanks
vagmi!

The jobs were taken straight from Resque <https://github.com/defunkt/resque> as
well as some other flourishes here and there.

The project started as a fork of quartz-jruby so I figured it was a second-hand 
project and the clock reference wasn't bad either.


Contributors
------------

Don Morrison (@elskwid)


License
-------

Copyright (c) 2010 Amphora Research Systems Ltd.

Secondhand is licensed under the MIT license. See LICENSE for details.


[0]: http://www.quartz-scheduler.org/