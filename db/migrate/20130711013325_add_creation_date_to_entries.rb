class AddCreationDateToEntries < ActiveRecord::Migration
  def change
    add_column :gratefulness_entries, :creation_date, :datetime
  end
end
