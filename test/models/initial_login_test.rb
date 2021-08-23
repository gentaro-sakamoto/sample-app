# == Schema Information
#
# Table name: initial_logins
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_initial_logins_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require 'test_helper'

class InitialLoginTest < ActiveSupport::TestCase
  test '.create_with_activity' do
    @archer = users(:archer)
    assert(@archer.initial_login.nil?)

    InitialLogin.create_with_activity(user: @archer)

    assert(@archer.initial_login.present?)
    assert(@archer.initial_login.activity.present?)
  end
end
