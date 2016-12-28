require "date"
require "active_support"
require "active_support/all"

module PrintableCalendar
  class Range

    def self.range_map
      {
        work_week: ->(t){[t.beginning_of_week(:monday), t.beginning_of_week(:monday) + 4]},
        american_week: ->(t){[t.beginning_of_week(:sunday), t.end_of_week(:sunday)]},
        intl_week: ->(t){[t.beginning_of_week(:monday), t.end_of_week(:sunday)]},
        month: ->(t){[t.beginning_of_month, t.end_of_month]},
        day: ->(t){[t, t]}
      }
    end

    def self.supported_periods
      range_map.keys.map{|k| k.to_s}
    end

    def self.compute(period, startingFrom)
      t = startingFrom

      mapper = range_map[period.to_sym]

      abort "Unknown period #{period}. Use one of {#{supported_periods.join(", ")}}" unless mapper

      s, e = mapper.(t)
      [s.beginning_of_day, e.end_of_day]
    end
  end
end
