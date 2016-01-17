class NotamBuilder
  class << self
    def build(input_str)
      input_str.split(/\n\s*?\n/).map do |notam_str|
        Notam.new(
          icao:             extract_icao(notam_str),
          hours_of_service: extract_hours_of_service(notam_str)
        )
      end
    end

    def extract_icao(str)
      starts = str.index('A)') + 3
      ends   = str.index('B)') - 2
      str[starts..ends]
    end

    def extract_hours_of_service(str)
      str = hours_of_service_extract_str(str)
      str = hours_of_service_remove_leader(str)

      hos  = {}
      dow  = %w(MON TUE WED THU FRI SAT SUN)
      dows = %i(monday tuesday wednesday thursday friday saturday sunday)

      # single day
      dow.each_with_index do |day, index|
        match = str.match(/#{day} ?([\d+\s-]+)/)
        next unless match

        time_str = match[1].chomp.strip
        next if time_str.empty?

        hos[dows[index]] = time_str
      end

      # multi-day
      dow.each_with_index do |start_day, start_index|
        dow.each_with_index do |end_day, end_index|
          next if start_day == end_day

          match = str.match(/#{start_day}-#{end_day} ?([\d+\s-]+)/)
          next unless match

          time_str = match[1].chomp.strip
          next if time_str.empty?

          dows[start_index..end_index].each do |day|
            hos[day] = time_str
          end
        end
      end

      hos
    end

    private

    def hours_of_service_extract_str(str)
      starts = str.index('E)')

      return '' unless starts

      starts = starts + 3
      ends   = str.index('F)') ? str.index('F)') - 2 : str.length
      str[starts..ends]
    end

    def hours_of_service_remove_leader(str)
      str.sub(/^.*SERVICE:?/, '')
    end
  end
end