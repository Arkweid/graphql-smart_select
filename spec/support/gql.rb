# frozen_string_literal: true

require 'graphql'

class GQL
  class QueryError < StandardError; end

  def self.query(query_string)
    document = GraphQL.parse(query_string)

    result = Schema.execute(
      document: document
    )

    raise QueryError, result['errors'] if result['errors'].present?

    result['data']
  end
end
