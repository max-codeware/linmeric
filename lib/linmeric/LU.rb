#! /usr/bin/env ruby
require_relative 'CnGal_Matrix_class'

##
# This module provides some method to perform LU factorization
# on squared matrices. 
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module LU
  
  # Swaps two rows of a matrix (pivoting)
  #
  # * **argument**: matrix the rows must be swapped on
  # * **argument**: first row
  # * **argument**: second row
  # * **returns**: new matrix with swapped rows
  def self.swap(mx,r1,r2)
    for i in 0...mx.getCls do
      mx[r1,i],mx[r2,i] = mx[r2,i],mx[r1,i] 
    end
    return mx
  end
  
  # Returns the `L` matrix
  def self.L()
    return @L
  end
  
  # Returns the `U` matrix
  def self.U()
    return @U
  end
  
  # Sets to nil @L and @U variables
  def self.reset
    @L = nil
    @U = nil
  end
  
  # Performs LU factorization calculating L and U matrices
  #
  # * **argument**: squared matrix to factorize
  # * **argument**: n x 1 matrix of known values of the linear system
  # * **returns**: same as LU.solve 
  def self.factorize(mx,sol)
    [mx,sol].each do |vec|
      return nil unless vec.is_a? Matrix
    end
    sol = sol.tr if sol.getCls > 1
    return nil unless sol.getCls == 1
    return nil unless mx.is_squared?
    return nil unless mx.getRws == sol.getRws
    rows = mx.getRws
    for k in 0...rows do
      column = mx[k...mx.getRws,k].export.map! { |val| val.abs}
      max_index = column.index(column.max)
      mx = self.swap(mx,k,k + max_index) unless k == max_index + k
      sol = self.swap(sol,0,k + max_index) unless k == max_index + k
      for i in (k+1)...mx.getRws do
        alpha = (mx[k,k] != 0) ? (mx[i,k] / mx[k,k].to_f) : 0
        mx[i,k] = alpha
        for j in (k+1)...mx.getCls do
          mx[i,j] -= alpha * mx[k,j] 
        end
      end
    end
    @L = Matrix.identity(mx.getRws) + Matrix.new(mx.getRws,mx.getCls){ |i,j| (i > j) ? mx[i,j] : 0}
    @U = Matrix.new(mx.getRws,mx.getCls){ |i,j| (i <= j) ? mx[i,j] : 0}
    return solve(sol)
  end
  
  # Finds the solutions of the linear system
  #
  # * **argument**: n x 1 matrix of known values of the linear system
  # * **returns**: n x 1 matrix with the solutions of the system
  def self.solve(sol)
    z = Matrix.new(sol.getRws,1) {0}
    x = Matrix.new(sol.getRws,1) {0}
    for i in 0...sol.getRws do
      z[i,0] = sol[i,0]
      for j in 0...i do       
        z[i,0] -= @L[i,j] * (z[j,0] || 1)
      end
    end

    (sol.getRws - 1).downto(0) do |i|
      x[i,0] = z[i,0]     
      for j in i...sol.getRws
        x[i,0] -= (@U[i,j+1] || 0) * (x[j+1,0] || 0)       
      end
      x[i,0] = x[i,0] / @U[i,i].to_f
    end
    return x
  end
  
  
end






