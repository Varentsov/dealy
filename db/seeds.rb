# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.where.not(:email => 'neck.varentsov@gmail.com').delete_all
for i in 0...100
  User.create(email: "#{i}@gmail.com", password: '123123', first_name: i.to_s, last_name: i.to_s)
  puts i
end
