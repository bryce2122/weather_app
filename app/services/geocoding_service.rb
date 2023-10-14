class GeocodingService
  def self.fetch_coordinates(address)
    results = Geocoder.search(address)

    if results.present?
      results.map do |result|
        {
          latitude: result.latitude,
          longitude: result.longitude,
          display_name: result.display_name
        }.to_json
      end
    else
      []
    end
  end
end
