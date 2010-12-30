module Multilang

  class MultilangTranslationKeeper
    attr_reader :model
    attr_reader :attribute
    attr_reader :translations

    def initialize(model, attribute)
      @model = model
      @attribute = attribute
      @translations = {}
      load!
    end

    def value(locale = nil)
      locale ||= actual_locale
      read(locale)
    end

    def to_s
      raw_read(actual_locale)  
    end

    def to_str(locale = nil)
      locale ||= actual_locale
      raw_read(locale)
    end

    def update(value)
      if value.is_a?(Hash)
        clear
        value.each{|k, v| write(k, v)}
      elsif value.is_a?(String)
        write(actual_locale, value)
      end
      flush!
    end

    def [](locale)
      read(locale)
    end

    def []=(locale, value)
      write(locale, value)
      flush!
    end

    def locales
      @translations.keys.map(&:to_sym)
    end

    def empty?
      @translations.empty?
    end

    private

    def actual_locale
      I18n.locale
    end

    def write(locale, value)
      @translations[locale.to_s] = value if I18n.available_locales.include?(locale)
    end

    def read(locale)
      MultilangTranslationProxy.new(self, locale)
    end

    def raw_read(locale)
      @translations[locale.to_s] || ''
    end

    def clear
      @translations.clear
    end

    def load!
      data = @model[@attribute].blank? ? nil : YAML::load(@model[@attribute])
      @translations = data.is_a?(Hash) ? data : {}
    end

    def flush!
      @model[@attribute] = @translations.ya2yaml
    end

  end
end 