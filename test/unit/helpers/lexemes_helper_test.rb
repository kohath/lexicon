require 'test_helper'

class LexemesHelperTest < ActionView::TestCase
  include ApplicationHelper
  
  test "titleize_headwords_for" do
    assert_equal "Liter or litre", titleize_headwords_for(lexemes(:liter_lex))
  end
  
  test "titleize_headwords_for removes initial case duplicates" do
    assert_equal "Case", titleize_headwords_for(lexemes(:with_capitalized_and_uncapitalized_headwords))
  end
end
