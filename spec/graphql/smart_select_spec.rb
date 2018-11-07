# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphQL::SmartSelect do
  before(:all) do
    TestData.build
  end

  subject do
    track_queries { GQL.query(query) }
  end

  context 'without smart select' do
    let(:query) do
      %(
        query {
          defaultWitchers {
            name
          }
        }
      )
    end

    it 'fetch all columns' do
      expect(subject.first).to eq('SELECT "witchers".* FROM "witchers"')
    end
  end

  context 'with smart_select' do
    context 'where option defined as Boolean' do
      let(:query) do
        %(
          query {
            smartyBoolWitchers {
              name
              weapon
            }
          }
        )
      end

      it 'fetch only requested columns' do
        expect(subject.first).to eq('SELECT "witchers"."name", "witchers"."weapon" FROM "witchers"')
      end
    end

    context 'where option defined as Array' do
      let(:query) do
        %(
          query {
            smartyArrayWitchers {
              name
              weapon
            }
          }
        )
      end

      it 'fetch requested columns plus columns from option' do
        expect(subject.first).to eq('SELECT "witchers"."id", "witchers"."name", "witchers"."weapon", "witchers"."magic_level" FROM "witchers"')
      end
    end

    context 'belongs_to assosiation' do
      let(:query) do
        %(
          query {
            smartyBoolWitchers {
              name
              weapon
              battleSchool { title }
            }
          }
        )
      end

      it 'fetch only requested columns plus foreign_key for assosiation' do
        expect(subject.first).to eq('SELECT "witchers"."battle_school_id", "witchers"."name", "witchers"."weapon" FROM "witchers"')
      end
    end

    context 'has_one assosiation' do
      let(:query) do
        %(
          query {
            smartyBoolWitchers {
              name
              weapon
              horse { name }
            }
          }
        )
      end

      it 'fetch only requested columns plus foreign_key for assosiation' do
        expect(subject.first).to eq('SELECT "witchers"."horse_id", "witchers"."name", "witchers"."weapon" FROM "witchers"')
      end
    end

    context 'db_columns option' do
      let(:query) do
        %(
          query {
            smartyBoolWitchers {
              dangerous
            }
          }
        )
      end

      it 'fetch only requested columns plus columns from option' do
        expect(subject.first).to eq('SELECT "witchers"."weapon", "witchers"."magic_level" FROM "witchers"')
      end
    end

    context 'assosiation with foreign_key option in model' do
      let(:query) do
        %(
          query {
            smartyBoolWitchers {
              weapon
              country { name }
            }
          }
        )
      end

      it 'fetch only requested columns plus explicit foreign_key' do
        expect(subject.first).to eq('SELECT "witchers"."weapon", "witchers"."land_id" FROM "witchers"')
      end
    end

    context 'nested assosiation' do
      let(:query) do
        %(
          query {
            smartyBoolWitchers {
              name
              weapon
              feats { title }
            }
          }
        )
      end

      it 'fetch only requested columns plus primary_key for has_many assosiation' do
        expect(subject.first).to eq('SELECT "witchers"."id", "witchers"."name", "witchers"."weapon" FROM "witchers"')
        expect(subject.second).to eq('SELECT "feats"."title" FROM "feats" WHERE "feats"."witcher_id" = ?')
      end
    end

    context 'through Relay Connections' do
      let(:feats_count) { '2' }
      let(:data) do
        GQL.query(%(
          query {
            featsConnection(first: #{feats_count}) {
              edges {
                cursor
                node {
                  title
                  legend
                }
              }
            }
          }
        ))
      end
      let(:queries) { track_queries { data } }
      let(:value) { (ActiveRecord::VERSION::MAJOR < 5) ? feats_count : '?' }

      it 'fetch necessary fields with limit' do
        expect(queries.first).to eq('SELECT "feats"."id", "feats"."title", "feats"."legend" FROM "feats" LIMIT ' + value)
        expect(data['featsConnection']['edges'].size).to eq(feats_count.to_i)
      end
    end

    context 'all cases together' do
      let(:feats_count) { '3' }
      let(:query) do
        %(
          query {
            smartyBoolWitchers {
              name
              dangerous
              feats { legend }
              horse { name }
              country { name }
              battleSchool { title }
            }
            featsConnection(first: #{feats_count}) {
              edges {
                cursor
                node {
                  legend
                }
              }
            }
          }
        )
      end
      let(:value) { (ActiveRecord::VERSION::MAJOR < 5) ? feats_count : '?' }

      it 'fetch necessary fields' do
        expect(subject.first).to eq('SELECT "witchers"."id", "witchers"."battle_school_id", "witchers"."horse_id", "witchers"."name", "witchers"."weapon", "witchers"."magic_level", "witchers"."land_id" FROM "witchers"')
        expect(subject.second).to eq('SELECT "feats"."legend" FROM "feats" WHERE "feats"."witcher_id" = ?')
        expect(subject.last).to eq('SELECT "feats"."id", "feats"."legend" FROM "feats" LIMIT ' + value)
      end
    end
  end
end
