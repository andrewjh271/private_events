# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def random_user
  @users[@random_users.pop]
end

def random_user_reset!(n = @users.length)
  @random_users = (0...n).to_a.shuffle
end

ActiveRecord::Base.transaction do
  Invitation.destroy_all
  Event.destroy_all
  User.destroy_all

  ActiveRecord::Base.connection.reset_pk_sequence!('invitations')
  ActiveRecord::Base.connection.reset_pk_sequence!('events')
  ActiveRecord::Base.connection.reset_pk_sequence!('users')

  @users = []
  28.times do
    username = Faker::Internet.username
    @users << User.create!(
      username: username,
      email: "#{username}@gmail.com",
      password: 'mandolin'
    )
  end

  @events = []
  31.times do
    event_date = Faker::Time.between(from: 3.months.ago, to: 1.year.from_now)
    create_date = Faker::Time.between(from: 1.year.ago, to: event_date)
    location = rand < 0.7 ? Faker::Movies::HitchhikersGuideToTheGalaxy.location : Faker::Address.city
    description = rand < 0.7 ? Faker::Movies::HitchhikersGuideToTheGalaxy.quote : Faker::GreekPhilosophers.quote
    @events << Event.new(
      name: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 2),
      location: location,
      date: event_date,
      description: description,
      host: @users[rand(@users.length)],
      created_at: create_date,
      updated_at: create_date
    )
    @events.last.save!(validate: false) # bypasses `starts_in_the_future` validation
  end

  # Sample User
  @example_user = User.create!(
    username: 'odin',
    email: 'odin@example.com',
    password: 'password'
  )
  # Sample Event
  @events << Event.create!(
    name: 'Giraffe Convention',
    location: 'San Diego Zoo',
    date: 1.year.from_now,
    description: Faker::GreekPhilosophers.quote,
    host: @example_user
  )
  8.times do
    event_date = Faker::Time.between(from: 5.months.ago, to: 1.year.from_now)
    create_date = Faker::Time.between(from: 1.year.ago, to: event_date)
    location = rand < 0.7 ? Faker::Movies::HitchhikersGuideToTheGalaxy.location : Faker::Address.city
    description = rand < 0.7 ? Faker::Movies::HitchhikersGuideToTheGalaxy.quote : Faker::GreekPhilosophers.quote
    @events << Event.new(
      name: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 2),
      location: location,
      date: event_date,
      description: description,
      host: @example_user,
      created_at: create_date,
      updated_at: create_date
    )
    @events.last.save!(validate: false) # bypasses `starts_in_the_future` validation
  end

  # Invitations for events
  # `create` used over `create!` so `no_host_invite` validation will fail silently
  @events.each do |event|
    event.invitations.create(recipient: @example_user) if rand < 0.75
    random_user_reset!
    rand(12..@users.length).times do
      event.invitations.create(recipient: random_user)
    end
  end

  # RSVPs for invitations
  @users << @example_user
  @users.each do |user|
    user.invitations.each do |invitation|
      random = rand
      if random < 0.45
        invitation.update(rsvp: 'ACCEPTED')
      elsif random < 0.75
        invitation.update(rsvp: 'DECLINED')
      end
    end
  end
end