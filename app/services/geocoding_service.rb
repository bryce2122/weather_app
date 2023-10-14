class GeocodingService
  def self.fetch_coordinates(zipcode)
    results = Geocoder.search(zipcode)

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

  private

  def self.valid_zip_code?(input)
    !!input.to_s.match(/\A\d{5}\z/)
  end
end
