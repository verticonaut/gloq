class Localized::Glossary < ActiveRecord::Base
  self.table_name = :localized_glossaries

  attr_accessible :abbreviation, :description, :glossary_id, :locale, :name

  validates_presence_of :locale
  validate              :validate_presence_of_name_or_description

  belongs_to :glossary, :class_name => "::Glossary"


  def validate_presence_of_name_or_description
    errors[:extra_name_or_description] << "Name or description must be given" if name.blank? && description.blank?
  end
end

