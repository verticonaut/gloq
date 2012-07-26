class Glossaries::Term < ActiveRecord::Base
  self.table_name = :glossary_terms

  include Moodler::ModelTranslator
  localized_attributes  :name, :abbreviation, :description,
    :type        => :associated,
    :dependent   => :destroy,
    :foreign_key => :glossary_term_id

  belongs_to :glossary, :counter_cache => true

  delegate :languages,
           :language_codes,
           :to => :glossary


  def self.search_by_name_and_type(search_term, type)
    # do this better
    return where('1=1') if search_term.blank?

    search_term = search_term.downcase
    case type
      when 'term_start'
        joins(:translations).where("lower(localized_glossary_terms.name) LIKE ?", "#{search_term}%")
      when 'all'
        joins(:translations).where(<<-COND, search: "%#{search_term}%")
          (lower(localized_glossary_terms.name) LIKE :search
            or lower(localized_glossary_terms.abbreviation) LIKE :search
            or lower(localized_glossary_terms.description) LIKE :search)
        COND
      when 'term'
        joins(:translations).where("lower(localized_glossary_terms.name) LIKE ?", "%#{search_term}%")
      when 'abbreviation'
        joins(:translations).where("lower(localized_glossary_terms.abbreviation) LIKE ?", "%#{search_term}%")
      when 'description'
        joins(:translations).where("lower(localized_glossary_terms.description) LIKE ?", "%#{search_term}%")
      when 'term_description'
        joins(:translations).where(<<-COND, search: "%#{search_term}%")
          (lower(localized_glossary_terms.term) LIKE :search
            or lower(localized_glossary_terms.description) LIKE :search)
        COND
      else
        raise ArgumentError, "Invalid type: #{type}"
    end
  end

  def prepare_for_display
    glossary.language_codes.each do |glossary_locale|
      translations.new(locale: glossary_locale) unless self.translation(glossary_locale)
    end

    self
  end

end
