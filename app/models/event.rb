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
class Event < ApplicationRecord
  validates :name, :date, :location, presence: true
  validates :name, uniqueness: true

  belongs_to :host, class_name: :User
  has_many :invitations, dependent: :destroy
  has_many :confirmations,
    -> { where rsvp: 'ACCEPTED' },
    class_name: :Invitation,
    foreign_key: :event_id

  has_many :guests,
    through: :confirmations,
    source: :recipient

  scope :upcoming, -> { where('date > ?', Time.now) }
  scope :past, -> { where('date < ?', Time.now) }

  def host_name
    host.username
  end

  def date_and_time
    date.strftime('%b %-d %Y %l:%M%P')
  end

  def date_only
    date.strftime('%b %-d %Y')
  end

end
