RSpec.feature "Forecasts", type: :feature, js: true do
  before do
    stub_request(:get, "http://api.weather.com/some_endpoint")
     .with(query: {zipcode: '37405'})
     .to_return(
       status: 200,
       body: '{"current_temperature":72,"high_temperature":75,"low_temperature":69}',
       headers: {"Content-Type" => "application/json"}
     )
    visit forecast_path
  end

  scenario "visiting the forecast page" do
    expect(page).to have_content("Weather Forecast")
    expect(page).to have_content("Enter ZIP code or City:")
    expect(page).to have_button("Get Forecast")
  end

  context "with valid zipcode input" do
    let(:coordinates) { [{"display_name" => "New York, NY", "latitude" => 40.7128, "longitude" => -74.0060}.to_json] }
    let(:weather_data) { {current_temperature: 72, high_temperature: 75, low_temperature: 69} }

    before do
      allow(GeocodingService).to receive(:fetch_coordinates).and_return(coordinates)
      allow(WeatherService).to receive(:fetch_forecast).and_return(weather_data)
    end

    scenario "selecting a ZIP code from the dropdown and viewing forecast" do
      fill_in "zipcode", with: "10001" # New York ZIP code
      sleep 1
      expect(page).to have_content("New York, NY", wait: 5)
      within '.results-list' do
        find('li', text: 'New York, NY').click
      end

      click_button "Get Forecast"

      expect(page).to have_content("Weather Forecast for New York, NY")
      expect(page).to have_content("Current Temperature: #{weather_data[:current_temperature]}°F")
      expect(page).to have_content("High: #{weather_data[:high_temperature]}°F")
      expect(page).to have_content("Low: #{weather_data[:low_temperature]}°F")
    end
  end

  context "with non-matching zipcode input" do
    before do
      allow(GeocodingService).to receive(:fetch_coordinates).and_return([])
    end

    scenario "no dropdown appears for an invalid ZIP code" do
      fill_in "zipcode", with: "Invalid Zipcode"

      # Check that an element does NOT appear within a certain time frame.
      expect(page).not_to have_selector('.results-list li', wait: 5)
    end
  end
end
