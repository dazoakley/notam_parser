require 'rails_helper'

RSpec.describe NotamBuilder do
  subject { described_class }

  let(:test_str) do
    <<-EOF
B0508/15 NOTAMN
Q) ESAA/QFAAH/IV/NBO/A /000/999/5746N01404E005
A) ESGJ B) 1503020000 C) 1503222359
E) AERODROME HOURS OF OPS/SERVICE MON CLSD TUE-THU 0500-2100
FRI
0545-2100 SAT0630-0730 1900-2100 SUN 1215-2000
CREATED: 26 Feb 2015 10:54:00
SOURCE: EUECYIYN
    EOF
  end

  describe '.build' do
    context 'given a single NOTAM string' do
      it 'will build one Notam object' do
        expect(Notam).to receive(:new).once
        subject.build(test_str)
      end

      it 'will return an array with one Notam object' do
        result = subject.build(test_str)
        expect(result).to be_a(Array)
        expect(result.length).to eq(1)
        expect(result.first).to be_a(Notam)
      end
    end

    context 'given multiple NOTAM strings' do
      let(:test_str) do
        <<-EOF
B0343/15 NOTAMN
Q) ESAA/QSTAH/IV/BO /A /000/999/5641N01249E005
A) ESMT B) 1503090000 C) 1503152359
E) AERODROME CONTROL TOWER (TWR) HOURS OF OPS/SERVICE
MON-TUE 0430-1900 WED 0430-2055 THU 0430-2105 FRI 0530-2055 SAT CLSD
SUN 1305-1335, 1535-2005
CREATED: 10 Feb 2015 10:38:00
SOURCE: EUECYIYN

B0342/15 NOTAMN
Q) ESAA/QSTAH/IV/BO /A /000/999/5641N01249E005
A) ESMA B) 1503020000 C) 1503082359
E) AERODROME CONTROL TOWER (TWR) HOURS OF OPS/SERVICE
MON-WED 0430-1900 THU 0530-2105 FRI 0530-1830 SAT CLSD
SUN 1615-2005
CREATED: 10 Feb 2015 10:35:00
SOURCE: EUECYIYN
        EOF
      end

      it 'will build multiple Notam objects' do
        expect(Notam).to receive(:new).twice
        subject.build(test_str)
      end

      it 'will return an array with two Notam objects' do
        result = subject.build(test_str)
        expect(result).to be_a(Array)
        expect(result.length).to eq(2)
        expect(result.first).to be_a(Notam)
        expect(result.second).to be_a(Notam)
      end
    end
  end

  describe '.extract_icao' do
    it 'extracts the correct ICAO value' do
      expect(subject.extract_icao(test_str)).to eq('ESGJ')
    end
  end

  describe '.extract_hours_of_service' do
    it 'extracts the hourse of service correctly' do
      expected = {
        tuesday:   '0500-2100',
        wednesday: '0500-2100',
        thursday:  '0500-2100',
        friday:    '0545-2100',
        saturday:  '0630-0730 1900-2100',
        sunday:    '1215-2000'
      }

      expect(subject.extract_hours_of_service(test_str)).to eq(expected)
    end
  end
end
