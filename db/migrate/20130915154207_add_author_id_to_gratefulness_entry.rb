class AddAuthorIdToGratefulnessEntry < ActiveRecord::Migration
  def change
    add_column :gratefulness_entries, :author_id, :integer
  end
end
