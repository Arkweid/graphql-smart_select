# frozen_string_literal: true

module GraphQL
  module SmartSelect
    #
    # Provide methods to expose keys for available
    # options db_columns and smart_select
    #
    module OptionsResolver
      private

      DB_COLUMNS = proc do |_, node|
        node.definition.metadata[:type_class].instance_variable_get('@db_columns')
      end.freeze

      def db_columns_fields
        list_of_nodes.flat_map(&DB_COLUMNS).compact.map(&:to_s)
      end

      def smart_select_fields
        smart_select.is_a?(Array) ? smart_select.map(&:to_s) : []
      end
    end
  end
end
