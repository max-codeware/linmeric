#! /usr/bin/env ruby

require_relative 'CnGal_new_classes.rb'

##
# Provides some useful procedure for linmeric
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Tool
  
  # * **returns**: array of all the keywords used by linmeric
  def self.keys 
    return ["mx:","t:", "shw:","shwvar:","det:","solve:","from:","as:","f:","norm:","id_mx:","integ:"]
  end
  
  # * **returns**: array of all the operators
  def self.operators
    return ["=","-","+","*","/","^",">"]
  end
  
  # * **returns**: alphabet in string format
  def self.letters
    return "abcdefghijklmnopqrstuvwxyz"
  end
  
  # **returns**: array of the supported math functions; see: Function
  def self.f
    return ["log","sin","cos","PI","tan","exp"]
  end
  
  # Checks if a string represents a keyword
  #
  # * **argument**: object to check
  # * **returns**: +true+ if `ob` represents a keyword; +false+ else. 
  def self.is_keyword?(ob)   
    (self.keys.include? ob) ? (return true) : (return false)
  end
  
  # Dummy function to ckeck if a string represents an expression (may not work properly)
  #
  # * **argument**: string to be checked
  # * **returns**: +true+ if `str` represents an expression; +false+ else.
  def self.is_exp?(str)
    (str.contain? "=+*-/^") ? (return true) : (('0123456789.'.contain_all? str) ? 
    (return true):((self.letters.contain? str) ? (return true):(return false)))
  end
  
  # Prints the hash of the variables
  #
  # * **argument**: hash to be printed
  def self.print_stack(stack)
    stack.keys.each do |k|
      puts "#{k} = " if stack[k].is_a? Matrix
      print "#{k} = " unless stack[k].is_a? Matrix
      puts stack[k]
    end
  end
  
end


