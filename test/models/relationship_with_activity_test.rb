require 'test_helper'

class RelationshipWithActivityTest < ActiveSupport::TestCase

  def setup
    @archer = users(:archer)
    @lana = users(:lana)
    @michael = users(:michael)
    @relationship_with_activity = RelationshipWithActivity.new(follower: @archer, followed: @lana)
    @activities = Activity.all
  end

  test "should create relationship and activity" do
    assert(@archer.following.size == 1)
    assert(@archer.following?(@michael))
    assert(@activities.size == 0)
    assert(@lana.activity_notifications.size == 0)

    @relationship_with_activity.create

    assert(@archer.following.size == 2)
    assert(@activities.size == 1)
    assert(@lana.activity_notifications.reload.size == 1)
  end
end
