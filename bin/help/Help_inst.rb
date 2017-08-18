#! /usr/bin/env ruby


##
# Help menu module -instructions
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com0)
# License:: Distributed under MIT license
module Help

   def self.write(syntax,example)
     ["SINTAX",syntax,"","EXAMPLES",example].each do |el|
        puts el
      end	
   end
  VAR_ASSIGNMENT = [
                     "  <variable_name> = <value>",
                     "",
                     "  <variable_name> = <expression>"                    
                   ]
  VAR_ASSIGN_EG  = [
                     "  v1 = 13    #=> 13",
                     "",
                     "  v2 = 3*4^2 #=> 48",
                     "",
                     "  v3 = v1+v2 #=> 61",
                     "",
                     "(Allowed operations: +,-,*,/,^)",
                     "", 
                     "This interpreter sees as different uppercase and lowercase",
                     "letters in variable definition. (A1 <> a1)"
                   ]
  def self.var_assign
    self.write(VAR_ASSIGNMENT,VAR_ASSIGN_EG)
  end
  VAR_DISPLAYING = [
                      "  shw: <variable_name>  // displays <variable_name>",
                      "",
                      "  <variable_name>       // displays <variable_name>",
                      "",
                      "  shwvar:               // displays all the variables in memory",
                      "                           no argument required"   
                   ]
  VAR_DISPLAY_EG = [
                     "  # v1 = 13, v2 = 6",
                     "  shw: v1 #=> 13",
                     "",
                     "  v1      #=> 13",
                     "",
                     "  shwvar: #=> 13; #=> 6" 
                   ] 
  def self.var_displaying
    self.write(VAR_DISPLAYING,VAR_DISPLAY_EG)
  end
  COMPARISONS    = [
                     "  <expression> = <expression>"
                   ]
  COMPARISONS_EG = [
                     "  12+7 = 10+9   #=> true",
                     "",
                     "  12*8 = 20^123 #=> false",
                     "",
                     "  a/b = c*f     #=> true/false"
                   ] 
  def self.comparisons
    self.write(COMPARISONS,COMPARISONS_EG)
  end 
  FUNCTION_DEF   = [
                      "  <function_name> = f: \"<function_definition>\""
                   ]
  FUNCTION_DEF_E = [
                     "  fx = f: \"x*log(x)\" #=> x*log(x)",
                     "",
                     "  gx = f: \"y^z\"      #=> y^z",
                     "",
                     "At the moment, the following algebric functions are supported:",
                     " log, sin, cos, exp, tan",
                     "Constants: PI (PI = 3,14...)",
                     "",
                     "Restriction: parameters must be composed by only one letter (x,y,k,a...)",
                     "",
                     "Warning: this interpreter uses ruby methods to solve functions.",
                     "Therefore, divisions with numbers return a number in the format",
                     "corresponding to the one of the denominator.",
                     "Example: 1/2   #=> 0 (integer => integer)",
                     "         1/2.0 #=> 0.5 (float => float)"
                   ]
  def self.function
    self.write(FUNCTION_DEF,FUNCTION_DEF_E)
  end
  MATRIX_CREATE  = [
                      "// Matrix inserted by hand:",
                      "",
                      "  <matrix_name> = mx: \"<rows>,<columns>\"",
                      "",
                      "// Matrix according to a certain function rows-columns (or number):",
                      "",
                      "  <matrix_name> = mx: \"<rows>,<columns>\" as: \"<function_definition>\"",
                      "",
                      "  <matrix_name> = mx: \"<rows>,<columns>\" as: <function_name>",
                      "",
                      "// Matrix from a .csv file:",
                      "",
                      "  <matrix_name> = mx: from: \"<file_path>\"",
                      "",
                      "// Identity matrix:",
                      "",
                      "  <matrix_name> = id_mx: <size>"
                   ]
  MATRIX_EXAMPLE = [
                     "  m1 = mx: \"4,4\"            // it creates a 4x4 matrix with values inserted",
                     "                               by the user",
                     "",
                     "  m2 = mx: \"4,4\" as: \"r*c\"  // it creates a 4x4 matrix in which each element is",
                     "                               given by the product row_number*column_number",
                     "",
                     "  # kx = f: \"r*c\"",
                     "  m4 = mx: \"4,4\" as: kx     // equals to the previous example",
                     "",
                     "  m5 = mx: from: \"/home/usr/Desktop/matrix.csv\" // it loads the matrix written",
                     "                                                    in the .csv file",
                     "",
                     "  id = id_mx: 5             // it creates an identity 5x5 matrix",
                     "",
                     "Allowed operations: +, -, *",
                     "/ (Matrix-number) It divides each element for the given number",
                     "^ (Matrix-number) It elevates each element at the given exponent",
                     "",
                     "It is possible to insert as value simple operations as 3/4, 10^5..."
                   ]
  def self.matrix
    self.write(MATRIX_CREATE,MATRIX_EXAMPLE)
  end                
  MATRIX_OP_TR   = ["  t: <matrix_name>"]
  MATRIX_OP_EG   = [
                      "  # m1: // 4x7 matrix",
                      "  t: m1 #=> 7x4 matrix ",
                      "",
                      "Results can be stored in a variable"]
  def self.matrix_tr
     self.write(MATRIX_OP_TR,MATRIX_OP_EG)
  end
  MATRIX_OP_NORM = ["  norm: <matrix_name>"]
  MATRIX_NORM_EG = [
                     "  norm: m1 // sqrt (sum (m1[r,c]^2))",
                     "",
                     "Results can be stored in a variable"
                     ]
  def self.matrix_norm
    self.write(MATRIX_OP_NORM,MATRIX_NORM_EG)
  end
  MATRIX_OP_DET  = ["  det: <matrix_name>"]
  MATRIX_DET_EG  = [
                     "  # m0 // 6,6 matrix",
                     "  det: m0",
                     "",
                     "Results can be stored in a variable"  
                   ]
  def self.matrix_det
    self.write(MATRIX_OP_DET,MATRIX_DET_EG)
  end                 
  FUNCT_INTEG    = [
                     "  integ: \"<function_definitio>\" \"<range>\" <number_of_points> (\"<method>\")",
                     "",
                     "It is possible to replace the function definition with a variable containing",
                     "the function itself.",
                     "Results can be stored in a variable."
                   ]
  FUNCT_INTEG_EG = [
                     "  integ: \"x*log(x^2)\" \"3,10\" 50            // integration of 'x*log(x^2)'",
                     "                                              from 3 to 10 on 50 points",
                     "  integ: \"x*log(x^2)\" \"3,10\" 50 \"midpoint\" // integration method specified",
                     "",
                     "  # sx = f: \"x*log(x^2)\"",
                     "  integ: sx \"3,10\" 50",
                     "",
                     "Available integration methods:",
                     " * trapezes  // trapezes method",
                     " * rectl     // left-rectangles method",
                     " * rectr     // right-rectangles method",
                     " * midpoint  // middle-rectangles method",
                     " * simpson   // simpson method (default)",
                     " * boole     // boole method"
                   ]
  def self.integration
    self.write(FUNCT_INTEG,FUNCT_INTEG_EG)
  end                 
  LU_FACT        = [
                      "  solve: <matrix_name> ~ <solution_matrix_name>",
                      "",
                      "  solve: <expression_with_matrices> ~ <expression_with_matrices>"
                   ]
  LU_FACT_EG     = [
                     "  # a,b,c // 3x3 matrices",
                     "  # d     // 3x1 matrix",
                     "",
                     "  solve: a ~ d     // returns the x-matrix containing the solution",
                     "                      of the system (d: known system values matrix)",
                     "  solve: a*b ~ c*d // returns the x-matrix solution of the matrix",
                     "                      returned by a*b",
                     "",
                     "LU factorization with direct matrix creation:",
                     "  solve: (mx: \"4,4\") ~ (mx: \"4,1\")",
                     "",
                     "L and U matrices are saved as variables with their default names (L,U)"
                   ]
  def self.lu
    self.write(LU_FACT,LU_FACT_EG)
  end
  DATA_WRITING   = [
                     "  <value> > \"<file_path>\"",
                     "",
                     "  <expression> > \"<file_path>\"",
                     "",
                     "  <variable_name> > \"<file_path>\""
                   ]
  DATA_WRITING_E = [
                     "  23 > \"home/usr/Desktop/val.txt\" // the number 23 will be written",
                     "                                    in val.txt. If the file does not exist,",
                     "                                    it will be created",
                     "  s*q0+1 > \"home/usr/Desktop/val.txt\"  // the result of 's*q0+1' will be",
                     "                                         written in val.txt (s,q0 are variables)",
                     "  # mk // 8x8 matrix",
                     "mk > \"home/usr/Desktop/matrx.csv\"  // Matrix 'mk' will be written in matrix.csv"
                   ]
  def self.data_writing
    self.write(DATA_WRITING ,DATA_WRITING_E)
  end                 
  SYMBOLS = [
              "Symbols used in this help menu:",
              "  <text> : kind of argument to replace",
              "  #=>    : output of the program",
              "  //     : comments",
              "  #      : specifications",
              "  <>     : different"
            ]
  def self.symbols
    puts SYMBOLS
  end
end




