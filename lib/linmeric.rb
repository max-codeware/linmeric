#! /usr/bin/env ruby

%w|linmeric/Archive.rb linmeric/Calculator.rb 
   linmeric/CnGal_Matrix_class.rb linmeric/CnGal_new_classes.rb
   linmeric/CnGal_tools.rb linmeric/Error_print.rb 
   linmeric/Function_class.rb linmeric/Integrators.rb
   linmeric/Lexer.rb linmeric/Listener.rb linmeric/LU.rb
   linmeric/Parser.rb linmeric/Scopify.rb linmeric/Sizer.rb
   linmeric/Token.rb|.each do |f|
     require_relative f
  end

