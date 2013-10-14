require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test "identical? returns true for addresses with the same attributes" do
    a1 = Address.new(city: "New York", state: "NY")
    a2 = Address.new(city: "New York", state: "NY")

    assert a1.identical?(a2)
  end

  test "identical? returns false for address with different attributes" do
    a1 = Address.new(city: "New York", state: "NY")
    a2 = Address.new(city: "Troy", state: "NY")

    assert !a1.identical?(a2)
  end

  test "identical? returns true for addresses where only ignored attribures differ" do
    a1 = Address.new(city: "New York", state: "NY", created_at: Time.now)
    a2 = Address.new(city: "New York", state: "NY", created_at: 2.days.ago)

    assert a1.identical?(a2)
  end
end
