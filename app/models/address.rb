class Address < ActiveRecord::Base
  attr_accessible :city, :country, :line1, :line2, :state, :zip_code

  validates_presence_of :city, :country, :line1, :line2, :state, :zip_code

  belongs_to :round
end
