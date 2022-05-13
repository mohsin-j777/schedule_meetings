# meeting_scheduler.rb

Class created for scheduling both onsite and offsite meetings

schedule method is define to schedule both meetings

The approach I've implemented is first I've scheduled on site meetings and then offsite_meetings
to get out one of the possible scheduling outcomes.

# errors.rb

Custom ScheduleError class is defined in this module to raise if one of the before scheduling validations fails
or it is not possible to schedule meetings within durations during scheduling

# constants.rb

As meeting types are constant and not changing therefore it is defined as constant and being used in MeetingScheduler class

# helper.rb

It contains input defined in the task

# main.rb

It is an entry point that would be executed to check output against input from helper.rb
to run it `ruby main.rb` inside the schedule_meetings directory

# tc_meeting_scheduler.rb

Mini test cases are written to give test coverage against our MeetingScheduler class
to run it `ruby tc_meeting_scheduler.rb` inside the schedule_meetings directory
