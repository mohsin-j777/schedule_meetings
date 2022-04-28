require 'active_support/time'

require_relative 'errors'
require_relative 'constants'

class MeetingScheduler
  attr_reader :meetings, :onsite_meetings, :offsite_meetings,
              :scheduled_meetings, :total_hours, :start_time

  def initialize(meetings, start_time = nil, total_hours = nil)
    @meetings = meetings
  
    @onsite_meetings, @offsite_meetings = meetings.partition { |meeting| meeting[:type].eql?(ON_SITE) }

    @total_hours = total_hours || 8
    @start_time = start_time || Time.now.beginning_of_day.advance(hours: 9, minutes: 0, seconds: 0)
    @scheduled_meetings = []
  end

  def schedule
    begin
      puts "\n"

      can_schedule_meetings?

      schedule_onsite_meetings
      schedule_offsite_meetings

      scheduled_meetings
    rescue Errors::ScheduleError => e
      "#{e.message}"
    end
  end

  private

  def can_schedule_meetings?
    relevant_meetings = meetings.select { |meeting| meeting[:type].eql?(ON_SITE) || meeting[:type].eql?(OFF_SITE) }
    durations = relevant_meetings.map { |meeting| meeting[:duration] }
    invalid_duration = durations.find(&:negative?)
    
    raise Errors::ScheduleError.new if invalid_duration || durations.sum > 8 || relevant_meetings.length != meetings.length

    true
  end

  def schedule_onsite_meetings
    onsite_meetings.each do |meeting|
      @end_time = start_time + meeting[:duration].hours
      @total_hours -= meeting[:duration]

      raise Errors::ScheduleError.new if total_hours.negative?

      @scheduled_meetings << formatted_meeting_output(meeting)

      @start_time = @end_time
    end
  end

  def schedule_offsite_meetings
    offsite_meetings.each do |meeting|
      @start_time += gap_in_offsite_meetings

      @end_time = start_time + meeting[:duration].hours
      @total_hours = total_hours - gap_in_duration_from_offsite_meetings - meeting[:duration]

      raise Errors::ScheduleError.new if total_hours.negative?

      @scheduled_meetings << formatted_meeting_output(meeting)

      @start_time = @end_time
    end
  end

  def gap_in_offsite_meetings
    30.minutes
  end

  def gap_in_duration_from_offsite_meetings
    gap_in_offsite_meetings / 3600.to_f
  end

  def formatted_meeting_output(meeting)
    "#{@start_time.strftime('%l:%M').strip} - #{@end_time.strftime('%l:%M').strip} - #{meeting[:name]}"
  end
end
