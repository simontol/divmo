# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#puts 'EMPTY THE MONGODB DATABASE'
#Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)
puts 'DELETING DATA'
User.delete_all
Group.delete_all
Event.delete_all
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :username => 'user1', :name => 'User One', :email => 'userone@aaa.bbb',
					:password => 'password', :password_confirmation => 'password',
					:hometown => 'Milano',:confirmed_at => Time.now
puts 'New user created: ' << user.username
user = User.create! :username => 'user2', :name => 'User Two', :email => 'usertwo@aaa.bbb',
				    :password => 'password', :password_confirmation => 'password',
				    :role => 'admin', :hometown => 'Bergamo', :confirmed_at => Time.now 
puts 'New user created: ' << user.username
