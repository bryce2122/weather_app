RSpec.describe "forecasts/show", type: :view do
  context 'rendering the weather forecast form' do
    before do
      assign(:forecast, nil)
      assign(:location_name, nil)
      render
    end

    it 'displays the main container with title' do
      expect(rendered).to have_selector('.container h1', text: 'Weather Forecast')
    end

    it 'renders the weather forecast form' do
      expect(rendered).to have_selector("form[action='#{fetch_forecast_path}'][method='get']")
      expect(rendered).to have_selector('form label', text: 'Enter ZIP code or City:')
      expect(rendered).to have_selector('form input[type="text"][name="zipcode"]')
      expect(rendered).to have_selector('form input[type="submit"][value="Get Forecast"]')
    end

    it 'renders the turbo frame for weather results' do
      expect(rendered).to have_selector('turbo-frame#weather_results')
    end
  end

  context 'with forecast data present' do
    let(:forecast) do
      {
        current_temperature: 70,
        high_temperature: 80,
        low_temperature: 60
      }
    end

    before do
      assign(:forecast, forecast)
      assign(:location_name, 'New York')
      render
    end

    it 'renders the weather results partial within the turbo frame' do
      expect(rendered).to have_selector('turbo-frame#weather_results h2', text: 'Weather Forecast for New York')
    end
  end
end
