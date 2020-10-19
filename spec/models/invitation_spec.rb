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
  pending "add some examples to (or delete) #{__FILE__}"
end
