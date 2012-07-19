class CreateGlossariesTerms < ActiveRecord::Migration
  def change
    create_table :glossary_terms do |t|
      t.integer :glossary_id

      t.timestamps
    end
  end
end
