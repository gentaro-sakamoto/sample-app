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
class Activity < ApplicationRecord
  belongs_to :actable, polymorphic: true
  has_one :notifications, dependent: :destroy, class_name: "ActivityNotification"
  belongs_to :parent, class_name: "Activity", foreign_key: 'parent_id', optional: true
  has_many :children, class_name: "Activity", foreign_key: 'parent_id'
end
