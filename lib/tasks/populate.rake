namespace :db do
  namespace :populate do
    desc "Create user records in the development database."


    require 'faker'
    require 'forgery'

    @countries = ["United States", "Canada", "United Kingdom", "Germany", "Mexico", "Italy"]
    @genders = ["male","female"]
    @privacy = ["members", "public"]
    @roles = ["user","moderator","admin"]
    @group_types = ["Venue", "Artist"]
    @categories = ['Music', 'Sport', 'Theatre', 'Cinema', 'Disco']
    @coordinates = [Faker::Address.latitude, Faker::Address.longitude]
    @address = Forgery(:address).street_address+' '+Forgery(:address).city
    @date_range = [1,7,7,30,365]


    task :fake_users => :environment do
      10.times do

        u = User.new(
          :name => Faker::Name.name,
          :username => Faker::Internet.user_name(:name),
          :gender => @genders.sample.to_s,
          :picture => open(File.expand_path "public/images/user#{rand(1..6)}.jpg"),
          :birthdate => Faker::Date.birthday,
          :created_at => Faker::Date.backward(365),
          :hometown => Faker::Address.city,
          :password => "greatpasswordhuh",
          :password_confirmation => "greatpasswordhuh",
          :accepts_terms_and_conditions => true,
          :role => @roles.sample.to_s,
          :email => Faker::Internet.email(:name),
          :website => Faker::Internet.url,
          :bio => Faker::Lorem.paragraph

        )

        # u.preferences = Preferences.new()
        u.skip_confirmation!
        u.save!

      end
      puts "Created fake users"
    end

    task :fake_venues => :environment do
      10.times do
        g = Group.new(
          :name => Faker::Company.name,
          :picture => open(File.expand_path "public/images/venue#{rand(1..6)}.jpg"),
          :description => Faker::Lorem.paragraph,
          :owner_id => User.all.sample.id ,
          :type => "Venue" ,
          :category => @categories.sample.to_s ,
          :privacy => "OPEN" ,
          :website => Faker::Internet.url,
          :address => @address
        )
        g.save!
      end
      puts "Created fake venues"
    end

    task :fake_artists => :environment do
      10.times do
        g = Group.new(
          :name => Faker::Company.name,
          :picture => open(File.expand_path "public/images/artist#{rand(1..3)}.jpg"),
          :description => Faker::Lorem.paragraph,
          :owner_id => User.all.sample.id ,
          :type => "Artist" ,
          :category => @categories.sample.to_s ,
          :privacy => "OPEN" ,
          :website => Faker::Internet.url,
          :address => @address
        )
        g.save!
      end
      puts "Created fake artists"
    end

    task :fake_events => :environment do
      20.times do
        @start_time =  Faker::Date.forward(@date_range.sample)+(rand(1..22)).hours
        e = Event.new(
          :name => Faker::Lorem.sentence,
          :picture => open(File.expand_path "public/images/event#{rand(1..4)}.jpg"),
          :description => Faker::Lorem.paragraph,
          :creator_id => User.all.sample.id ,
          :group_id => Group.all.sample.id,
          :start_time => @start_time,
          :end_time => @start_time + (2*60*60)

        )
        e.save!
      end
      puts "Created fake events"
    end

    task :fake_all => :environment do
      Rake::Task["db:populate:fake_users"].invoke
      Rake::Task["db:populate:fake_venues"].invoke
      Rake::Task["db:populate:fake_artists"].invoke
      Rake::Task["db:populate:fake_events"].invoke
    end
  end
end
