{:.no_toc}
# Welcome to linmeric user guide
### This page will provide a simple guide to learn how to use this simple command line calculator
{:.no_toc}
___
## Index:
{:.no_toc}
* table of content
{:toc}
___


## Installing linmeric:

From the command line type:
```sh
  $ sudo gem install linmeric
```
or click [here](https://rubygems.org/gems/linmeric) to go to the linmeric rubygems page and download the .gem file. Then open the directory where the .gem file is saved on the commend line and type:
```sh
  $ sudo gem install ./linmeric-<version>.gem
```
`<version>` must be replaced by the version number of the gem you downloaded

___

## Version changes:
### 0.1.0
- first release

### 0.2.0
- A better documentation has been provided
- Matrix expression converter has been rewritten to get better performances
- Help menu and guides have been added
- Some bugs have been fixed

___

## Running linmeric:
From the command line type:
```sh
  $ linmeric
  Linmeric-main> 
```
and the calculator will be immediately run.

___

## Simple examples:
### Using linmeric as an ordinary calculator:
Linmeric can be used as a normal calculator of course, just simply typing the numeric expressions. For instance we want to know the result of `3^(5*4)`:

```sh
  Linmeric-main> 3^(5*4)
  => 3486784401
```
and we get `3486784401`. Feel free to try every numeric expression you want!

___

### Getting started with variables:
Simetimes it is useful to store values on variables, in order to retrive them later in other expressions. Linmeric allows variable storing with a very simple sintax '<variable_name> = <expression>'.
We create at first a variable called `x` storing the value `23` as we are going to use it more than once in the next example

```sh
  Linmeric-main> x = 23
  => 23
```
As we can see linmeric returns `23` that means the operation has successfully execuded.
Now we can store in another variable, we can call `result`, the result of a longer expression, for instance `x + (x * 9) - x ^ 2` remembering that `x` equals to `23`

```sh
  Linmeric-main> result = x + (x * 9) - x ^ 2
  => -299
```
And we see `-299` is returned always meaning the operation has successfully execuded.

___

### Showing variables:
Now we've seen how to store variables, we see how so display their content.
Linmeric supports two ways to display variables:
- through the keyword `shw:` (bug in version 0.2.0)
- just typing the name of the variable

```sh
  Linmeric-main> shw: x
  => 23
  Linmeric-main> x
  => 23
  Linmeric-main> shw: result
  => -299
  Linmeric-main> result
  => -299
```
We can notice both these methods achive the same result

___

### Comparing expressions:
Linmeric automatically compares two expressions if it does not find a variable name on the left side of the equal operator, but an algebric expression. That is: we saw writing `x = 23` produces an assignmet of the value `23` to the variable named `x`. But if we write `x + 1 = 23`, this will produce a comparison returning `true` or `false`.
But let's see on the command line:
```sh
  Linmeric-main> x + 1 = 23
  => false
```
This command tells the program to sum `1` to `x`, that returns `24`, and to compare it to `23`. Of course `24` does not equal to `23`, so `false` is returned.
Now let's see an example which produces *`true` as result:
```sh
  Linmeric-main> x * 4 + 1 = 31 * 3
  => true
```
`x * 4 + 1` produces `93`, `31 * 3` returns 93 too, so the comparison is true.

___

### Declaring a function:
To integrate a function or to create a function, we need to declare one. To do this we are going to use the keyword `f:` .
For instance we can declare a function as `x * log(x)` and storing it in a variable named `fx`:
```sh
  Linmeric-main> fx = f: "x * log(x)"
  => x*log(x) 
```
As we saw previously, the function itself is returned to tell the declaration has been successfully executed.
We can also observe, the keyword `f:` takes its argument between quotes: this allows the program to recognize the argument as a special one, and not as an ordinary expression.

The supported math functions are:
- log
- sin
- cos
- exp
- tan 

and the constant **PI**

*restriction*: Variables can be composed by an only letter (a, x, y...), otherwise an error would be raised (Bad function error)

*note*: To evaluate a function, linmeric uses Ruby methods; so dividing a value may produce unexpected values. For example:
`y/3` would return **0** (supposing `y` is given the value of 4), as `y` is divided by an integer number. But if we write `y/3.0`, it returns **1.3333333**, since `y` is now divided by a float number.

___

### Creating a matrix:
Four methods are provided by this language to create a function:
- Inserting the values by hand
- According a certain function
- Loading a matrix from a .csv file
- Identity matrix

The first three methods use the keyword `mx:`. Let's see them in detail:

#### Values inserted by hand:
We could create a 4x5 matrix just to begin, inserting the values we want and saving it in a variable called `m1`. 

```sh
  Linmeric-main> m1 = mx: "4,5"
  Insert the line values (separated by space) and press return to go on
  2 4 6 8 10
  3 6 9 12 15
  0 25 2 3 8
  1 2 2 3 3 
  =>
  |   2.0   4.0   6.0   8.0  10.0  |
  |   3.0   6.0   9.0  12.0  15.0  |
  |   0.0  25.0   2.0   3.0   8.0  |
  |   1.0   2.0   2.0   3.0   3.0  |
```
Even here we can notice `mx:` takes arguments between quotes. Linmeric uses quotes whenever it needs to identify special inputs.
The matrix dimension is described by the row number and column number separated by a comma. 

The successfully built matrix is returned as usual.

As value, a more complex expression can be given, like `1/5` or `3^(-8)`, but they must not contain spaces.

#### According a certain function:
Here a new keyword is needed, that is `as:`. The general sintax to build a matrix according a function is:

   **mx: "*rows*,*columns*" as: "function"**
   
This is useful if we want to create automatically a matrix.

We can build a 3x7 matrix, save it in m2, and the components must be given by the product between the line number and the column number:
```sh
  Linmeric-main> m2 = mx: "3,7" as: "r*c"
  =>
  |   0.0   0.0   0.0   0.0   0.0   0.0   0.0  |
  |   0.0   1.0   2.0   3.0   4.0   5.0   6.0  |
  |   0.0   2.0   4.0   6.0   8.0  10.0  12.0  |
```
Or we could create a matrix in which each component is the number **8**, just typing:
```sh
  Linmeric-main> m3 = mx: "3,7" as: "8"
  =>
  |  8.0  8.0  8.0  8.0  8.0  8.0  8.0  |
  |  8.0  8.0  8.0  8.0  8.0  8.0  8.0  |
  |  8.0  8.0  8.0  8.0  8.0  8.0  8.0  |
```
We can even save the function in a variable and give it as argumet, and we would get the same result as well
```sh
  Linmeric-main> gx = f: "8"
  => 8
  Linmeric-main> mx: "3,7" as: gx
  =>
  |  8.0  8.0  8.0  8.0  8.0  8.0  8.0  |
  |  8.0  8.0  8.0  8.0  8.0  8.0  8.0  |
  |  8.0  8.0  8.0  8.0  8.0  8.0  8.0  |
```
If we wrote a function with variables, the first one would represent the row number, while the second one the column number (if we decided to use a second variable).

#### From a .csv file
Here the sintax is very similar to the previous one, but we don't need to specify any dimension, as it will be determined automatically:

   **mx: from: "/path/to/the/file.csv"**
   
Let's suppose we saved our file in `/home/usr/Desktop` and to have named it as `matrix.csv` with this structure:
```
  2,4,6,8,10
  3,6,9,12,15
  0,25,2,3,8
  1,2,2,3,3 
```
And from linmeric we write:
```sh
  Linmeric-main> m4 = mx: from: "/home/usr/Desktop/matrix.csv"
  =>
  |   2.0   4.0   6.0   8.0  10.0  |
  |   3.0   6.0   9.0  12.0  15.0  |
  |   0.0  25.0   2.0   3.0   8.0  |
  |   1.0   2.0   2.0   3.0   3.0  |
```
And voilà: we loaded our matrix!

#### Identity matrix
This matrix uses a special keyword `id_mx:` which takes an only argument: the number of rows and columns (note that rows = columns).
```sh
  Linmeric-main> id = id_mx: 4
  =>
  |  1.0  0.0  0.0  0.0  |
  |  0.0  1.0  0.0  0.0  |
  |  0.0  0.0  1.0  0.0  |
  |  0.0  0.0  0.0  1.0  |
```
Note that here quotes are unecessary for the size, as the argument is just a number (and not a dimension).

___

### Operations with matrices:
All the algebric operators are allowed on linmeric:
- `+`: sums two matrices;
- `-`: subtracts two matrices
- `*`: multiplies two matrices or a matrix and a number (both float and integer)
- `\`: divides each component of a matrix for a number (both float and integer)
- `^`: elevates each component of a matrix to a number (both float and integer)

Linmeric automatically trasposes a matrix in the first three operations, to perform the operation whether it is possible.

But there are three more characteristic operations on matrices:
- Transposition
- Norm
- Determinent

Let's see them one for time:

#### Transposition:
The keyword `t:` manages the transposition of a matrix; let's see how to use it: we can take the first matrix we created and called `m1` (see the section *Values inserted by hand* of **Creating a matrix**) and traspose it. We will get a **5x4** matrix from a **4x5** one. The sintax is extremely easy, as `t:` takes only one argument:

**t: matrix_to_traspose**
```sh
  Linmeric-main> t: m1
  =>
  |   2.0   3.0   3.0   1.0  |
  |   4.0   6.0   6.0   2.0  |
  |   6.0   9.0   9.0   2.0  |
  |   8.0  12.0  12.0   3.0  |
  |  10.0  15.0  15.0   3.0  |
```
And we get our transposed matrix.

Of course we can put an expression that will produce a new matrix, such as `t: m1*3` or `t: (m1 + m1)` as the expression will be evalued first, and than `t:` will do its job.

#### Norm:
The norm of a matrix in linmeric is defined as the squared root of the sum of each squared element, that is:
```latex
  \sqrt{\sum a_i,j}
```
The commend we need to give is `norm:` followed by a matrix name (or a matrix declaration if we want) an the sintax is the same like the command `t:`. Let's test the `norm:` operator on `m1` (we used previously):
```sh
  Linmeric-main> norm: m1
  => 35.17101079013795
```
And we get the result.

#### Determinant:
Determinant of a matrix can't miss of course: here the keyword is `det:` and works exactly like the previous ones. But this operation can be performed only on squared matrices; so to try this command we create at fisrt an upper triangular (squared) matrix, so that the determinant can be quickly calculated by hand as the product of the diagonal
```sh
  Linmeric-main> lm = mx: "4,4"
  Insert the line values (separated by space) and press return to go on
  2 4 6 8
  0 1 3 5
  0 0 3 6
  0 0 0 4
  =>
  |  2.0  4.0  6.0  8.0  |
  |  0.0  1.0  3.0  5.0  |
  |  0.0  0.0  3.0  6.0  |
  |  0.0  0.0  0.0  4.0  |
```
Now we can calculate the determinant
```sh
  Linmeric-main> det: lm
  => 24
```
The result can be confirmed as it's the product `2*1*3*4`.

Linmeric uses Laplace's algorithm, and even if it has been optimized a little bit, the operation on big matrices could take a long while

___

### Exiting linmeric:
To exit the program, just type `exit`

___

## Displaying the command line guide (only version > 0.1.0):
From the command line type:
```sh
  $ linmeric -h/--help
```
and a quick help menu will be runned. Choose the option you're most interested in!

___

## Viewing the linmeric guide on gedit (only version > 0.1.0):
From the command line type:
```sh
  $ linguide <lang>
```
to open the user guide on gedit. `<lang>` must be replaced by the language you want.
The supported languages are:
- en    (English)
- it    (Italian)

Linguide is also provided by a `-h` command to view its help guide

___

## Contributing:
Bug and mistake reports and pull requests are absolutely welcomed!
To report any bug in the code or a mistake in the provided guides or in this website, please email me at max.codeware@gmail.com or on [GitHub](https://github.com/max-codeware/linmeric) to pull requests too.


*note*: Further instructions will be added as soon as possible
