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
      assign(:zipcode, '37375')
      render partial: 'forecasts/weather_results', locals: { forecast: forecast, zipcode: '37375' }
    end

    it 'displays the forecast for the given address' do
      expect(rendered).to have_content('Weather Forecast for 37375')
      expect(rendered).to have_content('Current Temperature: 70°F')
      expect(rendered).to have_content('High: 80°F')
      expect(rendered).to have_content('Low: 60°F')
    end
  end

  context 'when forecast is not present' do
    before do
      assign(:forecast, nil)
      render partial: 'forecasts/weather_results', locals: { forecast: nil, address: nil }
    end

    it 'prompts the user to enter an address or ZIP code' do
      expect(rendered).to have_content('Please enter a ZIP code to retrieve the weather forecast.')
    end
  end
end
