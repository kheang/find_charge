class SearchController < ApplicationController
  before_action :get_locations, only: [:index]

  def index
    @locations = HTTParty.get("http://data.raleighnc.gov/resource/c7id-b4bq.json")


    # @longitude1 = @location[0]["location_1"]["longitude"]
    # @latitude1 = @location[0]["location_1"]["latitude"]

    # @longitude2 = @location[1]["location_1"]["longitude"]
    # @latitude2 = @location[1]["location_1"]["latitude"]


    # @locations = [["Durham","Bulls"],["Raleigh","Hurricanes"],["Chapel Hill","Tar Heels"]]
    # print @locations[1] ===> "Raleigh"
    #
    # @cities = []
    #
    # @locations[2] = ["Chapel Hill","Tar Heels"]
    # location = @locations[2]
    #
    # @locations.each do |location|
    #   hash = {}
    #   hash["city_name"] = location[0] ---> {"city_name" => "Chapel Hill"}
    #   @cities << hash ---> [{"city_name" => "Durham"},{"city_name" => "Raleigh"},...]
    # end
  end

  def get_locations


    # @coordinates = [{"station_name" => "name of place","lat" => longitude, "lng" => latitude},{"station_name" => "name of place",lat" => longitude, "lng" => latitude}]
  end
end
