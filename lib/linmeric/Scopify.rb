#! /usr/bin/env ruby
require_relative 'CnGal_new_classes.rb'

##
# This class manipulates a string representing an algebric expression
# underlining the higher priority operations putting them between brackets.
# Scp prepares strings to be parsed. It must work associated with Sizer.
# These rules are followed:
# * ... = ...             => (...) = (...) (same with `>`)
# * a + b * c             => a + (b * c) (same with `/`)
# * a ^ b                 => (a ^ (b))
# * <keyword>: <argument> => (<keyword>: <argument>)
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Scp

  # Initializes a new counter
  def initialize
    @i = 0 
  end

  # Main function that analyzes the string and puts the brackets where it
  # is necessary.
  #
  # * **argument**: string to be manipulated
  # * **returns**: manipulated string
  def scopify(expr)
    expr = insert_b(expr)
    @i         = 0
    n_expr     = ""
    last_empty = 0
    open_b     = 0
    open_p_b   = 0
    open_m_b   = 0
    eq         = false
    stack      = Array.new
    last_e     = Array.new
    state      = 0
    while @i < expr.size
      case expr[@i]
        # Each part between brackets is seen as a subexpression
        # and it is analyzed recoursively.
        when '('
          scp = Scp.new
          n_expr += expr[@i] + scp.scopify(extract(expr[(@i + 1)...expr.length])) 
          @i += scp.count  
        when /[\*\/]/
          # If there are open brackets of higher opertions
          # it closes them
          if open_m_b > 0
            n_expr += ')' * open_m_b
            last_empty = last_e.pop
            open_m_b = 0
            #open_b -= 1
          end
          if state == 2
            n_expr += ')' * open_p_b
            open_p_b = 0
            state = (stack.size > 0 ? stack.pop : 0)
          end
          # If it is not still analyzing a multiplication, it adds the brackets 
          # following the rules
          unless state == 1
            n_expr.insert last_empty, '(' 
            state = 1
            open_b += 1
          end
          n_expr += expr[@i]
          last_empty = n_expr.size # + 1
        when /[\+\-]/
          # higher priority operation brackets are closed
          # last_empty is shifted
          n_expr += ')' * open_p_b if open_p_b > 0
          n_expr += ')' * open_b if open_b > 0
          state = 0
          open_b = 0
          open_p_b = 0
          n_expr += expr[@i]
          last_empty = n_expr.size
        when /\^/
          # It begins to put between brackets the operation and its exponent
          if open_m_b > 0 then
            n_expr += ")" * open_m_b
            last_empty = last_e.pop
            #open_b -= 1
            open_m_b = 0
          end
          n_expr.insert last_empty, '(' unless state == 2
          last_empty += 1 unless state == 2
          n_expr += expr[@i] + (expr[@i+1] == '(' ? '' : '(')
          open_p_b += (expr[@i+1] == '(' ? 1 : (state == 2 ? 1:2))
          stack.push state unless state == 2
          state = 2
        when /\=/
          # The expression at the left of `=` is put between brackets
          # and a bracket at the right is opened
          # It closes previously opened brackets
          n_expr += ')' * open_p_b if open_p_b > 0
          n_expr += ')' * open_b   if open_b > 0
          n_expr += ')' * open_m_b if open_m_b >0
          open_b   = 0
          open_p_b = 0
          open_m_b = 0
          n_expr = '(' + n_expr + ')' + expr[@i]
          n_expr += '('
          last_empty = n_expr.size
          state = 0
          eq = true
        when /\>/
          n_expr += ')' * open_p_b if open_p_b > 0
          n_expr += ')' * open_b if open_b > 0
          open_b = 0
          open_p_b = 0
          n_expr = '(' + n_expr + ')' + expr[@i]
          last_empty = n_expr.size
        when /\:/
          n_expr.insert last_empty, '('
          n_expr += expr[@i]
          last_k = n_expr[(last_empty+1)...n_expr.size]
          open_m_b += 1 if  "mx:integ:as:from:".include? last_k
          last_e.pop if last_e.count > 0 and (last_k == "mx:" or last_k == "integ:")# or last_k == "solve:")
          last_e.push last_empty if last_k == "mx:" or last_k == "integ:"# or last_k == "solve:"
          last_empty = n_expr.size
          open_b += 1 unless "mx:integ:as:from:".include? last_k
        when /\"/
          n_expr += expr[@i]
          @i += 1
          n_expr += discard(expr)
          last_empty = n_expr.length
        when /\~/
          n_expr += ')' * open_p_b if open_p_b > 0
          n_expr += ')' * (open_b - 1 ) if open_b - 1 > 0
          open_p_b = 0
          open_b = 1
          state = (stack.size > 0 ? stack.pop : 0)
          n_expr += expr[@i]
          last_empty = n_expr.size 
        else
          n_expr += expr[@i]
      end
      @i += 1
    end
    # it closes all the opened brackets
    n_expr += ')' * open_m_b if open_m_b > 0
    n_expr += ')' * open_p_b if open_p_b > 0
    n_expr += ')' * open_b if open_b > 0
    n_expr += ')' if eq
    return n_expr
  end
  
  # Returns the current value of the counter
  def count()
    return @i
  end
  
  # Inserts a couple of brackets `()` before non-binary sum and diff.
  # operators
  #
  # * **argument**: string to be checked and manipulated
  # * **returns**: manipulated string
  def insert_b(expr)
    @i = 0
    string = false
    while @i < expr.size 
      string = (expr[@i] == "\"") ? (string ? false : true) : (string)
      if (expr[@i] == '-' or expr[@i] == '+') and ((expr[@i - 1] == '(') or (@i == 0)) and !string then
        expr.insert @i, '()'
      end
      @i += 1
    end
    return expr
  end
  
  private
  
  # Extracts the subexpression between brackets
  #
  # * **argument**: string to extract the sub expression from
  # * **returns**: subexpression (string)
  def extract(expr)
    n_expr = ""
    i = 0
    open_b = 0 
    until (i == expr.size) or ((expr[i] == ')') and (open_b == 0))
      n_expr += expr[i]
      open_b += 1 if expr[i] == '('
      open_b -= 1 if expr[i] == ')' and (i < expr.size - 1)
      i += 1
    end
    return n_expr + ')'
  end
  
  # Extracts the content between quotes
  #
  # * **argument**: string to extract the content from
  # * **returns**: content (substring)
  def discard(expr)
    extract = ""
    while expr[@i] != '"' do
      extract += expr[@i]
      @i += 1
    end
    return extract + expr[@i]
  end
end


#####################################
#               Tests               #
##################################### 
=begin
print ">"
inp = gets.chomp.compact
scp = Scp.new

while inp != 'exit'
  puts scp.scopify(inp)
  print '>'; inp = gets.chomp.compact
end

=end




