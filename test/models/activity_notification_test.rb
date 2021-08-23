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
  setup do
    @archer = users(:archer)
    @lana = users(:lana)
    InitialLogin.create_with_activity(user: @archer)
    @lana.follow(@archer)
  end

  test "list 2 type of activity notifications" do
    assert(@archer.activity_notifications.size == 2)
    assert(@archer.activity_notifications.order(:created_at)[0].text == '初回ログインありがとうございます。')
    assert(@archer.activity_notifications.order(:created_at)[1].text == "Lana Kaneさんにフォローされました")
  end
end
