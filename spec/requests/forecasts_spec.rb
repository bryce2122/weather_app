RSpec.describe "Forecasts", type: :request do

  describe 'GET #show' do
    it 'returns a successful response' do
      get forecast_path
      expect(response).to be_successful
    end
  end

  describe 'GET #search' do
    let(:query) { '10001' }

    context 'with a valid query' do
      let(:coordinates) { [{ "display_name" => "New York, NY", "latitude" => 40.7128, "longitude" => -74.0060 }] }

      before do
        allow(GeocodingService).to receive(:fetch_coordinates).with(query).and_return(coordinates)
        get search_path, params: { query: query }, xhr: true
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns coordinates in JSON format' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to eq({ "coordinates" => coordinates, "error" => nil })
      end
    end

    context 'with an invalid query' do
      before do
        allow(GeocodingService).to receive(:fetch_coordinates).with(query).and_return(nil)
        get search_path, params: { query: query }, xhr: true
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message in JSON format' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to eq({ "coordinates" => nil, "error" => "Invalid ZIP code. Please try again." })
      end
    end
  end

  describe 'GET #fetch_forecast' do
    let(:selected_coordinates) { { display_name: "New York, NY", latitude: 40.7128, longitude: -74.0060 }.to_json }
    let(:forecast_data) { { current_temperature: 72, high_temperature: 75, low_temperature: 69 } }

    context 'with valid coordinates' do
      before do
        allow(WeatherService).to receive(:fetch_forecast).and_return(forecast_data)
        get fetch_forecast_path, params: { selected_coordinates: selected_coordinates }
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end

      it 'sets the address instance variable' do
        expect(assigns(:location_name)).to eq("New York, NY")
      end

      it 'sets the forecast instance variable' do
        expect(assigns(:forecast)).to eq(forecast_data)
      end
    end

    context 'when an exception is raised' do
      before do
        allow(WeatherService).to receive(:fetch_forecast).and_raise(StandardError.new("Some error"))
        get fetch_forecast_path, params: { selected_coordinates: selected_coordinates }
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq("Sorry, something has gone wrong. Please try again")
      end
    end
  end
end
