# coding: utf-8
require "fortitude"

module PrintableCalendar
  class View < Fortitude::Widget

    doctype(:html5)

    def initialize(settings, starts, ends, data)
      @settings = settings
      @starts = starts
      @ends = ends
      @data = data
    end

    def content
      grouped = @data.group_by{|e| e.start_time.to_date}

      html {
        head {
          meta(charset: "UTF-8")
          title(title_text)
          style(bootstrap)
          style(overrides)
        }
        body {
          div(class: "container"){
            h1(title_text)
            table(class: "table"){
              tbody {
                grouped.map { |starts, es|
                  tr {
                    td(format_date(starts, true), rowspan: es.count)
                    td("#{format_time(es.first.start_time)} – #{format_time(es.first.end_time)}")
                    td(es.first.title)
                  }
                  es.drop(1).map { |e|
                    tr {
                      td(style: "display: none")
                      td("#{format_time(e.start_time)} – #{format_time(e.end_time)}")
                      td(e.title)
                    }
                  }
                }
              }
            }
          }
        }
      }
    end

    def bootstrap
      File.read(File.expand_path("../../../vendor/bootstrap.min.css", __FILE__))
    end

    def overrides
      <<-eos
      tr {padding-bottom: 35px;}
      tr:nth-child(odd) {
        background-color: #eceeef !important;
        -webkit-print-color-adjust: exact !important;
      }
      tr:nth-child(odd) td[rowspan]{
        background-color: white !important;
        -webkit-print-color-adjust: exact !important;
      }
      eos
    end

    def title_text
      t = @settings[:title] || "Calendar"
      "#{t} for #{format_date(@starts, false)} – #{format_date(@ends, false)}"
    end

    def format_time(date_time)
      zone = Time.now.getlocal.zone
      date_time = DateTime.iso8601(date_time) if date_time.is_a?(String)
      date_time = date_time.in_time_zone(zone)
      date_time.strftime("%I:%M%P")
    end

    def format_date(date_time, show_day)
      date_time = Date.iso8601(date_time) if date_time.is_a?(String)
      date_time.strftime(show_day ? "%A, %b %d" : "%b %d")
    end
  end
end
