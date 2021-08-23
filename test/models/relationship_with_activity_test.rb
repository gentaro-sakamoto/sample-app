require 'test_helper'

class RelationshipWithActivityTest < ActiveSupport::TestCase

  def setup
    @archer = users(:archer)
    @lana = users(:lana)
    @michael = users(:michael)
    @malory = users(:malory)
    @activities = Activity.all
  end

  test "should create relationship and activity" do
    assert(@archer.following.size == 1)
    assert(@archer.following?(@michael))
    assert(@activities.size == 4)
    assert(@lana.activity_notifications.size == 0)

    RelationshipWithActivity.new(follower: @archer, followed: @lana).create

    assert(@archer.following.size == 2)
    assert(@activities.size == 5)
    assert(@lana.activity_notifications.reload.size == 1)
  end

  test "should group activities within 5 minutes" do
    created_relationship = RelationshipWithActivity.new(follower: @michael, followed: @archer).create
    assert(created_relationship.activity.parent_id.nil?)

    travel_to 4.minutes.after
    created_relationship = RelationshipWithActivity.new(follower: @lana, followed: @archer).create
    assert(created_relationship.activity.parent_id.present?)

    travel_to (5.minutes + 1.second).after
    created_relationship = RelationshipWithActivity.new(follower: @malory, followed: @archer).create
    assert(created_relationship.activity.parent_id.nil?)
  end
end
