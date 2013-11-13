require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  setup :activate_authlogic

  test 'New, logged in' do
    corey = users(:corey)
    UserSession.create(corey)
    get(:new)
    assert_valid_must_not_be_logged_in
  end

  test 'New, not logged in' do
    get(:new)
    assert_response :success
    new_session = assigns[:user_session]
    assert new_session.new_record?
  end

  test 'Create, logged in, valid login' do
    trevor = users(:trevor)
    UserSession.create(trevor)
    post_params = {
      user_session: {
        login: 'trevor',
        password: 'trevorpepper'
      }
    }
    post(:create, post_params)
    assert_valid_must_not_be_logged_in
  end

  test 'Create, not logged in, valid login' do
    trevor = users(:trevor)
    post_params = {
      user_session: {
        login: 'trevor',
        password: 'trevorpepper'
      }
    }
    post(:create, post_params)
    assert_redirected_to home_path
    session = UserSession.find
    assert_not_nil session
    assert_equal trevor, session.user
  end

  test 'Create, not logged in, invalid login' do
    trevor = users(:trevor)
    post_params = {
      user_session: {
        login: 'trevor',
        password: 'incorrect'
      }
    }
    post(:create, post_params)
    assert_response :success
    assert assigns[:user_session].errors.size > 0
    assert_nil UserSession.find
  end

  test 'Destroy, not logged in' do
    delete(:destroy)
    assert_valid_must_be_logged_in
  end

  test 'Destroy, logged in' do
    corey = users(:corey)
    UserSession.create(corey)
    delete(:destroy)
    assert_redirected_to home_path
    assert_nil UserSession.find
  end

end
