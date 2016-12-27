require "date"
require "active_support"
require "active_support/all"

module PrintableCalendar
  class Range

    def self.compute(period, startingFrom)
      t = startingFrom
      s, e = case period
             when "workweek"
               monday = t.beginning_of_week(:monday)
               [monday, monday + 4]
             when "americanweek"
               [t.beginning_of_week(:sunday), t.end_of_week(:sunday)]
             when "intlweek"
               [t.beginning_of_week(:monday), t.end_of_week(:sunday)]
             when "month"
               [t.beginning_of_month, t.end_of_month]
             else
               abort("Period must be one of 'workweek', 'americanweek', 'intlweek', or 'month'")
             end
      [s.beginning_of_day, e.end_of_day]
    end
  end
end
