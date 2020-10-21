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
  @random_users = (0..n).to_a.shuffle
end

ActiveRecord::Base.transaction do
  Invitation.destroy_all
  Event.destroy_all
  User.destroy_all

  @users = []
  25.times do |i|
    @users[i] = User.create(
      username: Faker::Internet.username,
      email: Faker::Internet.email,
      password: 'mandolin'
    )
  end

  @events = []
  30.times do |i|
    event_date = Faker::Time.between(from: 3.months.ago, to: 1.year.from_now)
    create_date = Faker::Time.between(from: 1.year.ago, to: event_date)
    @events[i] = Event.create(
      name: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 2),
      location: Faker::Address.city,
      date: event_date,
      description: Faker::GreekPhilosophers.quote,
      host: @users[rand(@users.length)],
      created_at: create_date,
      updated_at: create_date
    )
  end

  # Sample User
  @example_user = User.create(
    username: 'odin',
    email: 'odin@example.com',
    password: 'password'
  )
  # Sample Event
  Event.create(
    name: 'Ice Cream Social',
    location: Faker::Address.city,
    date: 1.year.from_now,
    description: Faker::GreekPhilosophers.quote,
    host: @example_user
  )

  @events.each do |event|
    event.invitations.create(recipient: @example_user)
    random_user_reset!
    rand(@users.length).times do
      event.invitations.create(recipient: random_user)
    end
  end

  @users.each do |user|
    user.invitations.each do |invitation|
      random = rand
      if random < 0.5
        invitation.update(rsvp: 'ACCEPTED')
      elsif random < 0.8
        invitation.update(rsvp: 'DECLINED')
      end
    end
  end

end