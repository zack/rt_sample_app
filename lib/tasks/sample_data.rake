require "activerecord-import/base"

namespace :db do
  desc "Fill the database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    Rake::Task['db:migrate'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  users = []

  # Make an admin user
  admin = User.new( :name => "Example Admin",
                    :email => "example@railstutorial.org",
                    :password => "foobar",
                    :password_confirmation => "foobar")
  admin.toggle!(:admin)
  admin.save(:validate => false)

  # Make the rest of the users
  25000.times do |n|
    users << User.new( :name => Faker::Name.name,
                       :email => "example-#{n+1}@railstutorial.org",
                       :password => "password",
                       :password_confirmation => "password" )
  end

  # Turn off info/warn logs and import users
  Rails.logger.level = 3
  User.import users, :validate => false
  Rails.logger.level = 0
end

def make_microposts
  microposts = []

  User.all(:limit => 100).each do |user|
    100.times do |n|
      microposts << user.microposts.new(:content => Faker::Lorem.sentence(5))
    end
  end

  # Turn off info/warn logs and import microposts
  Rails.logger.level = 3
  Micropost.import microposts, :validate => false
  Rails.logger.level = 3
end

def make_relationships
  users = User.all
  user = users.first
  following = users[1..500]
  followers = users[3..202]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
