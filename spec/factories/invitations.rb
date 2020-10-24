# == Schema Information
#
# Table name: invitations
#
#  id           :bigint           not null, primary key
#  rsvp         :string           default("PENDING"), not null
#  event_id     :bigint           not null
#  recipient_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :invitation do
    rsvp { 'ACCEPTED' }
    event { create(:event) }
    recipient { create(:user) }
  end
end
