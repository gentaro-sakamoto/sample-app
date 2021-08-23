# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer
#  follower_id :integer
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

  test "#other_follower_relationships" do
    lana = users(:lana)
    michael = users(:michael)
    malory = users(:malory)
    archer = users(:archer)
    michael.follow(archer)
    last_relationship = michael.active_relationships.last
    assert(last_relationship.other_follower_relationships.size == 0)

    travel_to 4.minutes.after
    lana.follow(archer)
    last_relationship = lana.active_relationships.last
    assert(last_relationship.other_follower_relationships.size == 1)

    travel_to (5.minutes + 1.second).after
    malory.follow(archer)
    last_relationship = malory.active_relationships.last
    assert(last_relationship.other_follower_relationships.size == 0)
  end
end
