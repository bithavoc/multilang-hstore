module Multilang
  class MultilangTranslationProxy < String
    attr_reader :multilang_keeper

    def initialize(multi_keeper, locale)
      @multilang_keeper = multi_keeper
      super(@multilang_keeper.to_str(locale))
    end

    def translation
      @multilang_keeper
    end

    def to_s
      String.new(self)
    end

    def any
      @multilang_keeper.current_or_any_value
    end

    def current_or_default
      @multilang_keeper.current_or_default_value
    end
  end
end
