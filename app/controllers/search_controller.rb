require 'geocoder'

class SearchController < ApplicationController

	def index
		@addresses = []
		@addresses << "334 Blackwell Street B017, Durham, NC 27701"
		@addresses << "201 West Main Street, Durham, NC 27701"
		@coordinates = @addresses.map { |address| Geocoder.coordinates(address) }
	end
end
