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
#  timezone                       :string           default("UTC")
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
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
