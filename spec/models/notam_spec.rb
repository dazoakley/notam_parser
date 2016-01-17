require 'rails_helper'

RSpec.describe Notam do
  subject { described_class.new(attrs) }

  describe '#icao' do
    let(:attrs) { { icao: 'ESGJ' } }

    it 'should return the ICAO code' do
      expect(subject.icao).to eq('ESGJ')
    end
  end

  describe '#hours_of_service' do
    let(:hours_of_service) { { monday: '09:00-17:00', wednesday: '12:00-17:00' } }
    let(:attrs)            { { icao: 'ESGJ', hours_of_service: hours_of_service } }

    it 'should return the hours of service' do
      expected = hours_of_service.merge(tuesday:  'CLOSED',
                                        thursday: 'CLOSED',
                                        friday:   'CLOSED',
                                        saturday: 'CLOSED',
                                        sunday:   'CLOSED')

      expect(subject.hours_of_service).to eq(expected)
    end
  end
end
