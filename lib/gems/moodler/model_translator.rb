module Moodler
  module ModelTranslator

    def self.included(base)
      base.extend(self)
    end

    DEFAULT_OPTIONS = {:type => :localizer, :null_value => ""}

    # Usage
    # localized_attributes :name, :description, {:type(?) => :associated, :translation_class_name(?) => "Localized::#{class_name}"(default) }
    # localized_attributes :version,            {:type(?) => :localizer(default)}
    # localized_attributes :updated_at,         {:type(?) => :model}
    def localized_attributes(*args)
      options         = args.last.is_a?(Hash) ? args.slice!(-1) : {}
      options         = DEFAULT_OPTIONS.merge(options)
      attributes      = args

      case options[:type]
        when :associated
          translations_class_name = options[:translation_class_name] || "::Localized::#{self.name}"

          has_many :translations, options.slice(:dependent).merge({:class_name => translations_class_name})
          default_scope :include => :translations

          class_eval <<-METHOD
            def translation(locale=I18n.locale)
              translations.find_by_locale(locale)
            end
          METHOD

          attributes.each do |attribute|
            class_eval <<-METHOD
              def #{attribute}(locale=I18n.locale)
                locale_model = translations.find_by_locale(locale)
                locale_model ? locale_model.#{attribute} : "#{options[:null_value]}"
              end
            METHOD
          end
        when :model
          attributes.each do |attribute|
            class_eval <<-METHOD
              def translated_#{attribute}(locale=I18n.locale)
                translation = self.send("#{attribute}_\#{locale}")
                translation ? translation : "#{options[:null_value]}"
              end
            METHOD
          end
        when :localizer
          attributes.each do |attribute|
            class_eval <<-METHOD
              def translated_#{attribute}(locale=I18n.locale)
                value = self.#{attribute}
                value_key = value.nil? ? :null_value : value
                I18n.t(":ar.\#{self.class}.values.#{attribute}.\#{value_key}")
              end
            METHOD
          end
        else
          raise "#{options[:type]} is not a valid attribute localization type."
      end

    end
  end
end
