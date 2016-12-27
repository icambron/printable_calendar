require "json"
require "tempfile"
require "launchy"
require_relative "range"
require_relative "calendar"
require_relative "view"

module PrintableCalendar
  class PrintableCalendar

    def initialize(settings)
      @settings = settings
    end

    def generate_auth
      Calendar.new(client_id, client_secret).auth
    end

    def run
      starts, ends = Range.compute(@settings[:period] || "workweek", @settings[:starting_from] || Date.today)
      data = Calendar.new(client_id, client_secret).fetch(starts: starts, ends: ends, refresh_token: refresh_token, calendar_ids: calendar_ids)
      html = View.new(@settings, starts, ends, data).to_html
      tempfile = write_tempfile(html)
      launch_file(tempfile)
    end

    def client_id
      @settings[:client_id] || ENV["PRINTABLE_CALENDAR_CLIENT_ID"] || abort("No Google client ID specified")
    end

    def client_secret
      @settings[:client_secret] || ENV["PRINTABLE_CALENDAR_CLIENT_SECRET"] || abort("No Google client secret specified")
    end

    def refresh_token
      @settings[:refresh_token] || ENV["PRINTABLE_CALENDAR_REFRESH_TOKEN"] || abort("No Google refresh token found")
    end

    def calendar_ids
      @settings[:calendar_ids] || abort("No calendars specified")
    end

    def write_tempfile(html)
      #there has to be a better way to do this
      path = nil
      begin
        temp = Tempfile.new("printable_calendar")
        path = temp.path
        temp.close
        temp.unlink

        File.open(path, 'w'){|f| f.write(html)}
        path
      ensure
        temp.close
        temp.unlink
      end

      path

    end

    def launch_file(path)
      if path
        Launchy.open("file://#{path}")
      else
        abort("Failed to generate file")
      end
    end
  end
end
