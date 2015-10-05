require 'test_helper'

class Activerecord::BaseTest < Minitest::Test

  #####################
  # Setup and teardown
  #####################

  def setup
    Cat.search_option :anywhere
    Cat.search_fields [:description]

    # Pay attention to the position of 'Tiger in the sentence'
    @cat_start  = Cat.create(description: "Tiger is cute")
    @cat_middle = Cat.create(description: "a Tiger this is")
    @cat_end    = Cat.create(description: "This is a Tiger")
    @cat_name   = Cat.create(name: "Tiger cat", description: "haha")


    @results = {
      multi_fields: [@cat_start, @cat_middle, @cat_end, @cat_name],
      anywhere:     [@cat_start, @cat_middle, @cat_end],
      end_with:     [@cat_end],
      start_with:   [@cat_start]
    }
  end

  def teardown
    Cat.delete_all
  end

  #################################
  # Error cases and default values
  #################################

  def test_search_cat_method_generated_at_runtime
    assert Cat.respond_to?(:search_cat)
  end

  def test_records_that_not_contain_a_specific_word
    tiger_cats = Cat.search_cat("not exist")

    assert_instance_of ::Cat::ActiveRecord_Relation, tiger_cats
    assert tiger_cats.compact.empty?
  end

  def test_fail_if_unknown_search_option_param
    e = assert_raises(::ActiveRecord::SearchError) {
      Cat.search_option :unknown_option

      tiger_cats = Cat.search_cat("tiger")      
    }
    assert_equal e.message, ::ActiveRecord::SearchError.new.message
  end

  def test_fail_if_unknown_override_option_param
    e = assert_raises(::ActiveRecord::SearchError) {
      tiger_cats = Cat.search_cat("tiger", :unknown_option)
    }
    assert_equal e.message, ::ActiveRecord::SearchError.new.message
  end

  def test_anywhere_is_the_default_search_option
    Cat.search_option nil
    tiger_cats = Cat.search_cat("tiger")

    assert_instance_of ::Cat::ActiveRecord_Relation, tiger_cats
    assert_equal tiger_cats.to_a, @results[:anywhere] 
  end

  def test_prevent_from_sql_injection

    tiger_cats = Cat.search_cat("' OR name LIKE '%tiger")

    assert_instance_of ::Cat::ActiveRecord_Relation, tiger_cats
    assert tiger_cats.to_a.empty?  
  end

  def test_search_field_fail_if_no_argument
    assert_raises(::ArgumentError) {
      Cat.search_field
    }
  end

  ###############################
  # test on :search_field method
  ###############################

  def test_search_field_with_single_field_as_argument
    Cat.search_field :description

    tiger_cats = Cat.search_cat("tiger")

    assert_instance_of ::Cat::ActiveRecord_Relation, tiger_cats
    assert_equal tiger_cats.to_a, @results[:anywhere]   
  end

  def test_search_field_with_array_as_argument
    Cat.search_field [:name, :description]

    tiger_cats = Cat.search_cat("tiger")

    assert_instance_of ::Cat::ActiveRecord_Relation, tiger_cats
    assert_equal tiger_cats.to_a, @results[:multi_fields]   
  end

  def test_search_fields_with_single_field_as_argument
    Cat.search_fields :description

    tiger_cats = Cat.search_cat("tiger")

    assert_instance_of ::Cat::ActiveRecord_Relation, tiger_cats
    assert_equal tiger_cats.to_a, @results[:anywhere]   
  end

  def test_search_fields_with_array_as_argument
    Cat.search_fields [:name, :description]

    tiger_cats = Cat.search_cat("tiger")

    assert_instance_of ::Cat::ActiveRecord_Relation, tiger_cats
    assert_equal tiger_cats.to_a, @results[:multi_fields]   
  end

  #######################################################
  # Set search option by using the :search_option method
  #######################################################
  def test_default_option_fail_if_more_than_two_search_option
    e = assert_raises(::ArgumentError) {
      Cat.search_option :start_with, :anywhere
    }
  end

  [:start_with, :anywhere, :end_with].each do |o|
    class_eval <<-EOF
      def test_default_option_#{o.to_s}
        Cat.search_option(:#{o})
        tiger_cats = Cat.search_cat("tiger")

        assert_instance_of ::Cat::ActiveRecord_Relation, tiger_cats
        assert_equal tiger_cats.to_a, @results[:#{o}]
      end
    EOF
  end


  ##########################################################
  # Set search option using :search_MODEL :option parameter
  ##########################################################
  def test_param_option_fail_if_more_than_two_search_option
    e = assert_raises(ActiveRecord::SearchError) {
      Cat.search_cat "Tiger", start_with: true, anywhere: true
    }

    assert_equal e.message, ::ActiveRecord::SearchError.new.message
  end

  [:start_with, :anywhere, :end_with].each do |o|
    class_eval <<-EOF
      def test_param_option_#{o.to_s}
        Cat.search_option(:#{o})
        tiger_cats = Cat.search_cat("Tiger", :#{o})

        assert_instance_of ::Cat::ActiveRecord_Relation, tiger_cats
        assert_equal tiger_cats.to_a, @results[:#{o}]
      end
    EOF
  end

end
