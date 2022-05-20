require_relative 'meeting_scheduler'
require_relative 'helper'

# Entry point to schedule meetings
puts MeetingScheduler.new(meetings1).schedule
puts MeetingScheduler.new(meetings2).schedule
puts MeetingScheduler.new(meetings3).schedule
