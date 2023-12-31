class ForecastsController < ApplicationController
  def fetch_forecast
    coordinates = JSON.parse(params[:selected_coordinates])
    @location_name = coordinates["display_name"]
    @forecast = fetch_weather_forecast(coordinates)
  rescue => error
    Rails.logger.error("Error in ForecastsController#fetch_forecast: #{error.message}")
    flash[:error] = "Sorry, something has gone wrong. Please try again"
  end

  def search
    coordinates = GeocodingService.fetch_coordinates(params[:query])

    if coordinates
      render json: { coordinates: coordinates, error: nil }
    else
      render json: { coordinates: nil, error: "Invalid ZIP code or City. Please try again." }, status: :bad_request
    end
  end

  private

  def fetch_weather_forecast(coordinates)
    WeatherService.fetch_forecast(coordinates["latitude"], coordinates["longitude"])
  end
  
  def forecast_params
    params.permit(:query, :selected_coordinates)
  end
end
