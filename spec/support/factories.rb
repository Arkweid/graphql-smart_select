# frozen_string_literal: true

module TestData
  def self.build
    horse = Horse.create(name: 'Plotva')
    battle_school = BattleSchool.create(title: 'Wolf', prestige: 10, description: 'Wolf battle school')
    country = Country.create(name: 'Rivia')

    witcher = Witcher.create(
      name: 'Geralt',
      nickname: 'Geralt from Rivia',
      battle_school: battle_school,
      weapon: 'Double swords',
      magic_level: 2,
      horse_id: horse.id,
      land_id: country.id
    )

    witcher.feats.create(title: 'Novigrad Hero', legend: 'Many knows')
    witcher.feats.create(title: 'Wild Hunt Raider', legend: 'Several')
    witcher.feats.create(title: 'Unicorn... Yennefer...', legend: 'No one should know!')
  end
end
