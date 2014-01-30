namespace :db do
  desc "Fill the database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(:name => "Example Admin",
                       :email => "example@railstutorial.org",
                       :password => "foobar",
                       :password_confirmation => "foobar")
  admin.toggle!(:admin)

  10000.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_microposts
  User.all(:limit => 1000).each do |user|
    500.times do
      content = Faker::Lorem.sentence(5)
      user.microposts.create!(:content => content)
    end
  end
end

def make_relationships
  users = User.all
  user = users.first
  following = users[1..500]
  followers = users[3..400]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
