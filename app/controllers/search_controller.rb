require 'geocoder'

class SearchController < ApplicationController

  before_action :get_locations, only: [:index]

  def index
	  address = "334 Blackwell Street B017, Durham, NC 27701"
		@current_coordinates = Geocoder.coordinates(address)
  end

  private

  def get_locations
	  @locations = HTTParty.get("http://data.raleighnc.gov/resource/c7id-b4bq.json")
	  @coordinates = []

	  @locations.each do |location|
      latitude = location["location_1"]["latitude"]
	    longitude = location["location_1"]["longitude"]
		  @coordinates << [latitude,longitude]
    end

  end

end
