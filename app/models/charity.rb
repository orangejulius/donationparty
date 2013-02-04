class Charity < ActiveRecord::Base
  attr_accessible :image_name, :name

  has_many :rounds
end
