class Localized::Glossaries::Term < ActiveRecord::Base
  self.table_name = :localized_glossary_terms

  attr_accessible :abbreviation, :description, :locale, :name


  validates_presence_of :locale
  validate              :validate_presence_of_name_or_abbreviation_or_description

  belongs_to :term, :class_name => "::Glossaries::Term"


  def validate_presence_of_name_or_abbreviation_or_description
    if name.blank? && description.blank? && abbreviation.blank?
      errors[:extra_name_or_description] << "Name or description must be given"
    end
  end
end
