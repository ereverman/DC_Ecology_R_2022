## Starting with data

#### Load the survey data:

```
# if needed, make the data_raw directory
mkdir(data_raw)


download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")
```

#### Reading the data into R:

Downloading the datafile only made it available in your R project. We have to load the datafile into R in order to work with it.

```
library(tidyverse)    # load a package that allows access to specific functions that are built on top of basic R commands and functions. There are other ways to read in data files without loading a package.

surveys <- read_csv("data_raw/portal_data_joined.csv")    # assumes data are delimited by commas. there are other options that will accomdate other separator types

head(surveys)   # take a look at the data to ensure it loaded properly
view(surveys)   # part of tidyverse
View(surveys)   # part of base R. Command + click also opens the datafile in viewer (on a mac)

```

#### Dataframes:

Dataframes are combinations of vectors. If vectors have one dimension 1 x n, dataframes have 2 dimensions n x n. Dataframes can contain multiple vectors that each have different datatypes.

```
str(surveys)

dim(surveys)
nrow(surveys)
ncol(surveys)

head(surveys)
tail(surveys)

str(surveys)
summary(surveys)
```

#### Indexing and subsetting dataframes:

```
# We can extract specific values by specifying row and column indices
# in the format: 
# data_frame[row_index, column_index]
# For instance, to extract the first row and column from surveys:
surveys[1, 1]

# First row, sixth column:
surveys[1, 6]   

# We can also use shortcuts to select a number of rows or columns at once
# To select all columns, leave the column index blank
# For instance, to select all columns for the first row:
surveys[1, ]

# The same shortcut works for rows --
# To select the first column across all rows:
surveys[, 1]

# An even shorter way to select first column across all rows:
surveys[1] # No comma! 

# To select multiple rows or columns, use vectors!
# To select the first three rows of the 5th and 6th column
surveys[c(1, 2, 3), c(5, 6)] 

# We can use the : operator to create those vectors for us:
surveys[1:3, 5:6] 

# This is equivalent to head_surveys <- head(surveys)
head_surveys <- surveys[1:6, ]

# As we've seen, when working with tibbles subsetting with single square brackets ("[]") always returns a data frame.
# If you want a vector, use double square brackets ("[[]]")

# For instance, to get the first column as a vector:
surveys[[1]]

# To get the first value in our data frame:
surveys[[1, 1]]

# Indexes can also be used to exclude information:
surveys[, -1]                 # The whole data frame, except the first column
surveys[-(7:nrow(surveys)), ] # Equivalent to head(surveys)


# Subsetting can be achieved by using column names instead of indexes:
# As before, using single brackets returns a data frame:
surveys["species_id"]
surveys[, "species_id"]

# Double brackets returns a vector:
surveys[["species_id"]]

# We can also use the $ operator with column names instead of double brackets
# This returns a vector:
surveys$species_id

```

#### Factors:

When information is stored as character values in a dataframe but is meant to group data, this type of data is called a factor. Factors are important for running analyses and plotting data correctly.

```
surveys$sex <- factor(surveys$sex)
summary(surveys$sex)

# R sorts factors in alphanumerical order:
sex <- factor(c("male","female","female","male"))     # female is assigned factor level 1 and male is assigned factor level 2
levels(sex)
nlevels(sex)

# Sometimes order of the factor levels matters (direction of a comparison: treated vs control; plotting data)
sex   # current order
sex <- factor(sex, levels = c("male","female"))
sex   # new order

```

#### Converting factors:

It is sometimes necessary to convert between factors and numbers. This poses a problem because factor levels are stored as numbers.

```
year_fct <- factor(c(1990, 1983, 1977, 1998, 1990))
year_fct

as.numeric(year_fct)    # wrong, with no warning
as.numeric(as.character(year_fct))    # works
as.numeric(levels(year_fct))[year_fct]  # this is the recommended way, less prone to unexpected data handling

```

#### Renaming factors:

We often record data using abreviations or by stringing words together with CamelCase or "." or "_".


```
