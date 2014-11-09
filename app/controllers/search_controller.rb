require 'geocoder'
require 'yelp'

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

	  @locations_data.each do |location|
		  name = location["station_name"]
      latitude = location["location_1"]["latitude"].to_f
	    longitude = location["location_1"]["longitude"].to_f
		  address = location["location_1"]["human_address"]
      @locations << {"name" => name, "lat" => latitude, "lng"  => longitude, "address" => address}
		  @coordinates << [latitude, longitude]
	  end
  end

  def get_yelp_results
    yelp_client = Yelp::Client.new({  consumer_key: YOUR_CONSUMER_KEY,
                                      consumer_secret: YOUR_CONSUMER_SECRET,
                                      token: YOUR_TOKEN,
                                      token_secret: YOUR_TOKEN_SECRET
                                    })
  end

end
