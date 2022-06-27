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
  validates :event_id, uniqueness: { scope: :recipient_id }
  validate :no_host_invite, if: -> { event }

  belongs_to :event
  belongs_to :recipient, class_name: :User

  scope :upcoming, -> { joins(:event).merge(Event.upcoming) }
  scope :past, -> { joins(:event).merge(Event.past) }

  def accepted?
    rsvp == 'ACCEPTED'
  end

  def accept!
    update(rsvp: 'ACCEPTED')
  end

  def decline!
    update(rsvp: 'DECLINED')
  end

  def recipient_name
    recipient.username
  end

  private

  def ensure_rsvp
    rsvp ||= 'PENDING'
  end

  def no_host_invite
    event = Event.find(event_id)
    if event.host_id == recipient_id
      errors.add(:base, :blank, message: 'Host cannot invite themself')
    end
  end
end
