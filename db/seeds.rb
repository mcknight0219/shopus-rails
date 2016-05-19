# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
case Rails.env
when 'development'
  user = Subscriber.create(weixin: 'test01')
  ExpressMethod.create!(company: 'canada_post', unit: 1, rate: 3.33, country: 'Canada', duration: 1, description: '', subscriber: user)
end
