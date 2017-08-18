#! /usr/bin/env ruby

require_relative 'CnGal_tools.rb'
require_relative 'CnGal_new_classes.rb'
require_relative 'Token.rb'

##
# This simple Lexer tokenizes the input stream of commands for the sintax analyzer
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Lexer

  # Tokenizes the input stream according to particular tokenizer symbols
  # which determine the end of an element.Eg: a+3 => `+` determines the end of variable `a`
  # and the beginning of another element (`3`)
  #
  # * **argument**: string to tokenize
  # * **returns**: array of tokens (see: Token ) 
  def tokenize(expr)
    token = []
    temp = ""
    ignore = false
    pos = 0
    i = 0
    gen_exp = []
    tokenizers = Tool.operators + [" ","(",")",":",'"',"~"]
    while i < expr.size
      if  (tokenizers.include? expr[i]) then
        temp += ':' if expr[i] == ':'
        token << Token.new(temp, pos) unless temp == ""
        temp = ""
        token << Token.new(expr[i],i) unless " :".include? expr[i]
        gen_exp = extract_gen_exp(expr[(i+1)...expr.size]) if expr[i] == '"'
        token << Token.new(gen_exp[0],pos+1,"GENERAL_STRING") unless gen_exp == [] 
        i += gen_exp[1] unless gen_exp == []
        pos = i + ((gen_exp == []) ? 1 : 0)
        token << Token.new('"',pos) && pos += 1 if gen_exp[2]
        gen_exp = []
      else
        temp += expr[i]
      end
      i += 1
    end 
    token << Token.new(temp,pos) unless temp == ""
    return token
  end
   
 private
 
  # Reads all the content between quotes so that it can be classified as string
  #
  # * **argument**: string to extract the 'string' element
  # * **returns**: array with three elements:
  #   * 'string' element
  #   * counter `i`
  #   * boleean value to tell whether final quotes have been found (+true+ = found, +false+ = not found) 
  def extract_gen_exp(string)
    i = 0
    gen_exp = ""
    while i < string.size and string[i] != '"'
      gen_exp += string[i]
      i += 1
    end
    quotes = (string[i] == '"') ? true : false
    i += 1 if string[i] == '"'
    return [gen_exp,i,quotes]
  end
  
   
end
