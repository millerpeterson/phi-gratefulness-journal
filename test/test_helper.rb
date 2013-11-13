ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "authlogic/test_case"

class ActiveSupport::TestCase

  fixtures :all

  def assert_valid_must_not_be_logged_in
    assert_redirected_to home_path
    assert_equal I18n.t('application.must-be-logged-out'),
                 flash[:notice]
  end

  def assert_valid_must_be_logged_in
    assert_redirected_to new_user_session_path
    assert_equal I18n.t('application.must-be-logged-in'), flash[:notice]
  end

end
