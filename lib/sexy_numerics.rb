module SexyNumerics
  module ClassMethods

    # Allows a column to accept commas from users for numeric fields. 
    # The commas are removed when the new value is assigned.
    #
    # Example:
    # class City < ActiveRecord::Base
    #   allow_commas :population, :foo, :bar
    def allow_commas(*args)
      add_equal_method ',', args
    end


    # Allows a column to accept currency symbols from users for numeric fields. 
    #
    # Example:
    # class City < ActiveRecord::Base
    #   allow_currency_symbols :annual_budget
    def allow_currency_symbols(*args)
      # Obviously US-centric, I need to make it international or customizable.
      # Some international symbols '¢£¥€ƒ$,'
      add_equal_method CURRENCY_CHARS, args 
    end


    # Allows a column to accept percent symbols from users for numeric fields. 
    #
    # Example:
    # class City < ActiveRecord::Base
    #   allow_percent_symbols :percent_unemployed
    def allow_percent_symbols(*args)
      # This assumes you are storing percents as whole numbers 50.0 = 50% 
      # rather than .5 = 50% 
      add_equal_method PERCENTAGE_CHARS, args
    end


    # Allows a column to accept various characters from users for numeric fields.
    #
    # Example:
    # class City < ActiveRecord::Base
    #   allow_characters :annual_budget, annual_expenses, :characters => %w[. € | _]
    #   -or-
    #   allow_characters :annual_budget, annual_expenses, :characters => '.€|_'
    def allow_characters(*args)
      options = args.extract_options!
      chars = options[:characters]
      if chars
        chars = chars.join if chars.respond_to? :join #allow arraylike or stringlike objects 
        add_equal_method chars, args 
      end
    end


    # Treats a column as a boolean, whether it's a tinyint, integer, float, 
    # string, etc.
    #
    # This is useful when you don't have control over how your booleans are 
    # used by different applications.  For example: Microsoft Access stores 
    # booleans as 0 and -1.  Normally -1 in a MySQL database, would be
    # converted, by Rails, into a false, rather than true as it should be.
    #
    # Example of use:
    # class Person < ActiveRecord::Base
    #   acts_as_boolean :alive, :employee, :vendor, :foo
    # 
    # Then you can use either foo or foo? and it properly returns true or false.
    #
    # The following are false, all else are true:
    #   0, nil, false, '', '0', 'f', 'false', 'n', 'no'
    def acts_as_boolean(*args)
      args.each do |arg|
        class_eval(
          %Q(
            def #{arg}?
              is_true?(#{arg}_before_type_cast)
            end
            alias :#{arg} :#{arg}?
          )
        )
      end # need to test performance of before_type_cast compared to other methods
    end

    private
      CURRENCY_CHARS = '¢$,'
      PERCENTAGE_CHARS = '%,'
    
      def add_equal_method(chars, args)
        args.each do |arg|
          class_eval(
            %Q(
              def #{arg}=(val)
                super(val.to_s.tr('#{chars}',''))
              end
            )
          )
        end
      end

  end

  module InstanceMethods

    protected
      def is_true?(value)
        falsies = [ 0, nil, false, '', '0', 'f', 'false', 'n', 'no' ]
        !falsies.include?(value)
      end
  end

end
 
class ActiveRecord::Base
  include SexyNumerics::InstanceMethods
end
ActiveRecord::Base.extend  SexyNumerics::ClassMethods

