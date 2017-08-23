{:.no_toc}
# Welcome to linmeric user guide
### This page will provide a simple guide to learn how to use this simple command line calculator
{:.no_toc}
___
{:.no_toc}
## Index
* table of content
{:toc}

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

## Version changes:
### 0.1.0
- first release

### 0.2.0
- A better documentation has been provided
- Matrix expression converter has been rewritten to get better performances
- Help menu and guides have been added
- Some bugs have been fixed

## Running linmeric:
From the command line type:
```sh
  $ linmeric
  Linmeric-main> 
```
and the calculator will be immediately run.

## Simple examples:
### Using linmeric as an ordinary calculator:
Linmeric can be used as a normal calculator of course, just simply typing the numeric expressions. For instance we want to know the result of `3^(5*4)`:

```sh
  Linmeric-main> 3^(5*4)
  => 3486784401
```
and we get `3486784401`. Feel free to try every numeric expression you want!

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

### Exiting linmeric:
To exit the program, just type `exit`

## Displaying the command line guide:
From the command line type:
```sh
  $ linmeric -h
```
or
```sh
  $ linmeric --help
```
and a quick help menu will be runned. Choose the option you're most interested in!

## Viewing the linmeric guide on gedit:
From the command line type:
```sh
  $ linguide <lang>
```
to open the user guide on gedit. `<lang>` must be replaced by the language you want.
The supported languages are:
- en    (English)
- it    (Italian)

Linguide is also provided by a `-h` command to view its help guide

## Contributing:
Bug and mistake reports and pull requests are absolutely welcomed!
To report any bug in the code or a mistake in the provided guides or in this website, please email me at max.codeware@gmail.com or on [GitHub](https://github.com/max-codeware/linmeric) to pull requests too.


*note*: Further instructions will be added as soon as possible
