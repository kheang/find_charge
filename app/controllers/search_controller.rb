require 'geocoder'
require 'yelp'
require 'haversine'


class SearchController < ApplicationController

  before_action :get_locations, only: [:index]

  def index
	  address = "334 Blackwell Street B017, Durham, NC 27701"
		@current_coordinates = Geocoder.coordinates(address)
  end

  private

  def get_locations
	  @locations_data = HTTParty.get("http://data.raleighnc.gov/resource/c7id-b4bq.json")
	  @locations = []
	  @coordinates = []

    yelp_client = Yelp::Client.new({  consumer_key: ENV['YELP_CONSUMER_KEY'],
                                      consumer_secret: ENV['YELP_CONSUMER_SECRET'],
                                      token: ENV['YELP_TOKEN'],
                                      token_secret: ENV['YELP_TOKEN_SECRET']
                                   })

    @locations_data = @locations_data.take(10)

	  @locations_data.each do |location|
		  name = location["station_name"]
      latitude = location["location_1"]["latitude"].to_f
	    longitude = location["location_1"]["longitude"].to_f
		  address = location["location_1"]["human_address"]
      yelp_result = yelp_client.search_by_coordinates( { latitude: latitude,
                                                    longitude: longitude },
                                                  { term: 'bar', limit: 1 })
      yelp_hash = parse_yelp_result(yelp_result)

      @locations << {"name" => name, "lat" => latitude, "lng"  => longitude, "address" => address, "yelp" => yelp_hash}
		  @coordinates << [latitude, longitude]
    end
  end

  private

  def parse_yelp_result(yelp_result)
    business = yelp_result.businesses[0]
    { "name" => business.name, "address" => business.location.display_address, "rating" => business.rating, "rating_image" => business.rating_img_url_small, "url" => business.url, "distance" => meters_to_miles(business.distance) }
  end

  def meters_to_miles(meters)
    (meters.to_f / 1609.34).round(2).to_s
  end
end
