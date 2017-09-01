#! /usr/bin/env ruby

require_relative 'Function_class.rb'


##
# Overload of Numeric class
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Numeric 
  
  # Compares the value with another object
  #
  # * **argument**: object for the comparison
  # * **returns**: +true+ if the object is a `Numeric`; +false+ else. 
  def is_similar?(obj)
    (obj.is_a? Numeric) ? (return true) : (return false)
  end
  
  # Checks if the numeric value can be multiplied by a given object
  #
  # * **argument**: object for the checking
  # * **returns**: +true+ if the object is `Numeric` or Matrix; +false+ else. 
  def can_multiply?(obj)
    (obj.is_a? Numeric) ? (return true) : ((obj.is_a? Matrix) ? (return true) : (return false))
  end
  
  # Checks if the numeric value can be divided by a given object
  #
  # * **argument**: object for the checking
  # * **returns**: +true+ if the object is `Numeric` or Matrix; +false+ else. 
  def can_divide?(obj)
    (obj.is_a? Numeric) ? (return true) : ((obj.is_a? Matrix) ? (return true) : (return false))
  end

end

##
# Definition of some method for Int numbers. This is included in Integer class (ruby_version >= 2.2)
# or Fixnum class (ruby_version <= 2.2) 
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module IntNum

  # Compares the value with another object
  #
  # * **argument**: object for the comparison
  # * **returns**: +true+ if the object is a Numeric; +false+ else.
  def similar_to?(obj)
    (obj.is_a? Numeric) ? (return true) : (return false)
  end
  
  # Checks if the fixnum value can be multiplied by a given object
  #
  # * **argument**: object for the checking
  # * **returns**: +true+ if the object is Numeric or Matrix; +false+ else.
  def can_multiply?(obj)
    (obj.is_a? Numeric) ? (return true) : ((obj.is_a? Matrix) ? (return true) : (return false))
  end
  
  # Checks if the fixnum value can be divided by a given object
  #
  # * **argument**: object for the checking
  # * **returns**: +true+ if the object is Numeric or Matrix; +false+ else. 
  def can_divide?(obj)
    (obj.is_a? Numeric) ? (return true) : ((obj.is_a? Matrix) ? (return true) : (return false))
  end
  
end

# Little patch for ruby versions
if RUBY_VERSION >= "2.2.0"
  class Integer
    include IntNum
  end
else
  class Fixnum
    include  IntNum
  end
end

##
# Overload of Float class
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Float 

  # Compares the value with another object
  #
  # * **argument**: object for the comparison
  # * **returns**: +true+ if the object is a Numeric; +false+ else.
  def similar_to?(obj)
    (obj.is_a? Numeric) ? (return true) : (return false)
  end
  
  # Checks if the float value can be multiplied by a given object
  #
  # * **argument**: object for the checking
  # * **returns**: +true+ if the object is Numeric or Matrix; +false+ else.
  def can_multiply?(obj)
    (obj.is_a? Numeric) ? (return true) : ((obj.is_a? Matrix) ? (return true) : (return false))
  end
  
  # Checks if the float value can be divided by a given object
  #
  # * **argument**: object for the checking
  # * **returns**: +true+ if the object is Numeric or Matrix; +false+ else.   
  def can_divide?(obj)
    (obj.is_a? Numeric) ? (return true) : ((obj.is_a? Matrix) ? (return true) : (return false))
  end
  
end

##
# Overload of NilClass
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class NilClass
  
  # * **returns**: string representation of +nil+
  def to_s
    return "nil"
  end
  
  # * **returns**: 0
  def size
    return 0
  end
  
end

