class ChangeGratefulnessEntryBodyTextToText < ActiveRecord::Migration
  def up
    change_column :gratefulness_entries, :body_text, :text
  end

  def down
    change_column :gratefulness_entries, :body_text, :string
  end
end
