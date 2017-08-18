#! /usr/bin/env ruby


require_relative 'CnGal_new_classes.rb'
require_relative 'Listener.rb'
require_relative 'Calculator.rb'

class InputError < ArgumentError; end
class MyArgError < RuntimeError; end

##
# This class provides a simple representation of a matrix with the main
# features, operations and some useful method to manipulate it or to make 
# its creation easier.
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Matrix
  
  # Initialization of  new matrix in two different ways (chosen by
  # the user): 
  # * a block can be given to create a matrix according to a function
  # * the user must insert each value by hand (if block is not given)
  #
  # * **requires**: `#solve` of Calculator
  # * **argument**: number of rows (Fixnum)
  # * **argument**: number of columns (Fixnum)
  # * **block**: yields a function with two arguments (optional)
  def initialize(rws = 0,cls = 0)
    listener = Listener.new
    if rws == 0 or cls == 0 or rws.is_a? Float or cls.is_a? Float then 
      raise MyArgError,"   Argument Error: invalid dimension #{rws}x#{cls} for Matrix object" 
    elsif !(rws.is_a? Fixnum) or !(cls.is_a? Fixnum) then
          e = rws unless e.is_a? Fixnum
          e = cls unless cls.is_a? Fixnum
          raise MyArgError,"  Argument Error: colums and rows in Integer format expected but #{e.class} found"
    else
      @MyRws = rws; @MyCls = cls
      @mx=[]
      if block_given? then
        for i in 0...@MyRws
          for j in 0...@MyCls
            value = yield(i,j) if block_given? 
            @mx << value
          end
        end       
      else
          puts "Insert the line values (separated by space) and press return to go on"
          for i in 0...rws
            listener.reset
            cl = listener.gets.split
            raise ArgumentError, "  #{cls} element(s) expected but #{cl.size} found. Retry" unless cl.size==cls
            cl.map! { |e| 
              cv = Calculator.solve(e)
              err = e if cv == nil
              raise MyArgError, "  Argument Error: Invalid operation '#{err}' found in matrix rows" unless cv != nil
              e = cv
            }
            @mx +=cl 
        end
      end
    end
 
      
    rescue ArgumentError => message
      puts message
      @mx=[]
      retry
      
  end
   
  # Creates a new matrix loading it from a .csv file
  #
  # * **argument**: `String` of the file path
  # * **returns**: new matrix object 
  def Matrix.from_file(filename = "")
    @mx = []
    @MyCls = 0
    @MyRws = 0
    if !(File.exists? filename) or filename == "" then
      raise MyArgError, "  Argument Error: Invalid directory or filename"
    else
      File.open(filename, "r").each_line do |ln|
        @MyRws += 1
        ln = ln.chomp.split(',')
        ln.map! do |el| 
          cv = Calculator.solve(el)
          err = el if cv == nil
          raise InputError, "  Argument Error: Invalid operation '#{err}' found in matrix rows" unless cv != nil
          el = cv
        end
        @mx += ln
        if @mx.size % ln.size != 0 then
          raise MyArgError, "  Argument Error: Irregular matrix rows"
        end
        @MyCls = ln.length
      end
    end
    return mat = Matrix.new(@MyRws,@MyCls) {|i,j| @mx[i*@MyCls+j]}
  end 
  
  # Writes the matrix on a file
  #
  # * **argument**: `String` of the file path
  def to_file(filename = "")
    if !(Dir.exist? File.dirname(filename)) or filename == "" then
      raise MyArgError, "  Argument Error: Invalid directory; Directory not found"
    else
      File.open(filename,"w") do |rw|
        for i in 0...@MyRws do
          for j in 0...(@MyCls - 1) do
            rw.print "#{self[i,j]},"
          end
          rw.puts "#{self[i,j+1]}"
        end
      end
    end
  end
  
  # converts this matrix object to a string
  def to_s()
    max = 0
    str = ""
    @mx.each{ |n| max = "#{n.round(3)}".size if "#{n.round(3)}".size > max}
    for i in 0...@MyRws do
      str += '|'
      for j in (i*(@MyCls))...(i*(@MyCls)+@MyCls) do
        str += "  #{" "*(max-@mx[j].round(3).to_s.size).abs}#{@mx[j].round(3) }"
      end
      str+= "  |\n"
    end
    return str
  end
  
  # * **returns**: `Fixnum` of number of columns
  def getCls()
    return @MyCls
  end
  
  # * **returns**: `Fixnum` of number of rows
  def getRws()
    return @MyRws
  end
  
  # * **returns**: `Array` on which the matrix is saved
  def export()
    return @mx
  end
  
  # Updates this matrix after the array in which it was saved has been
  # manually modified
  #
  # * **argument**: `Array` on which the new matrix is saved
  # * **argument**: `Fixnum` of number of rows
  # * **argument**: `Fixnum` of number of columns
  def update(mat,rws,cls)
    if !(mat.is_a? Array) then
      raise MyArgError, "  Argument Error: invalid matrix array found"
    else
      [cls,rws].each do |e|
        raise MyArgError, "  Argument Error: colums and rows in Integer format expected but #{e.class} found" unless e.is_a? Numeric
      end
    end
     @mx = mat
     @MyRws = rws
     @MyCls = cls
  end

  # Gives access to each component of a matrix.
  # It accepts two kinds of arguments: `Fixnum` or `Range`
  # to get a specific component or a collection of components (eg. a whole row)
  #
  # * **argument**: `Fixnum` or `Range` of row
  # * **argument**: `Fixnum` or `Range` of column  
  # * **returns**: `Numeric` if an only component has been required; `Matrix` else
  def [](x,y)
    if x.is_a? Numeric and y.is_a? Numeric then
      return @mx[x*@MyCls + y]
    elsif x.is_a? Range and y.is_a? Numeric
      nm = []
      x.each do |i|
        nm << @mx[i*@MyCls + y]
      end
      return Matrix.new(x.count,1){|i,j| nm[i + j]}
    elsif x.is_a? Numeric and y.is_a? Range
      nm = []
      y.each do |j|
        nm << @mx[x*@MyCls + j]
      end
      return Matrix.new(1,y.count){|i,j| nm[i + j]}
    elsif x.is_a? Range and y.is_a? Range
      nm = []
      x.each do |i|
        y.each do |j|
          nm << @mx[i*@MyCls + j]
        end
      end
      return Matrix.new(x.count,y.count){ |i,j| nm[i*y.count + j]}
    end
    return nil
  end
  
  # Allows direct overwriting of a component
  #
  # * **argument**: `Fixnum` of row number
  # * **argument**: `Fixnum` of column number
  # * **argument**: `Numeric` to overwrite the component value
  def []=(i,j,val)
    raise ArgumentError, "  Argument Error: Numeric value expected but #{val.class} found" unless val.is_a? Numeric
    @mx[i*@MyCls + j] = val
  end
 
  # Compares the current matrix with another object
  #
  # * **argument**: `Object` to be compared with
  # * **returns**: +true+ if two equal matrix are compered; +false+ else  
  def ==(obj)
   if obj.is_a? Matrix then
     if (self.getCls == obj.getCls && self.getRws == obj.getRws ) then
       (@mx == obj.export) ? (return true) : (return false)
     end
   end
   return false
  end
  
  # Checks if this matrix is different from another object
  #
  # * **argument**: `Object` to be compared with
  # * **returns**: +true+ if the matrix and the object are different; +false+ else
  def !=(obj)
    if obj.is_a? Matrix then
      self == obj ? (return false) : (return true)
    else
      return true
    end
  end
  
  # Checks if this matrix and the given object have the same features
  #
  # * **argument**: `Object`
  # * **returns**: +true+ if `obj` is a `Matrix` and has the same rows and colum number;
  # +false+ else
  def similar_to?(obj)
    if obj.is_a? Matrix then
      (self.getCls == obj.getCls && 
        self.getRws == obj.getRws ) ? (return true) : (return false)
    end
    return false
  end
  
  # Sums the current matrix to another
  #
  # * **argument**: `Matrix` to be summed to
  # * **returns**: `Matrix` object
  def +(m)
    if m.is_a? Matrix then
      if m.similar_to? self then
        return Matrix.new(@MyRws, @MyCls){ |i,j| self[i,j] + m[i,j]}
      else
        raise MyArgError, "  Argument Error: invalid matrix for + operation"
      end
    else
      raise MyArgError, "  Argument Error: can't sum #{m.class} to Matrix"
    end
  end
 
  # Subtracts the current matrix to another
  #
  # * **argument**: `Matrix` to be subtracted to
  # * **returns**: `Matrix` object
  def -(m)
    if m.is_a? Matrix then
      if m.similar_to? self then
        return Matrix.new(@MyRws, @MyCls){ |i,j| self[i,j] - m[i,j]}
      else
        raise MyArgError, "  Argument Error: invalid matrix for - operation"
      end
    else
      raise MyArgError, "  Argument Error: can't subtact #{m.class} to Matrix"
    end
  end
  
  # Checks if the given object can be multiplied to the matrix
  #
  # * **argument**: `Object`
  # * **returns**: +true++ if `obj` is a `Numeric` or a good `Matrix` for '*' operation;
  # +false+ else
  def can_multiply?(obj)
    if obj.is_a? Matrix then
      (self.getCls == obj.getRws) ? (return true) : (return false)
    elsif obj.is_a? Numeric
      return true
    end
    return false
  end
  
  # Multiplies the current matrix to another
  #
  # * **argument**: `Matrix` to be multiplied to
  # * **returns**: `Matrix` object
  def *(ob)
    case 
      when (ob.is_a? Numeric)
        return Matrix.new(@MyRws,@MyCls){ |i,j| self[i,j] * ob}
      when (ob.is_a? Matrix)
        if self.can_multiply? ob then
          temp = []
          for i in 0...@MyRws
            for j in 0...ob.getCls()
              temp[i*@MyCls + j] = 0
              for k in 0...@MyCls
                temp[i*@MyCls + j] += @mx[i*@MyCls + k] * ob[k,j]
              end
            end
          end
          return Matrix.new(@MyRws,ob.getCls()){ |i,j| temp[i * @MyCls + j]}
        else
          raise MyArgError, "  Argument Error: Cannot multiply #{@MyRws}x#{@MyCls} Matrix with #{ob.getRws}x#{ob.getCls}"
        end
      else
        raise MyArgError, "  Argument Error: Cannot multiply Matrix with #{ob.class}"
    end
  end
  
  # Checks if the given object can divide the current matrix
  #
  # * **argument**: `Object`
  # * **returns**: +true+ if `obj` is a Numeric; +false+ else
  def can_divide?(obj)
    return (obj.is_a? Numeric)
  end
  
  # Divides each element of the current matrix to a `Numeric` value
  #
  # * **argument**: `Numeric`
  # * **returns**: `Matrix` object
  def /(obj)
    return Matrix.new(@MyRws,@MyCls) { |i,j| self[i,j] / obj.to_f} if obj.is_a? Numeric
    raise MyArgError, "  Argument Error: Invalid division between Matrix and #{obj.class} "
  end
  
  # Elevates each element of the current matrix to a `Numeric` exponent
  #
  # * **argument**: `Numeric`
  # * **returns**: `Matrix` object
  def **(obj)
    return Matrix.new(@MyRws,@MyCls) { |i,j| self[i,j] ** obj} if obj.is_a? Numeric
    raise MyArgError, "  Argument Error: Invalid power Matrix-#{obj.class} "
  end
  
  # Trasposes a matrix
  #
  # **returns**: `Matrix` object
  def tr()
    return Matrix.new(@MyCls,@MyRws) { |i,j| @mx[j * @MyCls + i]}
  end
  
  # Calculates the norm of a matrix, defined as
  # sqrt(sum(m[i,j]**2))
  #
  # * **returns**: `Float` value
  def norm()
   sum=0
   @mx.map do |e|
     sum +=e**2
   end
   return Math.sqrt(sum)
  end
  
  # Checks if the matrix is squared
  #
  # * **returns**: +true+ if the matrix is squared; +false+ else
  def is_squared?()
    self.getCls == self.getRws ? (return true) : (return false)
  end
  
  # Calulates the determinant of the matrix using the Laplace's algorithm
  #
  # * **returns**: `Numeric` value
  def laplace
    if self.is_squared? then
      return (self[0,0] * self[1,1]) - (self[0,1] * self[1,0]) if self.getRws == 2 
      res = 0
      for i in 0...@MyRws
        res += (((-1) ** i) * self[i,0] * del_rwcl(self,i,0).laplace) if self[i,0] != 0
      end
      return res
    else
      raise MyArgError, '  Argument Error: Cannot calculate determinat on a non-squared matrix'
      return nil
    end
  end
  
  # Builds an identity matrix
  #
  # * **argument**: `Fixnum` of the matrix dimension
  # * **returns**: `Matrix` object
  def Matrix.identity(n)
    raise MyArgError, "Argument Error: expecting Fixnum value, but #{n.class} found" unless n.is_a? Fixnum
    return Matrix.new(n,n) { |i,j|  (i == j) ? 1 : 0 }
  end
  
  def coerce(val)
    return [self, val]
  end
  
  private
   
   # Private method to delete rows and columns from a matrix
   #
   # * **argument**: `Matrix`
   # * **argument**: row number (`Fixnum`)
   # * **argument**: column number (`Fixnum`)
   # * **returns**: `Matrix` object 
   def del_rwcl(mx,rw,cl)
     [rw,cl].each do |arg| 
       raise MyArgError,"Argument Error: row and column in Fixnum format expected, but #{arg.class} found" unless arg.is_a? Fixnum
     end
     rd = mx.export.clone
     cols = mx.getCls
     for i in 0...cols
       rd[i*cols+rw] = nil
       rd[cl*(cols)+i] = nil
     end
     rd = rd.compact
     rw = mx.getRws - 1
     cl = mx.getCls - 1
     return Matrix.new(rw,cl) { |i,j| rd[i*cl+j]}
   end
  
   
end







