#! /usr/bin/env ruby

##
# This modue provides a set of error messages for linmeric
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module PrintError

  # Main function that prints the error message
  #
  # * **argument**: message to be printed (string)
  # * **argument**: expression (commands) where the error has been found
  # * **argument**: error position
  def self.print(message,expression,pos)
    puts message
    puts expression
    puts " " * pos + "^"
  end
  
  # * **argument**: unexpected Token
  # * **argument**: expression (commands) where the error has been found
  def self.default(token,expression)
    message = "  Sintax Error: unexpected #{token.attribute} token '#{token.me}' found"
    self.print(message,expression,token.position)
  end
  
  # * **argument**: unexpected Token
  # * **argument**: expression (commands) where the error has been found
  def self.reduced(token,expression)
    message = "  Sintax Error: unexpected #{token.attribute} '#{token.me}' found"
    self.print(message,expression,token.position)
  end
  
  # * **argument**: unknown Token found
  # * **argument**: expression (commands) where the error has been found
  def self.unknown(token,expression)
    message = "  Sintax Error: unknown #{token.attribute} '#{token.me}' found"
    self.print(message,expression,token.position)
  end
  
  # * **argument**: missmatched Token found
  # * **argument**: expression (commands) where the error has been found
  # * **argument**: token type (String) expected
  def self.missmatch(token,expression,expectation)
    message = "  Sintax Error: expecting #{expectation} but #{token.attribute} token '#{token.me}' found"
    self.print(message,expression,token.position)
  end
  
  # * **argument**: Token arguments are missing for
  # * **argument**: expression (commands) where the error has been found
  def self.missing(token,expression)
    message = "  Sintax Error: missing argument for '#{token.me}' #{token.attribute}"
    self.print(message,expression,token.position)
  end
  
  # * **argument**: expression (commands) where the error has been found
  # * **argument**: position where the error is located
  def self.no_final_quotes(expression,position)
    message = "  Sintax Error: missing quotes for block"
    self.print(message,expression,position)
  end
  
  # * **argument**: position where the error is located
  # * **argument**: expression (commands) where the error has been found
  def self.missing_general_string(position,expression)
    message = "  Sintax Error: missing agument block"
    self.print(message,expression,position)
  end
  
  # * **argument**: position where the error is located
  # * **argument**: expression (commands) where the error has been found
  def self.numPoint_missing(position,expression)
    message = "  Sintax Error: number of points is missing"
    self.print(message,expression,position)
  end
  
  # * **argument**: position where the error is located
  # * **argument**: expression (commands) where the error has been found
  def self.missing_expression_after_equal(pos,expression)
    message = "  Sintax Error: missing expression after EQUAL operator"
    self.print(message,expression,pos)
  end
  
  # * **argument**: unexpected Token found
  # * **argument**: expression (commands) where the error has been found
  def self.unexpected_token_in_solve(token,expression)
    message = "  Sintax Error: unexpected #{token.attribute} token '#{token.me}' in 'solve:' args"
    self.print(message,expression,token.position)
  end
  
  # * **argument**: position where the error is located
  # * **argument**: expression (commands) where the error has been found
  def self.missing_integ_range(pos,expression)
    message = "  Sintax Error: missing integration range for 'integ:' method"
    self.print(message,expression,pos)
  end
  
end
