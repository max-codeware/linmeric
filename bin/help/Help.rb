#! /usr/bin/env ruby

require_relative "Help_inst.rb"

##
# Help menu module -user interface
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com0)
# License:: Distributed under MIT license
module Help
  MENU = [
           "[0] Variable assignment",
           "[1] Variable displaying",
           "[2] Comparisons",
           "[3] Creating a function",
           "[4] Creating a matrix",
           "[5] Operations on matrices",
           "[6] Function intagration",
           "[7] LU factorization",
           "[8] Wrinting values and datas on files",
           "[9] Symbols",
           "[10] exit"
         ]
         
  MATRIX_OP = [
                "[a] Transposition",
                "[b] Norm",
                "[c] Determinant",
                "[d] to return to main menu"
              ]
              
  NUMBER        = /[0-9]/
  LETTER        = /[a-d]/
  
  SINGLE_NUMBER = ("0".."9").map do |n|
                    n
                  end
  
  SINGLE_LETTER = ("a".."d").map do |l|
                    l
                  end
  def self.ask
    puts MENU
    print ">> "
    cmd = STDIN.gets.downcase.chomp
    while cmd != "10" do
      case cmd
        when NUMBER then menu(cmd)
        self.clrscr
        puts MENU
      end
      print ">> "
      cmd = STDIN.gets.downcase.chomp
    end
    exit 0
  end
  
  def self.menu(choice)
    if SINGLE_NUMBER.include? choice then
      self.send("_#{choice}_")
    end
  end
  
  def self.matrix_op(choice)
    if SINGLE_LETTER.include? choice then
      self.send("_#{cmd}_")
    end
  end
  
  def self.clrscr
    print "\e[H\e[2J"
  end
  
  def self.back_to_menu
    puts
    print "[m] to return to menu >> "
    key = STDIN.gets.downcase.chomp
    while key != "m"
      print "[m] to return to menu >> "
      key = STDIN.gets.downcase.chomp
    end
    # self.clrscr   
  end
  
  def self.back_to_sub_menu
    puts
    print "[s] to return to sub menu >> "
    key = STDIN.gets.downcase.chomp
    while key != "s"
      print "[s] to return to sub menu >> "
      key = STDIN.gets.downcase.chomp
    end
    # self.clrscr
  end
  
  def self._0_
    self.clrscr
    self.var_assign
    self.back_to_menu
  end
  
  def self._1_
    self.clrscr
    self.var_displaying
    self.back_to_menu
  end
  
  def self._2_
    self.clrscr
    self.comparisons
    self.back_to_menu
  end
  
  def self._3_
    self.clrscr
    self.function
    self.back_to_menu
  end
  
  def self._4_
    self.clrscr
    self.matrix
    self.back_to_menu
  end
  
  def self._5_
    self.clrscr
    puts MATRIX_OP
    print "*>> "
    cmd = STDIN.gets.downcase.chomp
    while cmd != "d" do
      if SINGLE_LETTER.include? cmd
        self.send(cmd)
        self.clrscr
        puts MATRIX_OP
      end
      print "*>> "
      cmd = STDIN.gets.downcase.chomp
    end
  end
  
  def self.a
    self.clrscr
    self.matrix_tr
    self.back_to_sub_menu
  end
  
  def self.b
    self.clrscr
    self.matrix_norm
    self.back_to_sub_menu
  end
  
  def self.c
    self.clrscr
    self.matrix_det
    self.back_to_sub_menu
  end
  
  def self._6_
    self.clrscr
    self.integration
    self.back_to_menu
  end
  
  def self._7_
    self.clrscr
    self.lu
    self.back_to_menu
  end
  
  def self._8_
    self.clrscr
    self.data_writing
    self.back_to_menu
  end
  
  def self._9_
    self.clrscr
    self.symbols
    self.back_to_menu
  end

end
