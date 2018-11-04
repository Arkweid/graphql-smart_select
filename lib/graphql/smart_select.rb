# frozen_string_literal: true

require 'graphql/smart_select/version'
require 'graphql/smart_select/resolver'

module GraphQL
  #
  # Apply additional scope to the AR query
  # which selects only the required fields
  #
  module SmartSelect
    attr_reader :db_columns, :smart_select

    def initialize(*args, **kwargs, &block)
      @smart_select = kwargs.delete(:smart_select)
      @db_columns = kwargs.delete(:db_columns)
      super
    end

    private

    def apply_scope(value, ctx)
      if smart_select && value.is_a?(ActiveRecord::Relation)
        fields_for_select = Resolver.new(value, ctx, smart_select).resolve

        value = ctx.schema.after_lazy(value) { |inner_value| inner_value.select(fields_for_select) }
      end
      super
    end
  end
end
