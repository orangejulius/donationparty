class Address < ActiveRecord::Base
  attr_accessible :city, :country, :line1, :line2, :state, :zip_code
end
