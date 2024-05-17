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
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :rememberable

  validates :email, :username, presence: true
  validates :username, uniqueness: true

  has_many :events,
    foreign_key: :host_id,
    inverse_of: :host,
    dependent: :destroy

  has_many :invitations,
    foreign_key: :recipient_id,
    inverse_of: :recipient,
    dependent: :destroy
  
  has_many :confirmations,
    -> { where rsvp: 'ACCEPTED' },
    class_name: :Invitation,
    foreign_key: :recipient_id,
    inverse_of: :recipient
  
  has_many :commitments,
    through: :confirmations,
    source: :event
end

# adding inverse_of when foreign_key is specificed or a scope is added
# https://guides.rubyonrails.org/association_basics.html#bi-directional-associations