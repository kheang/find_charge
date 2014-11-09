require 'geocoder'

class SearchController < ApplicationController

  before_action :get_locations, only: [:index]

  def index
	  @addresses = []
	  @addresses << "334 Blackwell Street B017, Durham, NC 27701"
	  @addresses << "201 West Main Street, Durham, NC 27701"
	  @coordinates = @addresses.map do |address|
		  coordinate_pair = Geocoder.coordinates(address)
		  coordinate_hash = {}
		  coordinate_hash["lat"] = coordinate_pair[0]
		  coordinate_hash["lng"] = coordinate_pair[1]
		  coordinate_hash
	  end
	  @coordinates = @coordinates

    @locations = HTTParty.get("http://data.raleighnc.gov/resource/c7id-b4bq.json")
  end

  private

  def get_locations
  end

end
