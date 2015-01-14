module Multilang
  module Validators
    class TranslationCountValidator < ActiveModel::EachValidator

      def validate_each(record, attribute, value)
        count = record.send("#{attribute}").reject{|l,v| v.blank?}.size
        if count < options[:min]
          record.errors[:attribute] << (options[:message] || "has insufficient translations defined")
        end
      end

    end
  end
end