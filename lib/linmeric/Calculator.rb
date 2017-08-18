#! /usr/bin/env ruby

require_relative "CnGal_new_classes.rb"

##
# This file contains a simple expression evaluator
# to convert math binary operations in a result. 
# It is simply a calculator
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Calculator

  OP = ["+","-","*","/","^"]
  ##
  # Definition of a simple token with an attribute (@tag)
  # and a value (@val)
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Token
    # * **argument**: value to tokenize (String)
    def initialize(value)
      @val = value
      if OP.include? value then
        @tag = :OPERATOR
      elsif value.number? then
        @tag = :NUMBER
        @val = value.to_n
      elsif value == "(" then
        @tag = :L_PAR
      elsif value == ")" then
        @tag = :R_PAR
      end
    end 
    
    # * **returns**: value of the token 
    def value
      return @val
    end 
    
    # * **returns**: tag of the token
    def tag
      return @tag
    end
  end

  ##
  # This lexser creates the tokens splitting the input string
  # according to the operators (OP => see Calculator ) or brackets
  # it returns nil if an unaccepted char (non-number or non-OP or non-bracket)
  # is found
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Lexer
  
    # It creates the tokens according to `OP` or '(' and ')'
    #
    # * **argument**: the string that needs to be tokenized
    # * **returns**: array of tokens if all the chars are correct; +nil+ else   
    def tokenize(string)
      stream = []
      temp   = ""
      for i in 0...string.size
        if OP.include? string[i] or ["(",")"].include? string[i] then
          stream << Token.new(temp) unless temp == ""
          stream << Token.new(string[i])
          temp = ""
        elsif string[i].number? then
          temp += string[i]
        else
          return nil
        end
      end
      stream << Token.new(temp) unless temp == ""
      return stream
    end
  end
  
  ##
  # Evaluator parses and evaluates at the same time the stream of tokens
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Evaluator
    OPERATORS = {
      "+" => lambda do |a,b|
               return (a || 0) + (b || 0)
             end,
      "-" => lambda do |a,b|
               return (a || 0) - (b || 0)
             end,
      "*" => lambda do |a,b|
               return a * b
             end,
      "/" => lambda do |a,b|
               unless b != 0
                 @error = true 
                 return nil
               end
               return a / b.to_f
             end,
      "^" => lambda do |a,b|
               unless a != 0 and b != 0
                 @error = true
                 return nil
               end
               return a ** b
             end
    }
    
    # Evaluates the global expression
    #
    # * **argument**: stream of tokens (Array)
    # * **returns**: result of the operations; +nil+ if an error occourred 
    def evaluate(stream) 
      @stack  = []
      @stream = stream 
      @i      = 0
      @error  = false
      return parse 
    end
    
    # It parses the stream of tokens
    #
    # * **argument**: specific end-token (+nil+ default)
    # * **returns**: result of the operations; +nil+ if an error occourred
    def parse(m_end = nil) 
      @num    = []
      @op     = []
      st = state0_1(0)
      return nil if @error
      @i += 1
      while @i < @stream.size and current_tk.value != m_end do
        st = self.send(st)
        return nil if @error
        @i += 1
      end
      return nil if st == :state_0_1
      make_op
      return @num.pop
    end
    
    # State0_1 accepts only numbers or '('
    #
    # * **argument**: specification of which state must be runned (1 default)
    # * **returns**: next state (symbol)
    def state0_1(state = 1)
      case current_tk.tag
        when :NUMBER
          @num.push current_tk.value
        when :L_PAR
          @i += 1
          @stack.push @op
          @stack.push @num
          res = parse(")")
          @num = @stack.pop
          @num << res
          @op = @stack.pop
        when :OPERATOR
          if (["+","-"].include? current_tk.value) and (state)== 0 then
            @op.push current_tk.value
            return :state0_1
          else
            @error = true
          end
        else
          @error = true
      end
      return :state2
    end
    
    # State2 accepts only operators
    #
    # * **returns**: next state (symbol)
    def state2
      if current_tk.tag == :OPERATOR then
        if @op.size == 0 then
          @op.push current_tk.value
        elsif priority(current_tk.value) >= priority(@op.last)
          @op.push current_tk.value
        elsif priority(current_tk.value) < priority(@op.last)
          make_op
          @op.push current_tk.value
        end
      else
        @error = true
      end
      return :state0_1
    end
    
    # Solves the operations saved in @op
    def make_op
      while @op.size > 0 and !@error do
        b = @num.pop
        a = @num.pop
        op = @op.pop
        @num.push OPERATORS[op][a,b]
      end
    end
    
    # * **returns**: token of the current pointer value
    def current_tk
      return @stream[@i]
    end
    
    # Returns the operator priority
    #
    # * **argument**: operator (string)
    # * **returns**: priority (fixnum)
    def priority(op)
      case op
        when "+","-"
          return 1
        when "*","/"
          return 2
        when /\^/
          return 3
      end
    end
  end
  
  # It solves the expression in string format
  #
  # * **argument**: expression to evaluate
  # * **returns**: result of the expression; +nil+ if an error occourred
  def self.solve(exp)
    lexer = Lexer.new
    evaluator = Evaluator.new
    stream = lexer.tokenize(exp)
    return nil if stream == nil
    return evaluator.evaluate(stream)
  end
end













