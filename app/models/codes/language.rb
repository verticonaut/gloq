class Codes::Language

  attr_accessor :language_code

  def initialize(language_code)
    @language_code = language_code
  end

  def self.translate_language_code(code, locale = I18n.locale)
    codes = Array(code)
    translations = codes.map { |code|
      I18n.t("codes.language.#{code}", locale)
    }

    codes.size == 1 ? translations.first : translations
  end

  def language(locale = I18n.locale)
    self.class.translate_language_code(language_code, locale)
  end



end
