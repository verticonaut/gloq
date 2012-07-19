class Glossaries::Term < ActiveRecord::Base
  self.table_name = :glossary_terms

  include Moodler::ModelTranslator
  localized_attributes  :name, :abbreviation, :description,
    :type        => :associated,
    :dependent   => :destroy,
    :foreign_key => :glossary_term_id

  belongs_to :glossary

  delegate :languages,
           :language_codes,
           :to => :glossary


  def self.search_by_name(name)
    # do this better
    return where('1=1') if name.blank?

    joins(:translations).where("lower(localized_glossary_terms.name) LIKE ?", "#{name.downcase}%")
  end

  def prepare_for_display
    glossary.language_codes.each do |glossary_locale|
      translations.new(locale: glossary_locale) unless self.translation(glossary_locale)
    end

    self
  end

end
