require 'geocoder'
require 'yelp'
require 'haversine'

class SearchController < ApplicationController

  before_action :set_current_location, only: [:index]

  def index
    open_data = HTTParty.get("http://data.raleighnc.gov/resource/c7id-b4bq.json")
    @locations = filter_open_data(open_data)
    @coordinates = @locations.map{|location| [location[:lat],location[:lng]]}

    @locations = @locations.sort_by { |location| location[:distance] }.take(10)
    @locations = add_yelp_results(@locations)
  end

  private

  def filter_open_data(data)
    locations = []

    data.each do |location|
      location_hash = {}
      location_hash[:id] = location["id"]
      location_hash[:name] = location["station_name"]
      location_hash[:lat] = location["location_1"]["latitude"].to_f
      location_hash[:lng] = location["location_1"]["longitude"].to_f
      location_hash[:address] = eval((location["location_1"]["human_address"]).gsub(":","=>"))
      location_hash[:distance] = Haversine.distance(@current_coordinates[0], @current_coordinates[1], location_hash[:lat], location_hash[:lng]).to_miles.round(2)

      locations << location_hash
    end

    locations
  end

  def parse_yelp_result(yelp_result)
    business = yelp_result.businesses[0]
    { :name => business.name, :address => business.location.display_address, :rating => business.rating, :rating_image => business.rating_img_url_small, :url => business.url, :distance => meters_to_miles(business.distance) }
  end

  def add_yelp_results(locations)
    yelp_client = Yelp::Client.new({  consumer_key: ENV['YELP_CONSUMER_KEY'],
                                      consumer_secret: ENV['YELP_CONSUMER_SECRET'],
                                      token: ENV['YELP_TOKEN'],
                                      token_secret: ENV['YELP_TOKEN_SECRET']
                                   })

    locations.each do |location|
      yelp_result = yelp_client.search_by_coordinates( { latitude: location[:lat],
                                                         longitude: location[:lng] },
                                                       { term: 'brewery', limit: 1 })
      yelp_hash = parse_yelp_result(yelp_result)

      location[:yelp] = yelp_hash
    end
  end

  def meters_to_miles(meters)
    (meters.to_f / 1609.34).round(2).to_s
  end

  def set_current_location
    if request.remote_ip == "127.0.0.1"
      address = "318 Blackwell St, Durham, NC 27701"
    else
			address = request.location
		end

    @current_coordinates = Geocoder.coordinates(address)
  end

end
