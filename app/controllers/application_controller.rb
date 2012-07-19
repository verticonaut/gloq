class ApplicationController < ActionController::Base
  protect_from_forgery

  def set_glossary_locale(locale)
    session[:glossary_locale] = locale
  end

  def get_glossary_locale
    session[:glossary_locale]
  end

  def glossary_locale(glossary_or_id)
    glossary = glossary_or_id.kind_of?(Numeric) ? Glossary.find(id.to_i) : glossary_or_id
    locale   = session[:glossary_locale]

    glossary_language_codes = glossary.language_codes
    return locale if locale && glossary_language_codes.include?(locale.to_s)

    locale = if glossary_language_codes.empty? || glossary_language_codes.include?(I18n.locale.to_s) then
      I18n.locale.to_s
    else
      glossary_language_codes.first
    end

    session[:glossary_locale] = locale
  end

  helper_method :glossary_locale
end
