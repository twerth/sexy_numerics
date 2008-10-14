class Country < ActiveRecord::Base
  allow_commas              :population
  allow_currency_symbols    :gross_domestic_product
  allow_percent_symbols     :percent_unemployement
end
