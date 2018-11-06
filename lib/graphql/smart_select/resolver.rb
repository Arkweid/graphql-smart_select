# frozen_string_literal: true

require 'graphql/smart_select/assosiations'
require 'graphql/smart_select/options'

module GraphQL
  module SmartSelect
    #
    # Resolve the minimum required fields for the query
    #
    class Resolver
      attr_reader :relation, :ctx, :smart_select

      def initialize(relation, ctx, smart_select)
        @smart_select = smart_select
        @relation = relation
        @ctx = ctx
      end

      def resolve
        reject_virtual_fields(
          query_fields |
            Assosiations.new(relation, query_fields).expose |
            Options.new(list_of_nodes, smart_select).expose
        ).map(&:to_sym)
      end

      private

      def list_of_nodes
        @list_of_nodes ||= ctx.irep_node.typed_children[ctx.type.unwrap]
      end

      def query_fields
        @query_fields ||= list_of_nodes.keys.map(&:underscore)
      end

      def reject_virtual_fields(fields_for_select)
        relation.model.column_names & fields_for_select
      end
    end
  end
end
