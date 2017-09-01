#! /usr/bin/env ruby

require_relative 'CnGal_new_classes.rb'

##
# This is a stack-based parser that returns a tree in array format.
# Sub arrays are operations with higher priority. Operators are converted
# to symbol. It must be associated to Scp.
# Eg: 3 + 4 * 9 => `[3, :+, [4, :*, 9]]`
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Parser

  # Initialize two new variables: a counter and a boolean one
  # to report errors and stop the parser
  def initialize()
    @d = 0
    @error = false
  end
  
  # Re initializes the counter and the boolean variable
  def reset()
    @d = 0
    @error = false
  end
  
  # Main function that parses the string
  #
  # * **argument**: string to be parsed; the string must be the
  # output of scopify (see: Scp )
  # * **returns**: abstract tree array
  def parse(expr)
    array = Array.new
    until @d == expr.length
      c = expr[@d]
      case c
        when "("
          @d += 1
          calc = parse(expr)
          array.push calc if calc != nil 
        when ")"
          @d += 1
          return array
        when /[\*\/]/
          @d +=1
          array.push c.to_sym
        when /[\+\-\^]/
          @d+=1
          array.push c.to_sym
        when /\=/
          @d += 1
          array.push c.to_sym
        when /\>/
          @d += 1
          array.push c.to_sym
        when /\"/
          @d += 1
          array.push extract(expr)
        when /\~/
          @d += 1
          if expr[@d] == "("
            @d +=1
            calc = parse(expr)
            array.push calc unless calc == nil
          else
            array.push expr[@d]
            @d += 1
          end
        when /\./
          if expr[@d-1] =~ /[0-9]+/
            x = array.pop.to_s + c + expr[@d+1]
            array.push x.to_n
          else
            unless @error
              @error = true
              puts "Problem evaluating expression at index:#{@d}"
              puts "Invalid char '#{expr[@d]}' in string variable"
            end
            return
          end
          @d+=2
        when /\:/
          if expr[@d - 1] =~ /[a-zA-Z]+/ then
            x = array.pop.to_s + c
            array.push x.downcase.to_sym
          else
            unless @error
              @error = true
              puts "Problem evaluating expression at index:#{@d}"
              puts "Invalid char '#{expr[@d]}' in numeric variable"
            end
            return
          end
          @d += 1
        when /\_/
          @d += 1
          x = array.pop.to_s + c
          array.push x
        when /\p{Alnum}/ 
          if expr[@d-1] =~ /[0-9]/ && array.count > 0
            x = array.pop.to_s + c
            array.push x.to_n
          elsif (expr[@d-1] =~ /[a-z\A-Z]/ or expr[@d-1] == '_') && array.count > 0
            x = array.pop.to_s + c 
            array.push x 
          else 
            array.push c.to_n if c =~ /[0-9]/
            array.push c if c =~ /[a-zA-Z]/
          end          
          @d += 1
        else
          unless @error
            @error = true
            puts "Problem evaluating expression at index:#{@d}"
            puts "Char '#{expr[@d]}' not recognized"
          end
          return
      end
    end

    return array
  end
  
  # Extracts the content between quotes (it must not be parsed)
  #
  # * **argument**: string to extract the sub-string from
  # * **returns**: sub-string
  def extract(expr)
    ext = '"'
    while expr[@d] != '"' do
      ext += expr[@d]
      @d += 1
    end
    @d += 1
    return ext + '"'
  end
end

