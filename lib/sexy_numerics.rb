module SexyNumerics
  module ParserMethods

    def allow_commas(*args)
      add_equal_method ',', args
    end

    def allow_currency_symbols(*args)
      # Obviously US-centric, I need to make it international.
      # Perhaps when entered as cents (who does this?) divide by 100?  55¢ == 0.55 .
      # Some international symbols '¢£¥€ƒ$,'
      add_equal_method '¢$,', args 
    end

    def allow_percent_symbols(*args)
      # This assumes you are storing percents as whole numbers 50.0 = 50% rather than .5 = 50% 
      add_equal_method '%,', args
    end

    private
    
      def add_equal_method(chars, *args)
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
end
 
ActiveRecord::Base.extend SexyNumerics::ParserMethods

