class Notam
  attr_reader :icao, :hours_of_service

  def initialize(icao:, hours_of_service: {})
    @icao             = icao
    @hours_of_service = process_hours_of_service(hours_of_service)
  end

  private

  def process_hours_of_service(input_hos)
    hos = Hash.new('CLOSED')

    %i(monday tuesday wednesday thursday friday saturday sunday).each do |day|
      hos[day] = input_hos[day] || 'CLOSED'
    end

    hos
  end
end
