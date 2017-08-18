#! /usr/bin/env ruby

require_relative 'CnGal_tools.rb'
require_relative 'CnGal_new_classes.rb'

##
# This class generates a token object with three parameters:
# * Attribute
# * Position
# * Value
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Token

  OPERATORS = Tool.operators
  VARIABLE = /[a-zA-Z_][a-zA-Z0-9_]*/
  
  # Creates a new token object
  #
  # * **argument**: token value to name
  # * **argument**: token position
  # * **argument**: 'suggestion' (string) to force a specific attribute. "" default
  def initialize(to_token,pos,sugg = "")
    @My_pos = pos
    if OPERATORS.include? to_token then    
      @My_att = "OPERATOR" unless [">","=","+","-"].include? to_token
      @My_att = "EQUAL_OP" if to_token == "="
      @My_att = "TO_FILE_OP" if to_token == ">"
      @My_att = "SUM_OPERATOR" if '+-'.include? to_token
    elsif sugg != ""
      @My_att = sugg
    elsif to_token == "~"
      @My_att = "EQUALS_TO"
    elsif to_token.include? ":" then
      @My_att = "KEYWORD"
    elsif to_token.match(VARIABLE).to_s.size == to_token.size then
      @My_att = "VARIABLE"
    elsif to_token.number? then
      @My_att = "NUMBER"
    elsif to_token == "(" then
      @My_att = "L_BRACE"
    elsif to_token == ")" then
      @My_att = "R_BRACE"
    elsif to_token == '"' then
      @My_att = "QUOTES"
    else
      @My_att = "GENERAL_STRING"
    end
    @My_self = (to_token.include? ':') ? (to_token.downcase) : (to_token)
  end
  
  # * **returns**: token attribute
  def attribute
    return @My_att
  end
  
  # * **returns**: token position
  def position
    return @My_pos
  end
  
  # * **returns**: token value
  def me
    return @My_self
  end
  
#  def to_s
#   return [@My_att,@My_pos,@My_self]
#  end
end
