require 'test_helper'

class GratefulnessEntryTest < ActiveSupport::TestCase

  # Next entry.

  test "Next entry from first" do
     t1 = gratefulness_entries(:t1)
     t2 = gratefulness_entries(:t2)
     t1_next = GratefulnessEntry.next_entry(t1.author, t1.creation_date)
     assert t1_next == t2
     assert t1.next == t2
  end

  test "Next entry from middle" do
    c2 = gratefulness_entries(:c2)
    c3 = gratefulness_entries(:c3)
    c2_next = GratefulnessEntry.next_entry(c2.author, c2.creation_date)
    assert c2_next == c3
    assert c2.next == c3
  end

  test "Next entry from last" do
    c5 = gratefulness_entries(:c5)
    c5_next = GratefulnessEntry.next_entry(c5.author, c5.creation_date)
    assert_nil c5_next
    assert_nil c5.next
  end

  test "Next entry, author with no entries" do
    jim = users(:jim)
    nil_next = GratefulnessEntry.next_entry(jim, DateTime.now)
    assert_nil nil_next
  end

  test "Next entry, nil author" do
    c1 = gratefulness_entries(:c1)
    nil_next = GratefulnessEntry.next_entry(nil, c1.creation_date)
    assert_nil nil_next
  end

  test "Next entry, nil ref date" do
    t2 = gratefulness_entries(:t2)
    nil_next = GratefulnessEntry.next_entry(t2.author, nil)
    assert_nil nil_next
  end

  test "Next entry, both args nil" do
    nil_next = GratefulnessEntry.next_entry(nil, nil)
    assert_nil nil_next
  end

  # Previous entry.

  test "Previous entry from first" do
     c1 = gratefulness_entries(:c1)
     c1_prev = GratefulnessEntry.previous_entry(c1.author, c1.creation_date)
     assert_nil c1_prev
  end

  test "Previous entry from middle" do
    t3 = gratefulness_entries(:t3)
    t2 = gratefulness_entries(:t2)
    t3_prev = GratefulnessEntry.previous_entry(t3.author, t3.creation_date)
    assert t3_prev == t2
    assert t3.previous == t2
  end

  test "Previous entry from last" do
    t5 = gratefulness_entries(:t5)
    t4 = gratefulness_entries(:t4)
    t5_prev = GratefulnessEntry.previous_entry(t5.author, t5.creation_date)
    assert t5_prev == t4
    assert t5.previous == t4
  end

  test "Previous entry, author with no entries" do
    jim = users(:jim)
    nil_next = GratefulnessEntry.previous_entry(jim, DateTime.now)
    assert_nil nil_next
  end

  test "Previous entry, nil author" do
    c2 = gratefulness_entries(:c2)
    nil_prev = GratefulnessEntry.previous_entry(nil, c2.creation_date)
    assert_nil nil_prev
  end

  test "Previous entry, nil ref date" do
    t3 = gratefulness_entries(:t3)
    nil_next = GratefulnessEntry.previous_entry(t3.author, nil)
    assert_nil nil_next
  end

  test "Previous entry, both args nil" do
    nil_prev = GratefulnessEntry.previous_entry(nil, nil)
    assert_nil nil_prev
  end

end
