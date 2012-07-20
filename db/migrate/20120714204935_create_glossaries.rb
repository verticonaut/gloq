class CreateGlossaries < ActiveRecord::Migration
  def change
    create_table :glossaries do |t|
      t.string :languages_string, :null => false
      t.integer :terms_count, :default => 0

      t.timestamps
    end
  end
end
