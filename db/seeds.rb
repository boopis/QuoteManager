# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
plans = Plan.create([
  { id: 1, name: 'Individual',  price: 19, users: 1, forms: 5, storage: 100, requests: 500}, 
  { id: 2, name: 'Small Business',  price: 49, users: 3, forms: 10, storage: 1000, requests: 1500}, 
  { id: 3, name: 'Premium Business',  price: 99, users: 5, forms: 20, storage: 5000, requests: 5000}, 
])
