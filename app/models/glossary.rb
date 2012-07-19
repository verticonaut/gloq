class Glossary < ActiveRecord::Base
  include Moodler::ModelTranslator
  localized_attributes  :name, :description, :type => :associated, :dependent => :destroy

  validates_presence_of :languages_string
  validate              :validate_translations_defined

  attr_accessible       :languages_string

  has_many :terms, class_name: 'Glossaries::Term'


  def self.create_glossary(attributes)
    translations_attributes = attributes.extract!(:translations)[:translations]

    glossary = Glossary.new(attributes)

    (translations_attributes || []).each do |language, translation_attributes|
      localization_attrs = translation_attributes.merge(:locale => language)
      glossary.translations.new(localization_attrs) if Localized::Glossary.new(localization_attrs).valid?
    end

    glossary
  end

  def create_term(attributes)
    translations_attributes = attributes.extract!(:translations)[:translations]

    term = terms.new

    (translations_attributes || []).each do |language, translation_attributes|
      localization_attrs = translation_attributes.merge(:locale => language)
      term.translations.new(localization_attrs) if Localized::Glossaries::Term.new(localization_attrs).valid?
    end

    term
  end

  def update_glossary(attributes)
    transaction do
      translations_attributes = attributes.extract!(:translations)[:translations]

      self.assign_attributes(attributes)

      (translations_attributes || []).each do |language, translation_attributes|
        self.translation(language).tap do |translation|
          if translation
            translation.attributes = translation_attributes
            if translation.name.blank? && translation.description.blank?
              # delete the translation - we dont store empty stuff
              translation.delete
              translations(true)
              translation = nil
            end
          else
            localization_attrs = translation_attributes.merge(locale: language)
            if localization_attrs["name"].present? || localization_attrs["description"].present?
              # only create translation if has a value - we dont store empty stuff
              translation = self.translations.new(localization_attrs)
            else
              translation = nil
            end
          end

          if (translation && !translation.save)
            translation.errors.messages.each do |key, message|
              errors[:"extra_translations_[#{translation.locale}][#{key}]"] << message.first
            end
            raise 'Translation invalid'
          end
        end
      end
    end

    raise "Glossary is not valid" unless self.valid?

    save
  rescue Exception => e
    false
  end


  def language_codes
    return [] if languages_string.blank?

    languages_string.split(',').map { |lang| lang.strip }
  end

  def languages
    return [] if languages_string.blank?

    language_codes.map { |code| Codes::Language.new(code) }
  end


  def validate_translations_defined
    errors[:extra_translation] << "You need at least a translation with a name given" unless translations.any? { |translation| translation.name.present? }
  end

  def prepare_for_display
    self.language_codes.each do |glossary_locale|
      translations.new(locale: glossary_locale) unless self.translation(glossary_locale)
    end

    self
  end

end
