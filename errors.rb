module Errors
  class ScheduleError < StandardError
    def initialize(msg="No, can't fit.")
      super
    end
  end
end