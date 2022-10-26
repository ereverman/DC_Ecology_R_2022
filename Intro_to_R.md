## Start by getting setup:

1. Start RStudio
2. Create a New Project
3. Create a new directory called data-carpentry for the New Project
4. Click Creat Project
5. Download the code handout:

```
download.file("https://datacarpentry.org/R-ecology-lesson/code-handout.R", "data-carpentry/data-carpentry-script.R")

# This command downloads the code handout to the data-carpentry directory and saves it in that location as data-carpentry-script.R
```

### Helpful short-cuts and hints:
A list can be found here: https://raw.githubusercontent.com/rstudio/cheatsheets/main/rstudio-ide.pdf

* Execute commands: Ctrl + Enter (PC), Cmd + Enter (Mac)
* Tab to complete partially typed commands, variable names, and paths
* R indicates it is ready for a command with this symbol: > 
* To interrupt a command that is stuck or if you have a typo and can't get > back, hit ESC
* Jump between script and console panes with Ctrl + l and Ctrl + 2
* Assignment operator: Alt + - (PC), Option + - (Mac)


## Creating objects in R

```
3 + 5
12 / 7

weight_kg <- 55     # Stores information but doesn't print it

(weight_kg <- 55)   # prints and stores information
weight_kg           # prints the information that has already been stored

```
#### Stored information in objects become variables:

```
2.2 * weight_kg

# Variables/objects ARE NOT permanent and can be overwritten:

weight_kg <- 57.5
2.2 * weight_kg

# Variables/objects can be used in calculations:

weight_lb <- 2.2 * weight_kg
weight_kg <- 100
```

#### Functions and arguments:

```
weight_kg <- sqrt(10)
round(3.14159)
args(round)     # view the options or "arguments" for a function

round(x = 3.14159, digits = 2)
round(3.14159, 2)             # naming the arguments isn't necessary
round(digits = 2, x = 3.14159)    # naming the arguments allows them to be specified in any order
round(2, 3.14159)             # gives an unexpected result because R interprets unspecified arguments in the default order

```

#### Vectors and data typs:

Objects can have more than one dimension. weight_kg has a single dimension because it stores a single value. Vectors store information in 1 x n dimensions where n is any number of values. Vectors always contain information of the same data type (numbers, characters, etc). If data types are mixed in a vector, they are coerced to characters.

```
# vectors:
weight_g <- c(50, 60, 65, 82)
weight_g

animals <- c("mouse", "rat", "dog")
animals

# attributes of vectors:
length(weight_g)
length(animals)

class(weight_g)
class(animals)

str(weight_g)
str(animals)

# Adding information to vectors:
weight_g <- c(weight_g, 90) # add to the end of the vector
weight_g <- c(30, weight_g) # add to the beginning of the vector
weight_g

```

#### Subsetting vectors:

Objects are indexed in R so that pieces of information can be retrieved. R starts numbering positions at 1 instead of 0 (the reverse convention is sometimes used in other programming languages).

```
animals <- c("mouse", "rat", "dog", "cat")
animals[2]

animals[c(3, 2)]

more_animals <- animals[c(1, 2, 3, 2, 1, 4)]
more_animals

```
Subsetting can also be done in a conditional manner:

```
weight_g <- c(21, 34, 39, 54, 55)
weight_g[c(TRUE, FALSE, FALSE, TRUE, TRUE)]

# Typically conditional subsetting is done by assessing parameters:
weight_g > 50

weight_g[weight_g > 50]     # subset only the values that are greater than 50

weight_g[weight_g > 30 & weight_g < 50]   # requires both conditions to be TRUE

weight_g[weight_g <= 30 | weight_g == 55] # requires only one of the conditions to be TRUE

# It is possible to check if any of the elements of a search are true:
animals <- c("mouse", "rat", "dog", "cat", "cat")
animals[animals == "cat" | animals == "rat"]

animals %in% c("rat", "cat", "dog", "duck", "goat", "bird", "fish")           # identify the matches
animals[animals %in% c("rat", "cat", "dog", "duck", "goat", "bird", "fish")]  # subset the matches
```

#### Missing data:







