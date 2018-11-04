# frozen_string_literal: true

module GraphQL
  module SmartSelect
    #
    # Provide methods to expose foreign keys
    # for belongs_to and has_one assosiations
    #
    module AssosiationResolver
      private

      ONE_TO_ONE = proc do |_, v|
        v.is_a?(ActiveRecord::Reflection::BelongsToReflection) ||
          v.is_a?(ActiveRecord::Reflection::HasOneReflection)
      end.freeze

      HAS_MANY = proc do |_, v|
        v.is_a?(ActiveRecord::Reflection::HasManyReflection)
      end.freeze

      FOREIGN_KEYS = proc do |assosiation_name, assosiation_class|
        assosiation_class.options[:foreign_key] || assosiation_name + ID_POSTFIX
      end.freeze

      ID_POSTFIX = '_id'

      def assosiation_fields
        foreign_keys | primary_key
      end

      def foreign_keys
        required_keys = value.reflections.select(&ONE_TO_ONE).keys & query_fields

        value.reflections.slice(*required_keys).map(&FOREIGN_KEYS).map(&:to_s)
      end

      def primary_key
        primary_key_required? ? [value.primary_key] : []
      end

      def primary_key_required?
        (value.reflections.select(&HAS_MANY).keys & query_fields).any?
      end
    end
  end
end
