# frozen_string_literal: true

require 'graphql/smart_select/assosiation_resolver'
require 'graphql/smart_select/options_resolver'

module GraphQL
  module SmartSelect
    #
    # Resolve the minimum required fields for the query
    #
    class Resolver
      CAMEL_CASE_TO_SNAKE = [/([a-z\d])([A-Z])/, '\1_\2'].freeze

      include AssosiationResolver
      include OptionsResolver

      attr_reader :value, :ctx, :smart_select, :db_columns

      def initialize(value, ctx, smart_select, db_columns)
        @smart_select = smart_select
        @db_columns = db_columns
        @value = value
        @ctx = ctx
      end

      def resolve
        reject_virtual_fields(
          query_fields | assosiation_fields | db_columns_fields | smart_select_fields
        ).map(&:to_sym)
      end

      private

      def query_fields
        @query_fields ||= list_of_nodes.keys.map { |key| underscorize(key) }
      end

      def underscorize(str)
        str.gsub(*CAMEL_CASE_TO_SNAKE).downcase
      end

      def list_of_nodes
        @list_of_nodes ||= ctx.irep_node.typed_children[ctx.type.unwrap]
      end

      def reject_virtual_fields(fields_for_select)
        value.model.column_names & fields_for_select
      end
    end
  end
end
