require 'rails_helper'

RSpec.describe NotamController, type: :controller do
  describe '#index' do
    it 'returns a 200' do
      get :index
      expect(response).to be_success
    end
  end

  describe '#results' do
    render_views

    let(:notam) do
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


    it 'passes the NOTAMs onto the NotamBuilder' do
      expect(NotamBuilder).to receive(:build).with(notam).and_call_original
      post :results, notam: notam
    end

    it 'renders the ICAO in the view' do
      post :results, notam: notam
      expect(response.body).to include('ESGJ')
    end
  end
end
