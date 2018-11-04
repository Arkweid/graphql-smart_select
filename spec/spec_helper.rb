# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'graphql/smart_select'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

require 'support/schema'
require 'support/activerecord_models'
require 'support/factories'
require 'support/graphql_schema'
require 'support/gql'

def track_queries
  selects = []
  queries_collector = lambda do |_name, _start, _finish, _id, payload|
    selects << payload
  end

  ActiveSupport::Notifications.subscribed(queries_collector, 'sql.active_record') do
    yield
  end

  selects.map { |sel| sel[:sql].strip.gsub('  ', ' ') }
end
