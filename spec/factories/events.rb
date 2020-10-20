# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  date        :datetime         not null
#  location    :string           not null
#  description :text
#  host_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :event do
    name { "MyString" }
    date { "2020-10-19" }
    location { "MyString" }
    description { "MyText" }
    host { nil }
  end
end