##
# Overload of String class
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class String

  # Checks if the string contains at least a character of the given one.
  #
  # * **argument**: string for the checking
  # * **returns**: +true+ if a character in common is found; +false+ else.
  def contain?(str)
    raise ArgumentError, '' unless str.is_a? String
    str.each_char do |ch|
      return true if self.include? ch
    end
    return false
    
    rescue ArgumentError
      str = str.to_s
      retry
  end
  
  # Checks if the string contains all the characters of the given one.
  # 
  # * **argument**: string for the checking
  # * **returns**: +true+ if the string contins all the chars of the argument;
  # +false+ else
  def contain_all?(str)
    raise ArgumentError, '' unless str.is_a? String
    str.each_char do |ch|
      return false if not self.include? ch
    end
    return true
    
    rescue ArgumentError
      str = str.to_s
      retry
  end
  
  # Deletes spaces from a string
  #
  # * **returns**: new string
  def compact()
    nstr = ''
    self.each_char do |ch|
      nstr += ch if ch != ' '
    end
    return nstr
  end
  
  # Subtracts the substring to the main
  #
  # * **argument**: substring
  # * **returns**: new string
  def -(str)
    myStr = str.to_s
    temp = ''
    i = 0
    if self.include? myStr then
      while i < self.length do
        if self[i...(i + myStr.size)] == myStr then
          i += myStr.size
        else
          temp += self[i]
          i += 1
        end
      end
    else
      return self
    end
    return temp
  end
  
  # Checks if the strings represents a `Fixnum` value
  #
  # * **returns**: +true+ if the string represents a `Fixnum`; +false+ else
  def integer?
    [                          # In descending order of likeliness:
      /^[-+]?[1-9]([0-9]*)?$/, # decimal
      /^0[0-7]+$/,             # octal
      /^0x[0-9A-Fa-f]+$/,      # hexadecimal
      /^0b[01]+$/,             # binary
      /[0]/                    # zero
    ].each do |match_pattern|
      return true if self =~ match_pattern
    end
    return false
  end

  # Checks if the strings represents a `Float` value
  #
  # * **returns**: +true+ if the string represents a `Float`; +false+ else
  def float?
    pat = /^[-+]?[1-9]([0-9]*)?\.[0-9]+$/
    return true if self=~pat 
    return false 
  end
  
  # Checks if the string represents a number
  #
  # * **returns*: +true+ if the string represents a number; +false+ else
  def number?
    (self.integer? or self.float?) ? (return true) : (return false)
  end

  # Converts a string to a number
  #
  # * **returns**: `Float` value if the string represents a float
  # `Fixnum` value if the string represents a fixnum; 0 else. 
  def to_n
    return self.to_f if self.float?
    return self.to_i if self.integer? 
    return 0
  end
  
  # Removes a character at the given index
  #
  # * **argument**: index of the character (`Fixnum`)
  # * **returns**: new string
  def remove(index)
    return self if index < 0
    n_str = ''
    for i in 0...self.size
      n_str += self[i] unless i == index
    end
    return n_str
  end
end

##
# Defining a subclass of string to identify a fileneme
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Filename < String
  
  def to_s
    return self
  end
  
  # * **returns**: name of the file (`String`)
  def name
    i = self.size - 1
    nm = ''
    while self[i] != '/' do
      nm += self[i]
      i -= 1
    end
    return nm.reverse
  end
  
  # * **argument**: class name
  # * **returns**: +true+ if `self.class` = `obj`; +false+ else
  def is_a?(obj)
    self.class == obj ? (return true) : (return false)
  end
  
end

##
# Definition of a dimension (structure: from-to)
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Dim
  
  # * **argument**: string to be converted to a dimension
  def initialize(str)
    str = str - '"'
    str = str.split(',')
    if str.size == 2 and str[0] != "" and str[1] != "" then
      str.each do |val|
        puts '  Argument Error: wrong range format' unless val.number?
      end
      @sx = str[0].to_n
      @dx = str[1].to_n
    else
      puts '  Argument Error: wrong range format'
    end
  end
  
  # * **returns**: left dimension value
  def sx()
    return @sx
  end
  
  # * **returns**: right dimension value
  def dx()
    return @dx
  end
end











