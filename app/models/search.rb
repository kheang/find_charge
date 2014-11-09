require 'haversine'

class Search < ActiveRecord::Base
  geocoded_by :coordinates
end
