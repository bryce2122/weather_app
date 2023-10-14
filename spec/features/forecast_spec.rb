RSpec.feature "Forecasts", type: :feature do
  before do
    visit forecast_path
  end

  scenario "visiting the forecast page" do
    expect(page).to have_content("Weather Forecast")
    expect(page).to have_content("Enter ZIP code:")
    expect(page).to have_button("Get Forecast")
  end

  context "with valid zipcode input" do
    before do
      allow(GeocodingService).to receive(:fetch_coordinates).and_return({latitude: 40.7128, longitude: -74.0060}) # Mocks coordinates for New York
      allow(WeatherService).to receive(:fetch_forecast).and_return({current_temperature: 72, high_temperature: 75, low_temperature: 69}) # Mock weather data
    end

    scenario "displaying forecast results" do
      fill_in "zipcode", with: "37405"
      click_button "Get Forecast"

      expect(page).to have_content("Weather Forecast for 37405")
      expect(page).to have_content("Current Temperature: 72°F")
      expect(page).to have_content("High: 75°F")
      expect(page).to have_content("Low: 69°F")
    end
  end

  context "with invalid zipcode input" do
    before do
      allow(GeocodingService).to receive(:fetch_coordinates).and_return(nil) # Mocks no coordinates found
    end

    scenario "displaying error message" do
      fill_in "zipcode", with: "Invalid Zipcode"
      click_button "Get Forecast"

      expect(page).to have_content("Invalid ZIP code. Please try again.")
    end
  end
end
