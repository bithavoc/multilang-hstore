module Multilang
  module ActiveRecordExtensions

    module ClassMethods

      def multilang_accessible_translations
        class_variable_get(:@@multilang_accessible_translations)
      end

      def multilang(*args)

        options = {
          :required => false,
          :length => nil,
          :accessible => false,
          :format => nil
        }.merge(args.extract_options!)

        options.assert_valid_keys([:required, :length, :accessible, :format, :nil])

        define_translation_base! unless included_modules.include?(InstanceMethods)

        args.each do |attribute|

          define_method attribute do
            multilang_translation_keeper(attribute).value
          end

          define_method "#{attribute}=" do |value|
            multilang_translation_keeper(attribute).update(value)
          end

          define_method "#{attribute}_before_type_cast" do
            multilang_translation_keeper(attribute).translations
          end

          #attribute accessibility for mass assignment
          if options[:accessible]
            matr = multilang_accessible_translations + [attribute.to_sym]
            class_variable_set(:@@multilang_accessible_translations, matr)
          end

          module_eval do
            serialize "#{attribute}", ActiveRecord::Coders::Hstore
          end

          I18n.available_locales.each do |locale|

            define_method "#{attribute}_#{locale}" do
              multilang_translation_keeper(attribute)[locale]
            end

            define_method "#{attribute}_#{locale}=" do |value|
              multilang_translation_keeper(attribute)[locale] = value
            end

            # locale based attribute accessibility for mass assignment
            if options[:accessible]
              matr = multilang_accessible_translations + ["#{attribute}_#{locale}".to_sym]
              class_variable_set(:@@multilang_accessible_translations, matr)
            end

            # attribute presence validator
            if options[:required]
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
        include InstanceMethods

        define_method "multilang_translation_keeper" do |attribute|
          unless instance_variable_defined?("@multilang_attribute_#{attribute}")
            instance_variable_set("@multilang_attribute_#{attribute}", MultilangTranslationKeeper.new(self, attribute))
          end
          instance_variable_get "@multilang_attribute_#{attribute}"
        end

        unless class_variable_defined?(:@@multilang_accessible_translations)
          class_variable_set(:@@multilang_accessible_translations, [])
        end

      end

    end

    module InstanceMethods
      def mass_assignment_authorizer(role = :default)
        super(role) + (self.class.multilang_accessible_translations || [])
      end
    end #module InstanceMethods

  end #module ActiveRecordExtensions
end ##module Multilang

ActiveRecord::Base.extend Multilang::ActiveRecordExtensions::ClassMethods

