# == Schema Information
#
# Table name: initial_logins
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_initial_logins_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class InitialLogin < ApplicationRecord
  belongs_to :user
  has_one :activity, as: :actable, dependent: :destroy

  class << self
    def create_with_activity(user:)
      return if user.initial_login.present?

      ActiveRecord::Base.transaction do
        il = user.create_initial_login
        a = il.create_activity
        ActivityNotification::Factory.create(activity: a)
      end
    end
  end
end
