# frozen_string_literal: true

module GraphQL
  module SmartSelect
    #
    # Provide method for convert
    # camelCase to snake_case
    #
    module UnderscorizeUtility
      def underscorize(str)
        str.gsub(*CAMEL_CASE_TO_SNAKE).downcase
      end

      private

      CAMEL_CASE_TO_SNAKE = [/([a-z\d])([A-Z])/, '\1_\2'].freeze
    end
  end
end
