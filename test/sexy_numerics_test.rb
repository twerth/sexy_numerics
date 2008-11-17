require File.dirname(__FILE__) + '/test_helper'

class SexyNumericsTest < Test::Unit::TestCase
  def setup
    @country = Country.new
    @person = Person.new

    # Make public for testing
    Person.send(:public, *Person.protected_instance_methods) 
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

  def test_check_multiple_assignments
    @person.annual_income = "$50,000"
    @person.year_end_bonus = "$1,000"
    @person.save
    @person.reload
    assert_equal 50_000.0, @person.annual_income
    assert_equal 1_000.0, @person.year_end_bonus
  end

  def test_commas_are_not_parsed_without_allow_commas
    @person.year_born = "50,000"
    @person.save
    @person.reload
    assert_equal 50, @person.year_born
  end

  def test_percent_division_options
    @country.percent_unemployement = "50%"
    @country.save
    @country.reload
    # assert_equal 50.5, @country.percent_unemployement
  end

  def test_allow_characters_with_german_euros
    @person.annual_income_in_germany = "€123.456.790"
    @person.save
    @person.reload
    assert_equal 123_456_790, @person.annual_income_in_germany
  end

end
