# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
charity_data =   [["EFF", "eff.png"], ["Child's Play", "childsplay.png"], ["Red Cross", "redcross.png"], ["Oxfam", "oxfam.png"], ["Greenpeace", "greenpeace.png"]]

charity_data.each do |data|
  Charity.create(name: data[0], image_name: data[1])
end
