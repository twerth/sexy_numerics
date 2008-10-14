require File.dirname(__FILE__) + '/test_helper'

class SexyNumericsTest < Test::Unit::TestCase
  def setup
    @country = Country.new
    @person = Person.new
  end
  
  def teardown
    Country.delete_all
    Person.delete_all
  end
  
  def test_commas_are_parsed_for_allow_commas
    @country.population = "1,000,000"
    @country.save
    @country.reload
    assert_equal 1_000_000, @country.population
  end
  
  def test_currency_symbols_are_parsed_for_allow_currency_symbols
    @country.gross_domestic_product = "$5,000,000.55"
    @country.save
    @country.reload
    assert_equal 5_000_000.55, @country.gross_domestic_product
    @country.gross_domestic_product = ".55¢"
    @country.save
    @country.reload
    assert_equal 0.55, @country.gross_domestic_product
  end

  def test_allow_percent_symbols_are_parsed_for_allow_percent_symbols
    @country.percent_unemployement = "50.5%"
    @country.save
    @country.reload
    assert_equal 50.5, @country.percent_unemployement
  end

  def test_commas_are_not_parsed_without_allow_commas
    @person.annual_income = "50,000"
    @person.year_end_bonus = "1,000"
    @person.save
    @person.reload
    assert_equal 50.0, @person.annual_income
    assert_equal 1.0, @person.year_end_bonus
  end
end
