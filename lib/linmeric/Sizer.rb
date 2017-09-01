#! /usr/bin/env ruby

require_relative 'Token.rb'
require_relative 'Lexer.rb'
require_relative 'Error_print.rb'
require_relative 'CnGal_new_classes.rb'

##
# Sizer analyzes the sintax of the inserted commands printing
# errors if they are found, before the string is manipulated by Scp
# and parsed by Parser.
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Sizer

  # Builds a new lexer
  def initialize()
    @lexer = Lexer.new
  end
  
  # Analyzes the stream of tokens to check the sintax. It uses
  # a turing machine to find errors.
  #
  # * **argument**: input comand string to analyze or stream of tokens (array)
  # * **argument**: boolean value which identifies the possibility to find the 
  # assign symbol `=`. +true+ is default (`=` is allowed)
  # * **returns**: +true+ if the sintax is correct; +false+ else
  def analyze(string, equal = true)  
    @i = 0
    state = 0
    return false if string == ""
    @@string = string if string.is_a? String
    unless string.is_a? Array
      unless balanced_brackets? string
        puts "Sintax Error: unbalanced brackets"
        return false 
      end
    end
    token = @lexer.tokenize(string) unless string.is_a? Array
    token = string if string.is_a? Array
    while @i < token.size
    
      case state
        # beginning state
        when 0
          case token[@i].attribute
            when "SUM_OPERATOR"
              state = 1
            when "VARIABLE"
              state = 2
            when "NUMBER"
              state = 2
            when "L_BRACE"
              sizer = Sizer.new
              return false unless sizer.analyze(token[(@i+1)...token.size])
              @i += sizer.count + 1
              state = 2
            when "KEYWORD"
              case token[@i].me
                when "mx:"
                  state = 6
                when "integ:"
                  state = 7
                when "shwvar:"
                  unless equal
                    PrintError.reduced(token[@i],@@string)
                    return false
                  end
                  state = 5
                when "solve:"
                  state = 8
                when "f:"
                  state = 4
                else
                  if ["t:","det:","norm:","id_mx:","shw:"].include? token[@i].me then
                    unless equal or token[@i].me != "shw:"
                      PrintError.reduced(token[@i],@@string)
                      return false
                    end
                    state = 3
                  elsif not Tool.keys.include? token[@i].me then
                    PrintError.unknown(token[@i],@@string)
                    return false
                  else
                    PrintError.reduced(token[@i],@@string)
                    return false
                  end
              end
            else
              PrintError.default(token[@i],@@string)
              return false
          end
          
        # expecting numbers,variables, keywords, (
        when 1
          case token[@i].attribute
            when "NUMBER"
              state = 2
            when "VARIABLE"
              state = 2
            when "L_BRACE"
              sizer = Sizer.new
              return false unless sizer.analyze(token[(@i+1)...token.size])
              @i += sizer.count + 1
              state = 2
            when "KEYWORD"
              case token[@i].me
                when "mx:"
                  state = 6
                when "integ:"
                  state = 7
                when "shwvar:"
                  state = 5
                when "solve:"
                  state = 8
                when "f:"
                  state = 4
                else
                  if ["t:","det:","norm:","id_mx:"].include? token[@i].me then
                    state = 3
                  elsif not Tool.keys.include? token[@i].me then
                    PrintError.unknown(token[@i],@@string)
                    return false
                  else
                    PrintError.reduced(token[@i],@@string)
                    return false
                  end
              end
            else
              PrintError.default(token[@i],@@string)
              return false
          end
        
        # expecting operators, )
        when 2
          case token[@i].attribute
            when "OPERATOR"
              state = 1
            when "SUM_OPERATOR"
              state = 1
            when "EQUAL_OP"
              if equal
                unless @i + 1 >= token.size
                  sizer = Sizer.new
                  return sizer.analyze(token[(@i+1)...token.size],false)
                end
                PrintError.missing_expression_after_equal(@i+1,@@string)
                return false
              else
                PrintError.default(token[@i],@@string)
                return false
              end
            when "TO_FILE_OP"
              unless equal
                PrintError.default(token[@i],@@string)
                return false
              end
              state = 4
            when "R_BRACE"
              return true
            else
              PrintError.default(token[@i],@@string)
              return false
          end
        
        # expecting only variables or numbers
        when 3
          case token[@i].attribute
            when "VARIABLE"
              state = 2
            when "NUMBER"
              state = 2
            else
              PrintError.default(token[@i],@@string)
              return false
          end
          state = 5 if token[@i-1].me == "shw:"
          
        # expects blocks (full chek) than nothing
        when 4
          return false unless check_block(token)
          state = 5
          
        # expects nothing
        when 5
          PrintError.default(token[@i],@@string)
          return false
          
        # checking mx arguments (full check)
        when 6
          case token[@i].attribute
            when "KEYWORD"
              if token[@i].me == "from:" then
                @i += 1
                unless @i < token.size
                  PrintError.missing(token[@i-1],@@string)
                  return false
                end
                return false unless check_block(token)
                state = 2
              else
                PrintError.missmatch(token[@i],@@string,"keyword 'from:' or block")
                return false
              end
            when "QUOTES"
              return false unless check_block(token)
              unless @i+1 >= token.size
                if token[@i+1].attribute == "KEYWORD" then
                  @i += 1
