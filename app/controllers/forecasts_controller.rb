class ForecastsController < ApplicationController
  def show
    coordinates = JSON.parse(params[:selected_coordinates])
    @forecast = fetch_weather_forecast(coordinates)
  rescue => error
    Rails.logger.error("Error in ForecastsController#show: #{error.message}")
    flash[:error] = "Sorry, something has gone wrong. Please try again"
  end

  def search
    @zipcode = params[:query]
    coordinates = fetch_coordinates

    if coordinates
      render json: { coordinates: coordinates, error: nil }
    else
      render json: { coordinates: nil, error: "Invalid ZIP code. Please try again." }, status: :bad_request
    end
  end

  private

  def fetch_weather_forecast(coordinates)
     WeatherService.fetch_forecast(coordinates["latitude"], coordinates["longitude"])
  end

  def fetch_coordinates
    GeocodingService.fetch_coordinates(@zipcode)
  end

  def forecast_params
    params.permit(:zipcode, :query, :selected_coordinates)
  end
end
