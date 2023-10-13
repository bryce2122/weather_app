class WeatherService
  def self.fetch_forecast(latitude, longitude)
    new(latitude, longitude).fetch_forecast
  end

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def fetch_forecast
    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      data = fetch_weather_data
      format_forecast(data)
    end
  end

  private

  def fetch_weather_data
    response = Faraday.get api_endpoint
    JSON.parse(response.body)
  end

  def api_endpoint
    "https://api.openweathermap.org/data/2.5/weather?lat=#{@latitude}&lon=#{@longitude}&appid=#{Rails.application.credentials.openweather_api_key}"
  end

  def cache_key
    "forecast_data_#{@latitude}_#{@longitude}"
  end

  def format_forecast(data)
    {
      current_temperature: convert_to_fahrenheit(data['main']['temp']),
      high_temperature: convert_to_fahrenheit(data['main']['temp_max']),
      low_temperature: convert_to_fahrenheit(data['main']['temp_min'])
    }
  end

  def convert_to_fahrenheit(kelvin)
    ((kelvin - 273.15) * 9/5 + 32).round(2)
  end
end
