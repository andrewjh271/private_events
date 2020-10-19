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
class Invitation < ApplicationRecord
  after_initialize :ensure_rsvp

  validates :rsvp, presence: true
  validates :rsvp, inclusion: { in: %w[ACCEPTED PENDING DECLINED] }, if: -> { rsvp }

  belongs_to :event
  belongs_to :recipient, class_name: :User

  def accepted?
    rsvp == 'ACCEPTED'
  end

  def accept!
    update(rsvp: 'ACCEPTED')
  end

  def decline!
    update(rsvp: 'DECLINED')
  end

  private

  def ensure_rsvp
    rsvp ||= 'PENDING'
  end
end
