require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'Corey has 5 entries' do
    corey = users(:corey)
    assert_equal 5, corey.entries.size
  end

  test 'Trevor has 5 entries' do
    trevor = users(:trevor)
    assert_equal 5, trevor.entries.size
  end

  test 'Jim has no entries' do
    jim = users(:jim)
    assert_equal 0, jim.entries.size
  end

end