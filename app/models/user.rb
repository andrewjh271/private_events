# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  email              :string           default(""), not null
#  encrypted_password :string           default(""), not null
#  username           :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :rememberable

  validates :email, :username, presence: true
  validates :username, uniqueness: true

  has_many :events,
    foreign_key: :host_id,
    dependent: :destroy

  # scope :upcoming_events, joins(:events).merge(Event.upcoming)
  # scope :post_events, joins(:events).merge(Event.past)

  has_many :invitations,
    foreign_key: :recipient_id,
    dependent: :destroy

  # has_many :past_invitations,
  #   -> { past },
  #   foreign_key: :recipient_id,
  #   class_name: :Invitation

  # has_many :upcoming_invitations,
  #   -> { where event.upcoming },
  #   foreign_key: :recipient_id,
  #   class_name: :Invitation

  # scope :upcoming_invitations,
  #   joins(:invitations).merge
  
  has_many :confirmations,
    -> { where rsvp: 'ACCEPTED' },
    class_name: :Invitation,
    foreign_key: :recipient_id
  
  has_many :commitments,
    through: :confirmations,
    source: :event

  # has_many :upcoming_commitments,
  #   -> { upcoming },
  #   through: :confirmations,
  #   source: :event

  # has_many :past_commitments,
  #   -> { past },
  #   through: :confirmations,
  #   source: :event
  end
