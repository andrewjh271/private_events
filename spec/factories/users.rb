# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  email               :string           default(""), not null
#  encrypted_password  :string           default(""), not null
#  username            :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  remember_created_at :datetime
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.username }
    password { Faker::Internet.password(min_length: 6) }
  end
end
