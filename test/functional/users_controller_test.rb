require 'test_helper'

class UsersControllerTest < ActionController::TestCase

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
    new_user = assigns[:user]
    assert new_user.present? && new_user.new_record?
  end

  test 'Create, logged in' do
    trevor = users(:trevor)
    UserSession.create(trevor)
    post_params = {
      login: 'Trevster',
      email: 'trev@coolguys.com',
      password: 'secret',
      password_confirmation: 'secret'
    }
    post(:create, post_params)
    assert_valid_must_not_be_logged_in
  end

  test 'Create, not logged in, valid params' do
    post_params = {
      user: {
        login: 'billy',
        email: 'billy@coolguys.com',
        password: 'secret',
        password_confirmation: 'secret'
      }
    }
    post(:create, post_params)
    assert_redirected_to home_path
    assert_equal flash[:notice], I18n.t('application.account-registered')
    billy = User.find_by_email('billy@coolguys.com')
    assert_not_nil billy
    assert_equal post_params[:user][:login], billy.login
  end

  test 'Create, not logged in, invalid params' do
    post_params = {
      user: {
        login: 'silly',
        email: 'silly@coolguys.com',
      }
    }
    post(:create, post_params)
    assert_response :success
    assert_not_nil assigns[:user]
    assert assigns[:user].errors.size > 0
    assert_nil User.find_by_email('silly@coolguys.com')
  end

end
