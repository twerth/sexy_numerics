ActiveRecord::Schema.define :version => 0 do
  
  create_table :countries, :force => true do |t|
    t.column :name, :string, :limit => 50
    t.column :population, :integer
    t.column :gross_domestic_product, :float
    t.column :percent_unemployement, :float
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
  end
  
  create_table :people, :force => true do |t|
    t.column :first_name, :string, :limit => 25
    t.column :last_name, :string, :limit => 25
    t.column :year_born, :integer
    t.column :annual_income, :float
    t.column :annual_income_in_germany, :float
    t.column :year_end_bonus, :float
    t.column :ira_contribution_percentage, :float
    t.column :alive, :boolean
    t.column :employed, :integer
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
  end
  
end
