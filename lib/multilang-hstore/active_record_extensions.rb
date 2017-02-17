module Multilang
  module ActiveRecordExtensions

    def self.raise_mass_asignment_deprecation_error!
      raise Multilang::Exceptions::DeprecationError.new(":accessible was deprecated starting multilang-hstore >= 1.0.0 which is intended for Rails >= 4.0.0. Check more info about the deprecation of mass-asignment in Rails 4")
    end

    module ClassMethods

      def multilang(*args)

        options = {
          :required => false,
          :length => nil,
          :accessible => false,
          :format => nil,
          :sanitizer => nil
        }.merge(args.extract_options!)

        options.assert_valid_keys([:required, :length, :accessible, :format, :sanitizer, :nil])
       
        define_translation_base!
         
        args.each do |attribute|

          define_method attribute do
            multilang_translation_keeper(attribute, options[:sanitizer]).value
          end

          define_method "#{attribute}=" do |value|
            multilang_translation_keeper(attribute, options[:sanitizer]).update(value)
          end

          define_method "#{attribute}_before_type_cast" do
            multilang_translation_keeper(attribute, options[:sanitizer]).translations
          end

          #attribute accessibility for mass assignment
          if options[:accessible]
            Multilang::ActiveRecordExtensions.raise_mass_asignment_deprecation_error!
          end

          module_eval do
            serialize "#{attribute}", ActiveRecord::Coders::Hstore
          end if defined?(ActiveRecord::Coders::Hstore)

          if options[:required].is_a? Numeric
            module_eval do
              validates "#{attribute}_before_type_cast", :'multilang/validators/translation_count' => {min: options[:required]}
            end
          end

          I18n.available_locales.each do |locale|

            define_method "#{attribute}_#{locale}" do
              multilang_translation_keeper(attribute, options[:sanitizer])[locale]
            end

            define_method "#{attribute}_#{locale}=" do |value|
              multilang_translation_keeper(attribute, options[:sanitizer])[locale] = value
            end

            # locale based attribute accessibility for mass assignment
            if options[:accessible]
              Multilang::ActiveRecordExtensions.raise_mass_asignment_deprecation_error!
            end

            # attribute presence validator
            if options[:required] == true or locale_required?(options[:required], locale)
              module_eval do
                validates_presence_of "#{attribute}_#{locale}"
              end
            end

            #attribute maximal length validator
            if options[:length]
              module_eval do
                validates_length_of "#{attribute}_#{locale}", :maximum => options[:length]
              end
            end

            #attribute format validator
            if options[:format]
              module_eval do
                validates_format_of "#{attribute}_#{locale}", :with => options[:format]
              end
            end

          end
        end
      end

      private

      def define_translation_base!
        
        define_method "multilang_translation_keeper" do |attribute, sanitizer|
          unless instance_variable_defined?("@multilang_attribute_#{attribute}")
            instance_variable_set("@multilang_attribute_#{attribute}", MultilangTranslationKeeper.new(self, attribute, sanitizer))
          end
          instance_variable_get "@multilang_attribute_#{attribute}"
        end unless method_defined? :multilang_translation_keeper
        
      end

      def locale_required? options_required, locale
        options_required.is_a? Array and options_required.map(&:to_s).include?(locale.to_s)
      end

    end

  end #module ActiveRecordExtensions
end ##module Multilang

ActiveRecord::Base.extend Multilang::ActiveRecordExtensions::ClassMethods

