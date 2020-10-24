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
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:username) }
  end

  describe 'associations' do
    it { should have_many(:events) }
    it { should have_many(:commitments) }
    it { should have_many(:invitations) }
    it { should have_many(:confirmations) }
  end
end
