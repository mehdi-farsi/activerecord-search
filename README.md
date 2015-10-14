# ActiveRecord::Search

a lightweight search-engine using ActiveRecord

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-search'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-search

## Usage

This plugin permits, with few lines of code, to have a lightweight and steady ActiveRecord search engine.

Below is an example of the features offered by this plugin:

Use case:

A model named Post that contains 2 fields: `title:string` and `content:text`.

##### In `app/models/posts.rb`:

```ruby
class Post < ActiveRecord::Base
    search_field :content
    search_option :anywhere
end
```
##### In `app/controllers/posts_controller.rb`:

```ruby
class PostsController < ApplicationController

    def index
        Post.search_post("Ruby") # It uses the :search_field and :search_option values
        Post.search_post("Ruby", :start_with) # It's possible to override the :search_option value
        Post.search_post("Ruby", :start_with, [:name, :content]) # It's possible to override the :search_option and :search_field values
        
        # Some helper method are available
        Post.start_with("Ruby")      # all record that start with 'Ruby'
        Post.end_with("Ruby")        # all record that end with 'Ruby'
        Post.search_anywhere("Ruby") # all record that search anywhere with 'Ruby'
       
    end
    
    ...
end
```

## More about the API

##### search_option method (Call in model)

`search_option` method specifies where to search in the sentence. Available options:

- `:start_with` : the sentence starts with the pattern.
- `:end_with`   : the sentence ends with the pattern.
- `:anywhere`   : search anywhere in the sentence. [DEFAULT OPTION]

##### search_MODEL method

A method :search_MODEL is auto-generated. It's the method used in controller in our above example. some examples:
 
- for a model Post a method `search_post` is generated.
- for a model Book a method `search_book` is generated.

The method can accept a second argument which is a `search_option`. Example:

```ruby
class PostsController < ApplicationController

    def index
        Post.search_post("Ruby", :start_with) # See search_option method section for more information
    end
    
    ...
end
```

Append the model name to this method results from the following question: What is the probability that a `search` method already exists in the model?

In this example, the search-engine will search any posts that the content starts with `"Ruby"`.

##### search_field method

`search_field` method specifies which field is used for the search. It's possible to search in multiple fields by using the method `search_fields([])`: 

```ruby
class Post < ActiveRecord::Base
    search_fields [:title, :content]
end
```

In this example, the search-engine will search any posts that include `"Ruby"` in their content OR in their title.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mehdi-farsi/activerecord-search.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

