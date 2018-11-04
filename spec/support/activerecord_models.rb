# frozen_string_literal: true

class Horse < ActiveRecord::Base
end

class BattleSchool < ActiveRecord::Base
  has_many :witchers
end

class Country < ActiveRecord::Base
  has_many :witchers
end

class Feat < ActiveRecord::Base
  belongs_to :witcher
end

class Witcher < ActiveRecord::Base
  belongs_to :battle_school
  belongs_to :country, foreign_key: :land_id
  has_one :horse
  has_many :feats
end
