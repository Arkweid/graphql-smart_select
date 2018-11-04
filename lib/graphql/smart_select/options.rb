# frozen_string_literal: true

module GraphQL
  module SmartSelect
    #
    # Provide methods to expose keys for available
    # options db_columns and smart_select
    #
    class Options
      attr_reader :list_of_nodes, :smart_select

      def initialize(list_of_nodes:, smart_select:)
        @list_of_nodes = list_of_nodes
        @smart_select = smart_select
      end

      def expose
        db_columns_fields | smart_select_fields
      end

      private

      DB_COLUMNS = proc do |_, node|
        node.definition.metadata[:type_class].db_columns
      end

      def db_columns_fields
        list_of_nodes.flat_map(&DB_COLUMNS).compact.map(&:to_s)
      end

      def smart_select_fields
        smart_select.is_a?(Array) ? smart_select.map(&:to_s) : []
      end
    end
  end
end
