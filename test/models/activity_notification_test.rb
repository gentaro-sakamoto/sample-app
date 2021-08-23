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
require 'test_helper'

class ActivityNotificationTest < ActiveSupport::TestCase
  class FactoryTest < ActivityNotificationTest
    setup do
      @michael = users(:michael)
    end

    test "dont't create activity notification when there are relationship activities of michael in 5 minutes" do
      ActivityNotification::Factory.create(activity: activities(:three))
      assert(@michael.activity_notifications.size == 1)

      ActivityNotification::Factory.create(activity: activities(:four))
      assert(@michael.activity_notifications.size == 1)
    end
  end

  class TextTest < ActivityNotificationTest
    setup do
      @archer = users(:archer)
      @lana = users(:lana)
      @michael = users(:michael)
      @malory = users(:malory)
      @user_0 = users('user_0')
      InitialLogin.create_with_activity(user: @archer)
      @lana.follow(@archer)
    end

    test "list 2 type of activity notifications" do
      assert(@archer.activity_notifications.size == 2)
      assert(@archer.activity_notifications.order(:created_at)[0].text == '初回ログインありがとうございます。')
      assert(@archer.activity_notifications.order(:created_at)[1].text == "Lana Kaneさんにフォローされました")
    end

    test "when lana unfollowed archer" do
      @lana.unfollow(@archer)

      assert(@archer.activity_notifications.size == 1)
      assert(@archer.activity_notifications.order(:created_at)[0].text == '初回ログインありがとうございます。')
    end

    test "grouped relationship activity_notification" do
      ActivityNotification::Factory.create(activity: activities(:three))
      ActivityNotification::Factory.create(activity: activities(:four))

      assert(@michael.activity_notifications.size == 1)
      assert(@michael.activity_notifications.order(:created_at)[0].text == "Lana Kaneさん他1名にフォローされました")

      travel_to 4.minutes.after
      @malory.follow(@michael)
      assert(@michael.activity_notifications.size == 1)
      assert(@michael.activity_notifications.order(:created_at)[0].text == "Lana Kaneさん他2名にフォローされました")

      travel_to (5.minutes + 1.second).after
      @user_0.follow(@michael)
      assert(@michael.activity_notifications.size == 2)
      assert(@michael.activity_notifications.order(:created_at)[0].text == "Lana Kaneさん他2名にフォローされました")
      assert(@michael.activity_notifications.order(:created_at)[1].text == "User 0さんにフォローされました")
    end
  end
end
