class Person < ActiveRecord::Base
  allow_currency_symbols    :annual_income, :year_end_bonus
  allow_percent_symbols     :ret_contribution_percentage

  # allow_characters          :annual_income_in_germany, :characters => %w[. € | _]
  allow_characters          :annual_income_in_germany, :characters => '.€' 
end
