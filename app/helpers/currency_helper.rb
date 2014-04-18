module CurrencyHelper
    def currency_converter(value, currency)
        value_pretty = value
        case currency
        when "NOK", "DKK", "SEK", "ISK"
        	localeString(value_pretty, ' ', 3, ',', 'kr ')
        when "USD", "AUD", "NZD", "CAD"
        	localeString(value_pretty, ',', 3, '.', '$')
        when "EUR"
        	localeString(value_pretty, '.', 3, ',', '€')
        when "JPY"
        	localeString(value_pretty, ',', 3, '.', '¥')
        else
          localeString(value_pretty, ' ', 3, ',', '')
        end
    end
    def localeString(x, sep, grp, cent_seperator, currency)
    	s = x.split(".")[0]
        p = s.split(//, s.length).reverse.each_slice(grp).to_a.map{|o| o << sep}.join.reverse
        p[0] = ''
        currency + p + cent_seperator  + x.split(".")[1]
    end

# jQuery.fn.convert_money_field = function(){
#   $(this).each(function(i, e){
#     $(e).text(currency_converter(parseFloat($(e).attr("data-value"))))
#   })
# }
end