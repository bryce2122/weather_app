# app/services/geocoding_service.rb

class GeocodingService
  def self.fetch_coordinates(address)
    results = Geocoder.search(address)

    if results.present?
      {
        latitude: results.first.latitude,
        longitude: results.first.longitude
      }
    else
      nil
    end
  end
end
