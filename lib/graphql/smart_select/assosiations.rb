# frozen_string_literal: true

module GraphQL
  module SmartSelect
    #
    # Provide methods to expose foreign keys
    # for belongs_to and has_one assosiations
    #
    class Assosiations
      attr_reader :relation, :query_fields

      def initialize(relation, query_fields)
        @relation = relation
        @query_fields = query_fields
      end

      def expose
        assosiations_keys
      end

      private

      def assosiations_keys
        relation.reflections.map do |assosiation_name, reflection|
          next unless required?(assosiation_name)

          if one_to_one?(reflection)
            reflection.options[:foreign_key]&.to_s || assosiation_name.foreign_key
          elsif has_many?(reflection)
            relation.primary_key
          else
            next
          end
        end.uniq
      end

      def required?(assosiation_name)
        query_fields.include? assosiation_name
      end

      def one_to_one?(reflection)
        reflection.is_a?(ActiveRecord::Reflection::BelongsToReflection) ||
          reflection.is_a?(ActiveRecord::Reflection::HasOneReflection)
      end

      def has_many?(reflection)
        reflection.is_a?(ActiveRecord::Reflection::HasManyReflection)
      end
    end
  end
end
