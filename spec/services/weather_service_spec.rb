RSpec.describe WeatherService, type: :service do
  describe '.fetch_forecast' do
    let(:latitude) { 40.7128 }
    let(:longitude) { -74.0060 }
    let(:forecast) { described_class.fetch_forecast(latitude, longitude) }

    before do
      stub_request(:get, /api.openweathermap.org/)
        .to_return(body: sample_response.to_json)
    end

    let(:sample_response) do
      {
        'main' => {
          'temp' => 273.15, # 32 F
          'temp_max' => 275.15, # 35.6 F
          'temp_min' => 271.15 # 28.4 F
        }
      }
    end

    it 'retrieves the forecast from the API' do
      forecast
      expect(a_request(:get, /api.openweathermap.org/)).to have_been_made.once
    end

    it 'returns the correctly formatted forecast' do
      expect(forecast).to eq({
        current_temperature: 32.0,
        high_temperature: 35.6,
        low_temperature: 28.4
      })
    end

    context 'when caching' do
      it 'caches the result' do
        allow(Rails.cache).to receive(:fetch).and_call_original
        forecast
        expect(Rails.cache).to have_received(:fetch).with("forecast_data_#{latitude}_#{longitude}", expires_in: 30.minutes)
      end
    end
  end

  describe '#convert_to_fahrenheit' do
    let(:service) { described_class.new(40.7128, -74.0060) }

    it 'converts Kelvin to Fahrenheit correctly' do
      expect(service.send(:convert_to_fahrenheit, 273.15)).to eq(32.00)
      expect(service.send(:convert_to_fahrenheit, 0)).to eq(-459.67)
    end
  end
end
