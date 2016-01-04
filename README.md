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

This plugin permits, with few lines of code, to have a lightweight and steady ActiveRecord search-engine.

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
        Post.start_with("Ruby")      # all records that start with 'Ruby'
        Post.end_with("Ruby")        # all records that end with 'Ruby'
        Post.search_anywhere("Ruby") # all records that search anywhere with 'Ruby'
       
    end
    
    ...
end
```

## More about the API

##### search_option method

`search_option` method specifies where to search in the sentence.<br />
Available options:

- `:start_with` : the sentence starts with the pattern.
- `:end_with`   : the sentence ends with the pattern.
- `:anywhere`   : search anywhere in the sentence. [DEFAULT OPTION]

##### search_field method

`search_field` method specifies which field is used for the search. It's possible to search in multiple fields by using the method `search_fields([])`: 

```ruby
class Post < ActiveRecord::Base
    search_fields [:title, :content] # search on :title OR :content 
end
```

##### search_MODEL method

A method :search_MODEL is auto-generated. some examples:
 
- for a model Post a method `search_post` is generated.
- for a model Book a method `search_book` is generated.

The method can accept more arguments. Example:

```ruby
class PostsController < ApplicationController

    def index
        Post.search_post("Ruby", :start_with) # See search_option method section for more information
        Post.search_post("Ruby", :start_with, [:name, :content]) # it's possible to override the search_field option
    end
    
    ...
end
```

Append the model name to this method results from the following question: What is the probability that a `search` method already exists in the model?

## Development

After checking out the repo, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mehdi-farsi/activerecord-search.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

> Please, feel free to star the project if you like it ! :)
