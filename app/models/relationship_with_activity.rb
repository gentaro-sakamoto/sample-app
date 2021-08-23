class RelationshipWithActivity
  class << self
    def follow(follower:, followed:)
      new(follower: follower, followed: followed).create
    end
  end

  def initialize(follower:, followed:)
    @follower = follower
    @followed = followed
  end

  def create
    ActiveRecord::Base.transaction do
      @follower.following << @followed
      created_relationship = @follower.active_relationships.last
      created_relationship.create_activity
    end
  end
end
