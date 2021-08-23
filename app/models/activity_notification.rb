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
        when Relationship
          return if activity.parent_id?

          ActivityNotification.create(recipient: activity.actable.followed, activity: activity)
        end
      end
    end
  end

  def text
    case activity.actable
    when InitialLogin
      I18n.t('.activity_notification.initial_login')
    when Relationship
      if activity.children.present?
        I18n.t(
          '.activity_notification.multiple_followed',
          username: activity.actable.follower.name,
          size: activity.children.size
        )
      else
        I18n.t('.activity_notification.followed', username: activity.actable.follower.name)
      end

    end
  end
end
