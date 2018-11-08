[![Cult Of Martians](http://cultofmartians.com/assets/badges/badge.svg)](http://cultofmartians.com) [![Gem Version](https://badge.fury.io/rb/graphql-smart_select.svg)](https://badge.fury.io/rb/graphql-smart_select) [![Build Status](https://travis-ci.org/Arkweid/graphql-smart_select.svg?branch=master)](https://travis-ci.org/Arkweid/graphql-smart_select)

# GraphQL::SmartSelect

Plugin for [graphql-ruby](https://github.com/rmosolgo/graphql-ruby) which helps to select only the required fields from the database.

## Requirements

- Ruby >= 2.3.0
- `graphql-ruby` ~> 1.8.7
- `activerecord` >= 4.2

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-smart_select'
```

## The Problem

Consider the following query:
```
query {
  posts {
    id
    title
  }
}
```

Ruby interface for serving this query:
```ruby
module GraphqlAPI
  module Types
    class Query < GraphQL::Schema::Object
      field :posts, Types::Post, null: false

      def posts
        Post.all
      end
    end
  end
end
```
In the default case, this leads to the query: `SELECT * FROM posts`, and we only need `id` and `title`.
For tables with a large number of columns, this could have a negative effect on performance (due to both DB reads and ActiveRecord object instantiation).

## Usage

Smart Select works as en extension for `field_class`:

```ruby
module GraphqlAPI
  module Types
    class Query < GraphQL::Schema::Object
      # use plugin
      field_class.prepend(GraphQL::SmartSelect)

      # activate plugin
      field :posts, Types::Post, null: false, smart_select: true

      # You can also explicitly specify which fields
      # to include in every query
      field :posts, Types::Post, null: false, smart_select: [:id]

      def posts
        Post.all
      end
    end

    class Post < GraphQL::Schema::Object
      field_class.prepend(GraphQL::SmartSelect)

      field :id, ID
      field :title, String
      field :raw_content, String
      field :another_content, String
  
      # We'll tell the plugin which fields are needed
      # for resolve this field
      field :contents, db_columns: [:raw_content, :another_content]
      
      # For one_to_one AR assosiation we include foreign_key
      field :user, Types::User

      # For has_many AR assosiation we include primary_key
      field :comments, [Types::Comment]

      def contents
        [object.id, object.title].join
      end
    end
  end
end
```

For this example query:
```
query {
  posts {
    title
    contents
    user { name }
    comments { id }
  }
}
```

It performs the following query:
`SELECT id, title, raw_content, another_content, user_id FROM posts`

## Notes

[Custom Resolvers](http://graphql-ruby.org/fields/resolvers.html) are not supported.

Tested for activerecord version >= 4.2

## Development

For regression testing, run the following
```shell
# install Appraisals dependencies
bundle exec appraisal install
# run test suit through all dependencies listed in Appraisals file
bundle exec appraisal rake spec
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
