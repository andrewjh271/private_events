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
require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) { FactoryBot.build(:event) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:location) }
    it { should validate_uniqueness_of(:name) }

    it 'should validate that date is in the future' do
      invalid_event = FactoryBot.build(:event, date: 1.day.ago)
      expect(invalid_event.valid?).to be false
    end
  end

  describe 'associations' do
    it { should belong_to(:host) }
    it { should have_many(:invitations) }
    it { should have_many(:confirmations) }
    it { should have_many(:guests) }
  end
end
