module Multilang
  module Validators
    class TranslationCountValidator < ActiveModel::EachValidator

      def validate_each(record, attribute, value)
        count = record.send("#{attribute}").reject{|l,v| v.blank?}.size
        if count < options[:min]
          record.errors[attribute.sub('_before_type_cast','')] <<
            (options[:message] ||
             I18n.t('errors.messages.insufficient-translations',
                                         count: options[:min] )
            )
        end
      end

    end
  end
end
