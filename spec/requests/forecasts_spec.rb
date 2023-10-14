RSpec.describe "Forecasts", type: :request do
  describe 'GET #show' do
    let(:zipcode) { '37375' }

    context 'with a valid zipcode' do
      before do
        # Stubbing to return valid coordinates
        allow(GeocodingService).to receive(:fetch_coordinates).with(zipcode).and_return({
          latitude: 40.7143528,
          longitude: -74.0059731
        })

        # Stubbing to return some mocked forecast data
        allow(WeatherService).to receive(:fetch_forecast).with(40.7143528, -74.0059731).and_return({
          current_temperature: 72,
          high_temperature: 80,
          low_temperature: 65
        })

        get forecast_path, params: { zipcode: zipcode }
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end

      it 'renders the correct view' do
        expect(response).to render_template(:show)
      end

      it 'returns correct forecast data in the HTML response body' do
        expect(response.body).to include("37375")
        expect(response.body).to include("<strong>Current Temperature:</strong> 72°F")
        expect(response.body).to include("<strong>High:</strong> 80°F")
        expect(response.body).to include("<strong>Low:</strong> 65°F")
      end
    end

    context 'with an invalid zipcode' do
      before do
        # Stubbing to return nil coordinates for invalid address
        allow(GeocodingService).to receive(:fetch_coordinates).with(zipcode).and_return(nil)

        get forecast_path, params: { zipcode: zipcode }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'sets an error flash message' do
        expect(flash[:error]).to eq("Invalid ZIP code. Please try again.")
      end
    end
  end
end
