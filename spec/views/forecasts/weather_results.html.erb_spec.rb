RSpec.describe "weather_results", type: :view do
  context 'when forecast is present' do
    let(:forecast) do
      {
        current_temperature: 70,
        high_temperature: 80,
        low_temperature: 60
      }
    end

    before do
      assign(:forecast, forecast)
      assign(:address, '37375')
      render partial: 'forecasts/weather_results', locals: { forecast: forecast, location_name: 'New York' }
    end

    it 'displays the forecast for the given address' do
      expect(rendered).to have_content('Weather Forecast for New York')
      expect(rendered).to have_content('Current Temperature: 70°F')
      expect(rendered).to have_content('High: 80°F')
      expect(rendered).to have_content('Low: 60°F')
    end
  end
end
