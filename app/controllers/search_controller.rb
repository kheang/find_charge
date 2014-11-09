require 'geocoder'
require 'yelp'
require 'haversine'

class SearchController < ApplicationController

  before_action :set_current_location, only: [:index]

  def index
    open_data = HTTParty.get("http://data.raleighnc.gov/resource/c7id-b4bq.json")
    @locations = filter_open_data(open_data)

    @locations = @locations.sort_by { |location| location["distance"] }.take(10)
    @locations = add_yelp_results(@locations)
  end

  private

  def filter_open_data(data)
    locations = []
    @coordinates = []

    data.each do |location|
      name = location["station_name"]
      latitude = location["location_1"]["latitude"].to_f
      longitude = location["location_1"]["longitude"].to_f
      address = location["location_1"]["human_address"]
      street_address = location["street_address"]
      distance = Haversine.distance(35.9929818, -78.9044936, latitude, longitude)
      miles = distance.to_miles.round(2)

      locations << {"name" => name, "lat" => latitude, "lng"  => longitude, "address" => address, "distance" => miles, "street" => street_address}

      @coordinates << [latitude, longitude]
    end

    locations
  end

  def parse_yelp_result(yelp_result)
    business = yelp_result.businesses[0]
    { "name" => business.name, "address" => business.location.display_address, "rating" => business.rating, "rating_image" => business.rating_img_url_small, "url" => business.url, "distance" => meters_to_miles(business.distance) }
  end

  def add_yelp_results(locations)
    yelp_client = Yelp::Client.new({  consumer_key: ENV['YELP_CONSUMER_KEY'],
                                      consumer_secret: ENV['YELP_CONSUMER_SECRET'],
                                      token: ENV['YELP_TOKEN'],
                                      token_secret: ENV['YELP_TOKEN_SECRET']
                                   })

    locations.each do |location|
      yelp_result = yelp_client.search_by_coordinates( { latitude: location["lat"],
                                                         longitude: location["lng"] },
                                                       { term: 'brewery', limit: 1 })
      yelp_hash = parse_yelp_result(yelp_result)

      location["yelp"] = yelp_hash
    end
  end

  def meters_to_miles(meters)
    (meters.to_f / 1609.34).round(2).to_s
  end

  def set_current_location
    address = "334 Blackwell Street B017, Durham, NC 27701"
    @current_coordinates = Geocoder.coordinates(address)
  end

end
