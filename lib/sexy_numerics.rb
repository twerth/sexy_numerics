module SexyNumerics
  module ParserMethods

    def allow_commas(*args)
      add_equal_method ',', args
    end

    # Obviously US-centric, I need to make it international or customizable.
    # Perhaps when entered as cents (who does this?) divide by 100?  55¢ == 0.55 .
    # Some international symbols '¢£¥€ƒ$,'
    def allow_currency_symbols(*args)
      add_equal_method CURRENCY_CHARS, args 
    end

    # This assumes you are storing percents as whole numbers 50.0 = 50% rather than .5 = 50% 
    def allow_percent_symbols(*args)
      add_equal_method PERCENTAGE_CHARS, args
    end

    def allow_characters(*args)
      options = args.extract_options!
      chars = options[:characters]
      if chars
        chars = chars.join if chars.respond_to? :join #allow arraylike or stringlike objects 
        add_equal_method chars, args 
      end
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
end
 
ActiveRecord::Base.extend SexyNumerics::ParserMethods

