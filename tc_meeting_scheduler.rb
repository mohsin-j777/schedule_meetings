require "test/unit"
require 'minitest/autorun'

require_relative "meeting_scheduler"

class TestMeetingScheduler < Minitest::Test
  # overall hours are considered to be 8 as for now as per 9 to 5 schedule

  def test_shouldnot_schedule_when_offsite_occupies_complete_hours
    meetings = [
      {name: 'Meeting1', duration: 4, type: :offsite},
      {name: 'Meeting2', duration: 4, type: :offsite}
    ]

    assert_equal("No, can't fit.", MeetingScheduler.new(meetings).schedule)
  end

  def test_returns_scheduled_meetings_when_offsite_doesnot_occupy_overall_hours
    meetings = [
      {name: 'Meeting1', duration: 4, type: :offsite},
      {name: 'Meeting2', duration: 3, type: :offsite}
    ]

    assert_kind_of(Array, MeetingScheduler.new(meetings).schedule)
  end

  def test_should_schedule_when_onsite_occupies_overall_hours
    meetings = [
      {name: 'Meeting1', duration: 4, type: :onsite},
      {name: 'Meeting2', duration: 4, type: :onsite}
    ]

    assert_kind_of(Array, MeetingScheduler.new(meetings).schedule)
  end

  def test_shouldnot_schedule_when_duration_exceeds_overall_hours
    meetings = [
      {name: 'Meeting1', duration: 4, type: :offsite},
      {name: 'Meeting2', duration: 5, type: :onsite}
    ]

    assert_equal("No, can't fit.", MeetingScheduler.new(meetings).schedule)
  end

  def test_should_schedule_when_have_both_type_of_meetings_inside_durations
    meetings = [
      { name: "Meeting 1", duration: 3, type: :onsite },
      { name: "Meeting 2", duration: 2, type: :offsite },
      { name: "Meeting 3", duration: 1, type: :offsite },
      { name: "Meeting 4", duration: 0.5, type: :onsite }
    ]

    assert_kind_of(Array, MeetingScheduler.new(meetings).schedule)
  end

  def test_should_not_schedule_when_meetings_contain_invalid_duration
    meetings = [
      {name: 'Meeting1', duration: -4, type: :offsite},
      {name: 'Meeting2', duration: 2, type: :onsite}
    ]

    assert_equal("No, can't fit.", MeetingScheduler.new(meetings).schedule)
  end

  def test_should_not_schedule_when_meetings_contain_invalid_type
    meetings = [
      {name: 'Meeting1', duration: 4, type: :offsite},
      {name: 'Meeting2', duration: 0.5, type: :onsite},
      {name: 'Meeting3', duration: 0.5, type: :walkin}
    ]

    assert_equal("No, can't fit.", MeetingScheduler.new(meetings).schedule)
  end
end
