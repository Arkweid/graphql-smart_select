# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :battle_schools, force: true do |t|
    t.column :title, :string
    t.column :prestige, :integer
    t.column :description, :text
  end

  create_table :witchers, force: true do |t|
    t.column :battle_school_id, :integer
    t.column :horse_id, :integer
    t.column :name, :string
    t.column :nickname, :string
    t.column :weapon, :string
    t.column :magic_level, :integer
    t.column :land_id, :integer
  end

  create_table :horses, force: true do |t|
    t.column :name, :string
    t.column :witcher_id, :integer
  end

  create_table :countries, force: true do |t|
    t.column :name, :string
  end

  create_table :feats, force: true do |t|
    t.column :title, :string
    t.column :legend, :string
    t.column :witcher_id, :integer
  end
end