#                  unless @i < token.size
#                    PrintError.missing(token[@i-1],@@string)
#                    return false
#                  end
                  unless token[@i].me == "as:"
                    PrintError.missmatch(token[@i],@@string,"keyword 'as:' or operator")
                    return false
                  end
                  @i += 1
                  unless @i < token.size
                    PrintError.missing_general_string(token[@i-1].position+token[@i-1],@@string)
                    return false
                  end
                  if token[@i].attribute == "QUOTES"
                    return false unless check_block(token)
                  else
                    unless token[@i].attribute == "VARIABLE"
                      PrintError.default(token[@i],@@string)
                      return false 
                    end
                  end
                end
              end
              state = 2
            else
              PrintError.missmatch(token[@i],@@string,"keyword 'from:' or block")
              return false
          end
          
        # checking integ arguments (full check)
        when 7  
          unless @i < token.size
            PrintError.missing(token[@i-1],@@string)
            return false
          end 
          if token[@i].attribute == "QUOTES" then
            return false unless check_block(token)
          elsif token[@i].attribute != "VARIABLE" then
            PrintError.missmatch(token[@i],@@string,"variable or block")
            return false
          end
          @i += 1
          unless @i < token.size
            PrintError.missing_integ_range(token[@i-1].position+1,@@string)
            return false
          end
          return false unless check_block(token)
          @i += 1
          unless @i < token.size
            PrintError.numPoint_missing(token[@i-1].position+1,@@string)
            return false
          end
          unless @i + 1 >= token.size
            if token[@i+1].attribute == "QUOTES" then
              @i += 1
              return false unless check_block(token)
            end
          end
          state = 2
          
        # checking solve args (full check)   
        when 8
          inner_state = 0
          while !(token[@i].attribute == "EQUALS_TO") and @i < token.size
            case inner_state  
              when 0
                if token[@i].attribute == "VARIABLE" or token[@i].attribute == "NUMBER" then
                  inner_state = 1
                elsif token[@i].attribute == "L_BRACE"
                  sizer = Sizer.new
                  return false unless sizer.analyze(token[(@i+1)...token.size])
                  @i += sizer.count + 1
                else
                  PrintError.unexpected_token_in_solve(token[@i],@@string)
                  return false
                end
              when 1
                if token[@i].attribute == "OPERATOR" then
                  inner_state = 0
                else
                  PrintError.unexpected_token_in_solve(token[@i],@@string)
                  return false
                end
            end
            @i += 1
          end  
          state = 1   
      end
      @i += 1
    end
    
    unless state == 2 or state == 5 
      if token[@i-1].attribute == "R_BRACE" then
        tk = token[@i-2]
      else
        tk = token[@i-1]
      end 
      PrintError.missing(tk,@@string)
      return false
    end
    return true
  end
  
  def count
    return @i
  end

 private
 
  # checks if the input expression has balanced brackets
  #
  # * **argument**: expression (string) to check
  # * **returns**: +true+ if brackets are balanced; +false+ else
  def balanced_brackets?(exp)
    open_b = 0
    for i in 0...exp.size
      open_b += 1 if exp[i] == "("
      open_b -= 1 if exp[i] == ")"
    end
    open_b == 0 ? (return true) : (return false)
  end 
  
  # Checks the sintax of a block, that is: QUOTES-STRING-QUOTES
  #
  # * **argument**: stream of tokens
  # * **returns**: +true+ if the sintax is correct; +false+ else
  def check_block(token)
    unless token[@i].attribute == "QUOTES" then
      PrintError.missmatch(token[@i],@@string,"quotes for block")
      return false
    end
    @i += 1
    unless @i < token.size
      PrintError.missing_general_string(token[@i-1].position+token[@i-1].me.size,@@string,)
      return false
    end
    unless token[@i].attribute == "GENERAL_STRING" then
      PrintError.missmatch(token[@i],@@string,"block argument")
      return false
    end
    @i += 1
    unless @i < token.size
      PrintError.no_final_quotes(@@string,token[@i-1].position+token[@i-1].me.size)
      return false
    end
    unless token[@i].attribute == "QUOTES" then
      PrintError.missmatch(token[@i],@@string,"quotes for block")
      return false
    end
    return true
  end
  
end
