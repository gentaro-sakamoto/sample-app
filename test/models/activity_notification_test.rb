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
  # test "the truth" do
  #   assert true
  # end
end
