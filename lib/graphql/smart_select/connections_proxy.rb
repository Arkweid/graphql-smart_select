# frozen_string_literal: true

module GraphQL
  module SmartSelect
    #
    # Check field for Connections type
    # Dig through edges -> nodes to db fields
    #
    module ConnectionsProxy
      module_function

      def call(ctx)
        return yield unless ctx.field.connection?

        digging('node') do
          digging('edges') do
            yield
          end
        end
      end

      def digging(node_name)
        yield[node_name].scoped_children.values.first
      end
    end
  end
end
