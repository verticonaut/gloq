class CreateLocalizedGlossariesTerms < ActiveRecord::Migration
  def change
    create_table :localized_glossary_terms do |t|
      t.integer :glossary_term_id
      t.string  :locale
      t.string  :name
      t.string  :abbreviation
      t.string  :description

      t.timestamps
    end
  end
end
