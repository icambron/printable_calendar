require "google_calendar"

module PrintableCalendar

  class Calendar

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
    end

    def auth
      cal = Google::Calendar.new(client_id: @client_id, client_secret: @client_secret, redirect_url: "urn:ietf:wg:oauth:2.0:oob")

      puts "Visit the following web page in your browser and approve access."
      puts cal.authorize_url
      puts "\nCopy the code that Google returned and paste it here:"

      refresh_token = cal.login_with_auth_code($stdin.gets.chomp)

      puts "Your refresh token is:\n\t#{refresh_token}\n. Copy that into your JSON config file."
    end


    def fetch(starts:, ends:, refresh_token:, calendar_ids: )
      calendar_ids.map do |id|
        client = Google::Calendar.new(client_id: @client_id, client_secret: @client_secret, refresh_token: refresh_token, calendar: id)
        client.find_events_in_range(starts, ends)
      end.flatten.sort{|a, b| a.start_time <=> b.end_time}
    end

  end
end
