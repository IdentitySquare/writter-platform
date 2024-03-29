# == Schema Information
#
# Table name: publications
#
#  id         :bigint           not null, primary key
#  bio        :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Publication < ApplicationRecord
  include Notifiable
  
  has_many :publication_users, dependent: :destroy
  has_many :users, through: :publication_users

  has_many :posts, dependent: :nullify

  has_many :received_follows, as: :followable, class_name: "Follow", dependent: :destroy
  has_many :followers, through: :received_follows, source: :user

  attr_accessor :user_email, :editor_emails, :executor, :admin_emails

  after_update :add_or_remove_users

  def add_or_remove_users
    
    update_publication_users(editor_emails, 'editor')
    
    if admin_emails.present?
      update_publication_users(admin_emails, 'admin')
    end
  end

  def update_publication_users(emails, role)
    
    revised_emails = emails.present? ? emails.split(',').map { |address| address.strip.downcase } : []
    existing_emails = send(role.pluralize).pluck(:email)
    removed_emails = existing_emails - revised_emails
    
    revised_emails.each do |email|
      next if publication_users.where(user: User.find_by(email: email.strip)).any?
      PublicationUser.create(publication: self, email: email, executor: executor,  role: role)
    end
    
    
    removed_emails.each do |email|
      user_to_remove = publication_users.find_by(user: User.find_by(email: email.strip))
      user_to_remove.executor = executor
      user_to_remove.destroy
    end
  end

  def editors
    publication_users.includes(:user).where(role: :editor)
  end

  def admins
    publication_users.includes(:user).where(role: :admin)
  end

  def members
    publication_users.includes(:user)
  end
end

  
