#! /usr/bin/env ruby

##
# This module provides some method to integrate a function
# 
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Integrators

   # Implementation of trapezes method
   #
   # * **argument**: left range value
   # * **argument**: right range value
   # * **argument**: number of integration points
   # * **returns**: result of the operation (Numeric)
   def self.trapezi(a,b,n)
       h = (b - a) / n.to_f
       int_parz = 0
       for i in 0...n
          # Calculating first addend = f(x_i)
          f1 = yield(a + i * h)
          # calculating second addend = f(X_{i+1})
          f2 = yield(a + (i + 1) * h)
          # Calculating trapeze area
          trap = 0.5 * h * (f1 + f2)
          int_parz += trap
       end
       return int_parz
   end
   
   # Implementation of midpoint method
   #
   # * **argument**: left range value
   # * **argument**: right range value
   # * **argument**: number of integration points
   # * **returns**: result of the operation (Numeric)
   def self.midpoint(a,b,n)
     parz = 0
     h = (b - a) / n.to_f
     for i in 0...n
       f1 = yield(a + (i + 0.5) * h)
       parz += f1
     end
     return h * parz
   end
   
   # Implementation of Simpson's method
   #
   # * **argument**: left range value
   # * **argument**: right range value
   # * **argument**: number of integration points
   # * **returns**: result of the operation (Numeric)
   def self.simpson(a,b,n)
     hs = (b - a) / (n * 2.0)
     intSA = 0
     intSB = 0
     for i in 1..n-1
       xa = a + (2 * i) * hs
       intSA += yield(xa)
     end
  
     for i in 0..n-1
       xb = a + (2 * i + 1) * hs
       intSB += yield(xb)
     end
     fa = yield(a)
     fb = yield(b)
     intS = hs / 3.0 * (fa + fb + 2 * intSA + 4 * intSB)
     return intS
   end
   
   # Implementation of left rectangles method
   #
   # * **argument**: left range value
   # * **argument**: right range value
   # * **argument**: number of integration points
   # * **returns**: result of the operation (Numeric)
   def self.rettsx(a,b,n)
     h = (b - a) / n.to_f
     area = 0
     for i in 0..n-1
       area += yield(a + (h * i)) * h
     end
     return area
   end
   
   # Implementation of right rectangles method
   #
   # * **argument**: left range value
   # * **argument**: right range value
   # * **argument**: number of integration points
   # * **returns**: result of the operation (Numeric)
   def self.rettdx(a,b,n)
     h = (b - a) / n.to_f
     area = 0
     for i in 1..n
       area += yield(a + (h * i)) * h
     end
     return area
   end
   
   # Implementation of Boole's method
   #
   # * **argument**: left range value
   # * **argument**: right range value
   # * **argument**: number of integration points
   # * **returns**: result of the operation (Numeric)
   def self.boole(a,b,n)
     h = (b - a) / (4 * n.to_f)
     part = 0
     for i in 0..n-1
       part +=  7 * yield(a + (h * 4 * i)) +
               32 * yield(a + (h * (4 * i + 1))) +
               12 * yield(a + (h * (4 * i + 2))) +
               32 * yield(a + (h * (4 * i + 3))) +
                7 * yield(a + (h * (4 * i + 4)))
     end
     return (2 * h) / 45.0 * part
   end
  
end
