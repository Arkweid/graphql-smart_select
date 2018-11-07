[![Cult Of Martians](http://cultofmartians.com/assets/badges/badge.svg)](http://cultofmartians.com) [![Gem Version](https://badge.fury.io/rb/graphql-smart_select.svg)](https://badge.fury.io/rb/graphql-smart_select) [![Build Status](https://travis-ci.org/Arkweid/graphql-smart_select.svg?branch=master)](https://travis-ci.org/Arkweid/graphql-smart_select)

# GraphQL::SmartSelect

Plugin for [graphql-ruby](https://github.com/rmosolgo/graphql-ruby) which helps to select only the required fields from the database.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-smart_select'
```

## Problem explanation

Consider the following query:
```
query {
  posts {
    id
    title
  }
}
```

Ruby interface for serve this query:
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
In the default case, this will lead to the query: ```SELECT * FROM posts```. But we need only ```id``` and ```title```.
For tables with a large number of columns, this has a negative effect on performance.

## Usage

Let's use our plugin:
```ruby
module GraphqlAPI
  module Types
    class Query < GraphQL::Schema::Object
      # use plugin
      field_class.prepend(GraphQL::SmartSelect)

      # activate plugin
      field :posts, Types::Post, null: false, smart_select: true

      # You can also explicitly specify which fields
      # will be added
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
It perform following request:
```SELECT id, title, raw_content, another_content, user_id FROM posts```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
