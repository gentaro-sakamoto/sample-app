# == Schema Information
#
# Table name: activities
#
#  id           :integer          not null, primary key
#  actable_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  actable_id   :integer
#  parent_id    :integer
#
# Indexes
#
#  index_activities_on_actable_type_and_actable_id  (actable_type,actable_id) UNIQUE
#
require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
