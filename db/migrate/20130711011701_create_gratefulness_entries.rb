class CreateGratefulnessEntries < ActiveRecord::Migration
  def change
    create_table :gratefulness_entries do |t|
      t.string :body_text

      t.timestamps
    end
  end
end
