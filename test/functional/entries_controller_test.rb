require 'test_helper'

class EntriesControllerTest < ActionController::TestCase

  setup :activate_authlogic

  def assert_valid_must_be_logged_in
    assert_redirected_to new_user_session_path
    assert_equal(flash[:notice], I18n.t('must-be-logged-in'))
  end

  test "New, not logged in" do
    trevor = users(:trevor)
    get(:new, { user_id: trevor.id })
    assert_valid_must_be_logged_in
  end

  test "New, logged in" do
    corey = users(:corey)
    UserSession.create(corey)
    get(:new, { user_id: corey.id })
    assert_response :success
    entry = assigns[:entry]
    assert entry.new_record?
    assert entry.body_text.blank?
    assert entry.creation_date.nil?
    assert entry.author.nil?
  end

  test "Create, not logged in" do
    jim = users(:jim)
    post(:create, { user_id: jim.id,
      gratefulness_entry: {
        body_text: 'Create, not logged in'
      }
    })
    assert_valid_must_be_logged_in
  end

  test "Create, logged in, valid entry" do
    corey = users(:corey)
    UserSession.create(corey)
    body_text = "Create, logged in"
    post(:create,
      { user_id: corey.id, gratefulness_entry: { body_text: body_text } }
    )
    last_entry = GratefulnessEntry.order('creation_date DESC').limit(1).first
    assert_equal(last_entry.body_text, body_text)
    assert_equal(last_entry.author, corey)
    assert_redirected_to user_entry_path(corey, last_entry)
  end

  test "Create, logged in, no body text" do
    trevor = users(:trevor)
    UserSession.create(trevor)
    post(:create, { user_id: trevor.id })
    assert_response :unprocessable_entity
  end

  test "Show, not logged in" do
    trevor = users(:trevor)
    # Try to get entry user owns.
    t1 = gratefulness_entries(:t1)
    get(:show, { user_id: trevor.id, id: t1.id })
    assert_valid_must_be_logged_in
    # Try to get someone else's entry.
    c1 = gratefulness_entries(:c1)
    get(:show, { user_id: trevor.id, id: c1.id })
    assert_valid_must_be_logged_in
  end

  test "Show, invalid user path" do
    trevor = users(:trevor)
    corey = users(:corey)
    UserSession.create(trevor)
    t1 = gratefulness_entries(:t1)
    get(:show, { user_id: corey.id, id: t1.id })
    assert_response :forbidden
  end

  test "Show, invalid entry id" do
    invalid_id = GratefulnessEntry.maximum(:id) + 1
    corey = users(:corey)
    UserSession.create(corey)
    get(:show, { user_id: corey.id, id: invalid_id })
    assert_response :not_found
  end

  test "Show, valid entry id, entry owned" do
    corey = users(:corey)
    UserSession.create(corey)
    c3 = gratefulness_entries(:c3)
    get(:show, { user_id: corey.id, id: c3.id })
    assert_response :success
    assert_equal c3, assigns[:entry]
  end

  test "Show, valid entry id, entry not owned" do
    corey = users(:corey)
    UserSession.create(corey)
    t3 = gratefulness_entries(:t3)
    get(:show, { user_id: corey.id, id: t3.id })
    assert_response :forbidden
  end

  test "Random, not logged in" do
    corey = users(:corey)
    get(:random, { user_id: corey.id })
    assert_valid_must_be_logged_in
  end

  test "Random, logged in" do
    corey = users(:corey)
    UserSession.create(corey)
    get(:random, { user_id: corey.id })
    assert_response :found
    assert_equal corey, assigns[:entry].try(:author)
  end

  test "Recent, not logged in" do
    trevor = users(:trevor)
    get(:recent, { user_id: trevor.id })
    assert_valid_must_be_logged_in
  end

  test "Recent, logged in" do
    corey = users(:corey)
    c5 = gratefulness_entries(:c5)
    UserSession.create(corey)
    get(:recent, { user_id: corey.id })
    assert_response :found
    assert_equal c5, assigns[:entry]
  end

  test "Index, not logged in" do
    jim = users(:jim)
    get(:index, { user_id: jim.id })
    assert_valid_must_be_logged_in
  end

  test "Index, logged in" do
    jim = users(:jim)
    UserSession.create(jim)
    get(:index, { user_id: jim.id })
    assert_redirected_to new_user_entry_path(jim)
  end

end
