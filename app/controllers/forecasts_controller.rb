class ForecastsController < ApplicationController
  def show
    @address = forecast_params[:address]

    if @address.present?
      process_forecast
    end
  end

  private

  def process_forecast
    coordinates = fetch_coordinates
    if coordinates
      @forecast = fetch_weather_data(coordinates)
    else
      flash[:error] = "Invalid ZIP code or address. Please try again."
    end
  end

  def fetch_coordinates
    GeocodingService.fetch_coordinates(@address)
  end

  def fetch_weather_data(coordinates)
    WeatherService.fetch_forecast(coordinates[:latitude], coordinates[:longitude])
  end

  def forecast_params
    params.permit(:address)
  end
end
