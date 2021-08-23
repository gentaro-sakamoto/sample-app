# == Schema Information
#
# Table name: activity_notifications
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  activity_id  :integer
#  recipient_id :integer
#
# Indexes
#
#  index_activity_notifications_on_activity_id   (activity_id)
#  index_activity_notifications_on_recipient_id  (recipient_id)
#
class ActivityNotification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :activity

  class Factory
    class << self
      def create(activity:)
        case activity.actable
        when InitialLogin
          ActivityNotification.create(recipient: activity.actable.user, activity: activity)
        end
      end
    end
  end
end
