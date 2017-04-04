require 'rubygems'

# If you're using bundler, you will need to add this
require 'bundler/setup'

require 'sinatra'

  def convertFromTen(number, outputBase)
    output = ''
    while (number > 0)
      remainder = number % outputBase
      number = (number/outputBase).floor
      if remainder >= 10
        # remainder = String.fromCharCode(55 + remainder)
        remainder = (55 + remainder).chr
      end
      output = remainder + output
    end
    output
  end

  def convertInteger(inBase, outBase, inString)
    print "got #{inBase}, #{outBase} .. #{inString}\n"
    inString.to_s.to_i(inBase.to_i).to_s(outBase.to_i).upcase
  end

  def convertDecToTen(inBase, inDecimal)
    number = inDecimal.to_s;
    total = 0;

    (number.to_s.length.downto(1)).each do |x|
      i = x-1
      current = number[i]
      if (((current.ord >= 65)&&(current.ord <= 90))||((current.ord >= 97)&&(current.ord <= 122)))
        if ((current.ord <= 90))
          current = (current.ord - 55).chr
        else
          current = (current.ord - 87).chr
        end
      end
      if current.to_i >= inBase.to_i
        print "something went wrong."
        return 0
      end
      total += current.to_i;
      total = total / inBase.to_f;
    end
    total
  end

  def convertDecFromTen(number, outBase)
    output = '.'
    number = number.to_f
    counter = 100
    while counter > 0
      counter-=1
      number = number * outBase.to_i
      numString = number.to_s
      current = number
      if numString.match('\.')
        current = numString.to_i
      end
      number = number-current
      if number == 0 && current == 0
        return output
      end
      if current >= 10
        output = output + (55 + current).ord.chr;
      else
        output = output + current.to_s;
      end
    end
    output
  end

  def convert(inBase,outBase,inString)
    inInt = '';
    inDecimal= '';
    final= '';
    if not inString.to_s.index('.').nil?
      (inInt,inDecimal) = inString.to_s.split('.')
      tmp = convertDecToTen(inBase, inDecimal)
      final = convertDecFromTen(tmp, outBase)
    else
      inInt = inString.to_s
    end
    convertInteger(inBase, outBase, inInt) + final
  end


get '/' do
# setting default values
params[:inBase] = 10 if params[:inBase].nil?
params[:outBase] = 2 if params[:outBase].nil?
params[:inString] = 10.1 if params[:inString].nil?

# setting the result
params[:outString] = convert(params[:inBase],params[:outBase],params[:inString])

# showing the HTML
# as is a simple examle, HTMl is inline, this should be a separated file
erb %{
<html>
  <head><title>Base Converter</title></head>
  <body style="    margin-left:auto; margin-right:auto; " >
<h1>Base Converter</h1>

<table style="border:0">
<form method="GET" action="/">
<tr><td>N&uacute;mero: </td><td><input type="text" value="<%= params[:inString] %>" name="inString" /></td></tr>
<tr><td>Base: </td><td><input type="text" value="<%= params[:inBase] %>" name="inBase" /></td></tr>
<tr><td>Base destino: </td><td><input type="text" value="<%= params[:outBase] %>" name="outBase" /></td></tr>
<tr><td><input type="submit" /></td></tr>
<tr><td>Resultado: </td><td><label><%= params[:outString] %></label></td></tr>

</form>
</table>

  </body>
</html>
} 
end
