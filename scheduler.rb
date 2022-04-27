require 'active_support/time'

class ScheduleError < StandardError
  def initialize(msg="No, can't fit.")
    super
  end
end


def schedule(meetings)
  puts

  begin
    can_schedule_meetings?(meetings)

    puts schedule_meetings(meetings)
  rescue ScheduleError => e
    puts "#{e.message}"
  end
end

def can_schedule_meetings?(meetings)
  relevant_meetings = meetings.select { |meeting| meeting[:type] == :onsite || meeting[:type] == :offsite }
  durations = relevant_meetings.map { |meeting| meeting[:duration] }
  invalid_duration = durations.find(&:negative?)
  
  raise ScheduleError.new if invalid_duration || durations.sum > 8 || relevant_meetings.length != meetings.length

  true
end

def schedule_meetings(meetings)
  onsite_meetings, offsite_meetings = meetings.partition { |meeting| meeting[:type] == :onsite }

  scheduled_meetings = []

  time = Time.now.beginning_of_day.advance(hours: 9, minutes: 0, seconds: 0)
  start_time = time

  total_hours = 8
  
  onsite_meetings.each do |meeting|
    end_time = start_time + meeting[:duration].hours
    total_hours -= meeting[:duration]

    scheduled_meetings << formatted_meeting(start_time, end_time, meeting)

    raise ScheduleError.new if total_hours.negative?

    start_time = end_time
  end

  offsite_meetings.each do |meeting|
    start_time += 30.minutes

    end_time = start_time + meeting[:duration].hours
    total_hours = total_hours - 0.5 - meeting[:duration]

    raise ScheduleError.new if total_hours.negative?

    scheduled_meetings << formatted_meeting(start_time, end_time, meeting)

    start_time = end_time
  end

  scheduled_meetings
end

def formatted_meeting(start_time, end_time, meeting)
  "#{start_time.strftime('%l:%M').strip} - #{end_time.strftime('%l:%M').strip} - #{meeting[:name]}"
end

# Running point

meetings1 = [
  { name: "Meeting 1", duration: 3, type: :onsite },
  { name: "Meeting 2", duration: 2, type: :offsite },
  { name: "Meeting 3", duration: 1, type: :offsite },
  { name: "Meeting 4", duration: 0.5, type: :onsite }
]

meetings2 = [
  { name: "Meeting 1", duration: 1.5, type: :onsite },
  { name: "Meeting 2", duration: 2, type: :offsite },
  { name: "Meeting 3", duration: 1, type: :onsite },
  { name: "Meeting 4", duration: 1, type: :offsite },
  { name: "Meeting 5", duration: 1, type: :offsite },
]

meetings3 = [
  { name: "Meeting 1", duration: 4, type: :offsite },
  { name: "Meeting 2", duration: 4, type: :offsite }
]

schedule(meetings1)
schedule(meetings2)
schedule(meetings3)