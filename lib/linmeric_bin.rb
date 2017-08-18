#! /usr/bin/env ruby

%w|linmeric/CnGal_new_classes.rb
   linmeric/CnGal_tools.rb
   linmeric/CnGal_Matrix_class.rb
   linmeric/Parser.rb
   linmeric/Scopify.rb
   linmeric/Listener.rb
   linmeric/Sizer.rb
   linmeric/LU.rb|.each do |f|
     require_relative f
   end
