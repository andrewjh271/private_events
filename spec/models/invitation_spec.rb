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
require 'rails_helper'

RSpec.describe Invitation, type: :model do
  subject(:invitation) { FactoryBot.build(:invitation) }

  describe 'validations' do
    it { should validate_presence_of(:rsvp) }
    it { should validate_inclusion_of(:rsvp).in_array(%w[ACCEPTED PENDING DECLINED]) }
    it { should validate_uniqueness_of(:event_id).scoped_to(:recipient_id) }
  end

  describe 'associations' do
    it { should belong_to(:event) }
    it { should belong_to(:recipient) }
  end
end
