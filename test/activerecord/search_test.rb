require 'test_helper'

class Activerecord::SearchTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Activerecord::Search::VERSION
  end
end
