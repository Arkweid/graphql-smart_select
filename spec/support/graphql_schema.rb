# frozen_string_literal: true

require 'graphql'
require 'graphql/smart_select'

class BattleSchoolType < GraphQL::Schema::Object
  field :id, ID, null: false
  field :title, String, null: false
  field :prestige, Integer, null: false
  field :description, String, null: false
end

class CountrylType < GraphQL::Schema::Object
  field :id, ID, null: false
  field :name, String, null: false
end

class HorseType < GraphQL::Schema::Object
  field :id, ID, null: false
  field :name, String, null: false
end

class FeatType < GraphQL::Schema::Object
  field :id, ID, null: false
  field :title, String, null: false
  field :legend, String, null: false
end

class WitcherType < GraphQL::Schema::Object
  field_class.prepend(GraphQL::SmartSelect)

  field :id, ID, null: false
  field :name, String, null: false
  field :nickname, String, null: false
  field :weapon, String, null: false
  field :magic_level, Integer, null: false

  field :battle_school, BattleSchoolType, null: false
  field :country, CountrylType, null: false
  field :horse, HorseType, null: true
  field :feats, [FeatType], null: true, smart_select: true

  field :dangerous, String, null: false, db_columns: %i[weapon magic_level]

  def dangerous
    [object.weapon, object.magic_level].join
  end
end

class QueryRoot < GraphQL::Schema::Object
  field_class.prepend(GraphQL::SmartSelect)

  field :default_witchers, [WitcherType], null: false
  field :smarty_bool_witchers, [WitcherType], null: false, smart_select: true
  field :smarty_array_witchers, [WitcherType], null: false, smart_select: %i[id magic_level]

  %i[default_witchers smarty_bool_witchers smarty_array_witchers].each do |witcher_method|
    define_method(witcher_method) { Witcher.all }
  end
end

class Schema < GraphQL::Schema
  query QueryRoot
end
