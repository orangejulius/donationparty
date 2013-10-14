class Address < ActiveRecord::Base
  validates_presence_of :city, :country, :line1, :state, :zip_code

  belongs_to :round

  def identical?(other)
    identical_attributes == other.identical_attributes
  end

  def identical_attributes
    attributes.with_indifferent_access.except(:id, :created_at, :updated_at)
  end
end
