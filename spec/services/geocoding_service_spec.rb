RSpec.describe GeocodingService do
  describe '.fetch_coordinates' do
    let(:address) { '123 Main St, Anytown, USA' }

    context 'when address has valid coordinates' do
      before do
        # Stub geocoder request to return a valid set of coordinates.
        Geocoder::Lookup::Test.add_stub(
          address,
          [{ 'coordinates' => [40.7143528, -74.0059731], display_name: "Anytown" }]
        )
      end

      it 'returns the coordinates for the address' do
        result = described_class.fetch_coordinates(address)

        expect(result).to eq([
          {
            latitude: 40.7143528,
            longitude: -74.0059731,
            display_name: "Anytown"
          }.to_json
        ])
      end
    end

    context 'when address does not have valid coordinates' do
      before do
        # Stub geocoder request to return no data for the address.
        Geocoder::Lookup::Test.add_stub(address, [])
      end

      it 'returns nil' do
        result = described_class.fetch_coordinates(address)

        expect(result).to eq([])
      end
    end
  end
end
