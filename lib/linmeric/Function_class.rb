#! /usr/bin/env ruby

require_relative 'CnGal_new_classes.rb'
require_relative 'Integrators.rb'

##
# This class provides a simple representation of a function and some method
# to manipulate it
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Function
  
  # Creates a new `Function` object
  # * **argument**: string to be converted (and representing a function) 
  def initialize(str)
    @inp = str
    @vars = []
    @i = 0
    @funct = convert(str)
  end
  
  # Tells whether the function has been correctly converted from the string
  # format
  #
  # * **returns**: +true+ if the function has been successfully converted; +false+ else
  def ok? 
    @funct == nil ? (return false) : (return true)
  end
  
  # Returns the function as a ruby block ({ |...| ... })
  # * **argument**: number of variables needed for the block; default value is set if n == 0
  # * **returns**: string that represents the block; +nil+ if an error is found
  def to_block(n = 0)
    return nil if not self.ok?
    return nil if n < @vars.size
    n = @vars.size if n == 0
    b_v = "|#{vars(n)}|" if n > 0
    return "{ #{b_v} #{@funct} }"
  end
  
  # Builds the list of the variables needed for the block
  #
  # * **argument**: number of variables needed for the block
  # * **returns**::
  #   * +nil+ if an error occourred while converting the function
  #   * +nil+ if `n` is less than the number of variables of the function
  #   * string representation of the list
  def vars(n = 0)
    n = @vars.size if n == 0
    return nil if not self.ok?
    return nil if n < @vars.size 
    var = (@vars.size > 0) ? @vars[0] : ""
    for i in 1...@vars.length do
      var += ',' + @vars[i]
    end
    if n != @vars.size then
      i = 0
      ('a'..'z').each do |ch|
        unless @vars.include? ch
          i +=1
          var += ',' unless var == ""
          var += ch
          break if i == (n - @vars.size)
        end
      end
    end
    return var
  end
  
  # * **returns**: string representation of the function
  def to_s
    return @inp
  end
 
  # Integrates the function according to the specified method (see: Integrators)
  #
  # * **argument**: dimension of the range; see: Dim
  # * **argument**: number of points for integration
  # * **argument**: method to integrate the function (optional). 'simpson' is default
  # * **returns**: 
  #   * Numeric value as result
  #   * +nil+ if an error occourred
  def integrate(r,n,m = 'simpson')
    return nil unless self.ok?
    block = self.to_block(1)
    unless block == nil
      m = (m - '"').downcase
      case m
        when "trapezes"
          return eval("Integrators.trapezi(r.sx,r.dx,n)#{block}")
        when "midpoint"
          return eval("Integrators.simpson(r.sx,r.dx,n)#{block}")
        when "simpson"
          return eval("Integrators.simpson(r.sx,r.dx,n)#{block}")
        when "rectl"
          return eval("Integrators.rettsx(r.sx,r.dx,n)#{block}")
        when "rectr"
          return eval("Integrators.rettdx(r.sx,r.dx,n)#{block}")
        when "boole"
          return eval("Integrators.boole(r.sx,r.dx,n)#{block}")
        else
          puts "Argument Error: Invalid integration method";
          return nil
      end
    end
    puts "Argument Error: bad function for integration";
    return nil
  end
  
 private
  
  # Splits the input string into its components (variables,operators...)
  # 
  # * **argument**: input function in string format (inserted by the user)
  # * **returns**: array containing the components of the function 
  def tokenize(str)
    tokens = Array.new
    x = ""
    str.each_char do |ch|
      case ch
        when /[\+\-\*\/\^\(\)]/
          tokens.push ch
        when /[a-zA-Z\0-9\.]/
          x = tokens.pop if not '+-*/^()'.include? tokens[tokens.size - 1].to_s and tokens.size > 0
          tokens.push (x + ch)
          x = ""
        else
          return nil
      end
    end
    return tokens
  end
  
  # Converts the function inerted by the user in a function written in Ruby language
  #
  # * **argument**: input function in string format (inserted by the user)
  # * **returns**: function understandable by Ruby in string format
  def convert(str)
    return nil unless str.is_a? String
    str = tokenize(str)
    return nil if str == ""
    return nil unless balanced_brackets? str
    return translate(str)
  end
  
  # Checks if the brackets are balanced in the input function
  #
  # * **argument**: array of the function components 
  # * **returns**:
  #   * +nil+ if `expr` is not an array
  #   * +true+ if the brackets are balanced; +false+ else
  def balanced_brackets?(expr)
    return nil unless expr.is_a? Array
    brakets = 0
    expr.each do |el|
      case el
        when '('
          brakets += 1
        when ')'
          brakets -= 1
      end
    end
    brakets == 0 ? (return true) : (return false)
  end
  
  # Translates the function from linmeric language to Ruby language
  # using a turing machine to detect possible errors
  #
  # * **argument**: array of the function components
  # * **argument**: boolean to identify whether we are inside brackets or not. +false+ default
  # (out brackets)
  # * **returns**:
  #   * +nil+ if `str` is not an array
  #   * function in Ruby language in string format 
  def translate(str,open_b = false)
    return nil unless str.is_a? Array
    funct = ""
    state = 0
    while @i < str.size
      case state
      
        # beginning state
        when 0
          case str[@i]
            when /[\+\-]/
              funct += str[@i]
              state = 1
            when /\p{Alpha}/
              if Tool.f.include? str[@i] then
                funct += "Math::#{str[@i]}"
                state = 4 unless str[@i] == "PI"
                state = 2 if str[@i] == "PI"
              elsif str[@i].size == 1
                ch = str[@i].downcase
                funct += ch
                @vars << ch unless @vars.include? ch
                state = 2
              else
                return nil
              end
            when /[0-9]+/
              if str[@i].integer? or str[@i].float? then
                funct += str[@i]
                state = 2
              else
                return nil
              end
            when "("
              funct += "("
              @i += 1
              part = translate(str,true)
              state = 2
              if part != nil then
                funct += part
              else
                return nil
              end
            else
              return nil
          end
          
        # state 1 expects or a variable (single char) or a number or a function or (
        when 1
          case str[@i]
            when /\p{Alpha}/
              if Tool.f.include? str[@i] then
                funct += "Math::#{str[@i]}"
                state = 4 unless str[@i] == "PI"
                state = 2 if str[@i] == "PI"
              elsif str[@i].size == 1
                ch = str[@i].downcase
                funct += ch
                @vars << ch unless @vars.include? ch
                state = 2
              else
                return nil
              end
            when /[0-9]+/ 
              if str[@i].integer? or str[@i].float? then
                funct += str[@i]
                state = 2
              else
                return nil
              end
            when "("
              funct += "("
              state = 3
            else
              return nil
              
          end
        
        # state 2 expects an operator or )
        when 2
          if /[\+\-\*\/\^]{1}/ =~ str[@i] then
            funct += str[@i] if str[@i] != "^"
            funct += "**" if str[@i] == "^"
            state = 1
          elsif str[@i] == ")"
            if open_b then
              return funct + ")"
            else
              return nil
            end
          else
            return nil
          end
       
        # state 3 expects a sub_expression not beginnin with (
        when 3
          part = translate(str,true)
          state = 2
          if part != nil then
            funct += part
          else
            return nil
          end
        
        # state 4 expects a sub_expression beginning with (
        when 4
          if str[@i] == '(' then
            @i += 1
            part = translate(str,true)
            state = 2
            if part != nil then
              funct += '(' + part
            else
              return nil
            end
          else
            return nil
          end
          
        else
          return nil
      end
    @i += 1
    end
    return nil if state == 1
    return funct
  end
  
end



