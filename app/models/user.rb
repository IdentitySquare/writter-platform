# == Schema Information
#
# Table name: users
#
#  id                             :bigint           not null, primary key
#  avatar_url                     :string
#  bio                            :string
#  confirmation_sent_at           :datetime
#  confirmation_token             :string
#  confirmed_at                   :datetime
#  current_sign_in_at             :datetime
#  current_sign_in_ip             :string
#  email                          :string           default(""), not null
#  encrypted_password             :string           default(""), not null
#  last_sign_in_at                :datetime
#  last_sign_in_ip                :string
#  location                       :string
#  name                           :string
#  new_article_notifications_freq :integer          default("daily")
#  notifications                  :boolean          default(TRUE)
#  notifications_freq             :integer          default("instantly")
#  performance_notifications_freq :integer          default("daily")
#  product_notifications          :boolean          default(TRUE)
#  provider                       :string
#  remember_created_at            :datetime
#  reset_password_sent_at         :datetime
#  reset_password_token           :string
#  sign_in_count                  :integer          default(0), not null
#  uid                            :string
#  unconfirmed_email              :string
#  username                       :string
#  website                        :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  validates :username, length: {minimum: 4 }, on: :update

  has_many :posts, dependent: :destroy

  has_many :received_follows, as: :followable, class_name: "Follow"
  has_many :followers, through: :received_follows, source: :user


  has_many :given_follows, class_name: "Follow"
  has_many :following, through: :given_follows, source: :followable, source_type: "User"


  # notification preference stored as enum
  enum notifications_freq: { instantly: 0, daily: 1, weekly: 2, off: 3  }, _suffix: :notifications

  enum new_article_notifications_freq: { daily: 0, weekly: 1, off: 2}, _suffix: :new_article_notifications

  enum performance_notifications_freq: { daily: 0, weekly: 1, off: 2}, _suffix: :performance_notifications

  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name # assuming the user model has a name
      user.avatar_url = auth.info.image # assuming the user model has an image

      user.skip_confirmation!
    end
  end


  def onboarded?
    username.present?
  end

  def published_posts
    posts.published
  end

  def draft_posts
    posts.draft
  end


  
end
