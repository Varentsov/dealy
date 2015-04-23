# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env == 'development'
  User.where.not(:email => ['neck.varentsov@gmail.com', 'neck@varentsov.com']).delete_all
  Group.where.not(:account_id => nil).delete_all
  Recipient.delete_all
  Message.delete_all
  for i in 0...100
    User.create!(email: "user#{i}@gmail.com", password: '123123', first_name: "User#{i}", last_name: "Family#{i}")
    puts i
  end
end