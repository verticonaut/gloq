class CreateLocalizedGlossaries < ActiveRecord::Migration
  def change
    create_table  :localized_glossaries do |t|
      t.integer   :glossary_id,  :null => false
      t.string    :locale,       :null => false
      t.string    :name,         :null => false
      t.string    :abbreviation
      t.text      :description

      t.timestamps
    end
  end
end
