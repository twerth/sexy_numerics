class Person < ActiveRecord::Base
  allow_currency_symbols    :annual_income, :year_end_bonus
  allow_commas              :year_born  
end
