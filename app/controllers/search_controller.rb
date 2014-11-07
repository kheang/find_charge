require 'geocoder'

class SearchController < ApplicationController

	def index
		@coordinates = Geocoder.coordinates("71.70.222.116")
		@coordinates = @coordinates.join(",")
	end
end
