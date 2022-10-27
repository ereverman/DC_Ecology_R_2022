# Manipulating, analyzing, and exporting data with tidyverse

# Welcome back:----

# Check-in, thumbs up if you are still logged on, thumbs down if not
# Let's reload the data 

library(tidyverse)
surveys <- read_csv("data_raw/portal_data_joined.csv")

# if needed:
# download.file(url = "https://ndownloader.figshare.com/files/2292169",
#               destfile = "data_raw/portal_data_joined.csv")

###
# Let's review:----

# We have learned how to subset data using base R bracketing syntax, but this can get complicated and hard to read:

na.omit(surveys[surveys$"sex" == "F" & surveys$weight < 5, c("species_id", "sex", "weight")])

# Breaking commands into steps can make code easier to read and reproduce, which should be one of our goals as we do data analysis.

# The data we collect aren't always immediately ready for analysis:
  # The equipment outputs data in a specific format
  # Datasheets are printed to help with data collection not with data analysis (not necessarily anyway)
  # Even if the raw data can be analyzed one way, sometimes they need to be reformatted to work with a different analysis or question


# Tidyverse
  # A package of packages: it contains within it several other packages that all use the same syntax
  # Developed by the Hadley Wickham group: https://r4ds.had.co.nz/index.html
  # Cheatsheets are available that help distill the primary uses of tidyverse packages and functions: https://www.rstudio.com/resources/cheatsheets/
  
# dplyr and tidyr:

# dplyr:
  # helps with manipulating dataframes
  # can work with data in external databases
  # can return data obtained from external databases

# tidyr:
  # helps reshape data

###
# Selecting columns and filtering rows:----

# Select columns of a dataframe with select()
colnames(surveys)     # we want plot_id, species_id, and weight
args(select)          # syntax: .data = dataframe, ... = names of columns
select(surveys, plot_id, species_id, weight)    # syntax: dataframe


# Select all columns EXCEPT
colnames(surveys)
select(surveys, -record.id, -species.id)  # - indicates exception


# Choose rows based on criterion with filter()
colnames(surveys)  # filter by year, but what are the years in the data?
unique(surveys$year)  # pick 1995
filter(surveys, year == 1995)   # only shows the first 10 rows, but can see from the dimensions that there are far fewer observations

###
# Combining select and filter:----

# Three ways to do this:
  # use intermediate steps
  # nest functions
  # use pipes: %>% (Cmd + shift + m, mac; Ctrl + shift + m, pc)


# Intermediate steps:
surveys2 <- filter(surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)

# Nested functions:
surveys_sml2 <- select(filter(surveys, weight < 5), species_id, sex, weight)   # watch out for errant parentheses!

# Pipes:
surveys %>% 
  filter(weight < 5) %>% 
  select(species_id, sex, weight)

# In human: "take surveys, then FILTER rows by weight < 5, then SELECT columns species id, sex, weight"

# save the output:
surveys_sml <- surveys %>% 
  filter(weight < 5) %>% 
  select(species_id, sex, weight)

###
# Challenge 1:----

# Using pipes, subset the surveys data to include animals collected before 1995 and retain only columns year, sex, and weight

surveys %>% 
  filter(year < 1995) %>% 
  select(year, sex, weight)

###
# Mutate:----

# Create new columns based on values in the dataframe
  # unit conversions
  # calculate rate

# Create a new column in surveys: weight in kg
colnames(surveys) # weight exists

surveys %>% 
  mutate(weight_kg = weight / 1000)

head(surveys)  # data frame hasn't changed!

# multiple new columns:
surveys %>% 
  mutate(weight_kg = weight / 1000,
         weight_lb = weight * 2.2)

# Pipes can interact with non-tidyverse functions:
surveys %>% 
  mutate(weight_kg = weight / 1000) %>% 
  head()


# Combine mutate and filter to remove NA's:
surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg = weight / 1000) %>% 
  head()

# ! means "not"

###
# Challenge 2:----

# Create a new data frame from the surveys data that meets the following criteria: 
  # Contains only the species_id column and a new column called hindfoot_cm 
  # Convert hindfoot_length values (currently in mm) to centimeters in the hindfoot_cm column. 
  # Remove NAs and all values 
  # Only include observations when hindfoot_cm is less than 3.

# Hint: think about the best way to order the commands

surveys_hindfoot_cm <- surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  mutate(hindfoot_cm = hindfoot_length / 10) %>% 
  filter(hindfoot_cm < 3) %>% 
  select(species_id, hindfoot_cm)

head(surveys_hindfoot_cm)


# other ways work, but mutate has to come before filtering on hindfoot_cm and select has to come last
surveys_hindfoot_cm <- surveys %>% 
  mutate(hindfoot_cm = hindfoot_length / 10) %>% 
  filter(hindfoot_cm < 3) %>% 
  filter(!is.na(hindfoot_length)) %>% 
  select(species_id, hindfoot_cm)
###
# Split-apply-combine and summarize():----

# Data analysis:
  # split data into groups
  # analyze each group
  # combine the results

# group_by() and summarize()

surveys %>% 
  group_by(sex) %>% 
  summarize(mean_weight = mean(weight))

# mean function requires no missing data:
surveys %>% 
  group_by(sex) %>% 
  summarise(mean_weight = mean(weight, na.rm = TRUE))


# group_by multiple columns:
surveys %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight, na.rm = TRUE)) 

# Combine filter, group_by, and summarize:
surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight)) 

# note that the number of rows in each dataframe is different:
  # This is because the first version retains rows for NA values
  # the second version removes them first so there is no placeholder for them

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight)) %>% 
  print(n = 15)


# Summarize by multiple variables:
surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),
            min_weight = min(weight))


# Arrange output to an order that is easier to interpret:
surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight),
            min_weight = min(weight)) %>% 
  arrange(min_weight) # sorts with lighter species first

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight),
            min_weight = min(weight)) %>% 
  arrange(desc(min_weight)) # sorts with lighter species last

###
# Counting:----

# How many observations do we have for each factor or combination of factors?

surveys %>% 
  count(sex)

# Count is a shortcut for:
surveys %>% 
  group_by(sex) %>% 
  summarise(count = n())

# arrange output:
surveys %>% 
  count(sex, sort = TRUE)   # largest category is first

# Count combinations of factors:
surveys %>% 
  count(sex, species)       # counts observations of each species of each sex, alphabetically sorted for F then M then NA

# Change the arrangement of the output:
surveys %>% 
  count(sex, species) %>% 
  arrange(species, desc(n))  # sorts by species first, then sorts highest to lowest N observations for each sex observed for the species

###
# Challenge 3:----

# 1. How many animals were caught in each plot_type surveyed?
# 2. Use group_by() and summarise() to find the mean, min, and max hindfoot 
#    length for each species (use species_id). Also add the number of 
#    observations (hint: see ?n).
# 3. What was the heaviest animal measured in each year? Return the columns year,
#    genus, species_id, and weight.

# 1. 
surveys %>% 
  count(plot_type)

# 2. 
surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  group_by(species_id) %>% 
  summarise(mean_hindfoot_length = mean(hindfoot_length),
            min_hindfood_length = min(hindfoot_length),
            max_hindfoot_length = max(hindfoot_length),
            n = n())

# 3. 
surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(year) %>% 
  filter(weight == max(weight)) %>% 
  select(year, genus, species_id, weight) %>% 
  arrange(year)

###
# Reshaping with pivot_longer and pivot_wider:----

# Tidyverse functions work best with tidy data--What is tidy data?
  # Each variable forms a column
  # Each observation forms a row
  # One piece of information per cell
  # Each type of observational unit forms a table

# example of Messy data: https://datacarpentry.org/spreadsheet-ecology-lesson/fig/multiple-info.png
# example of Tidy data: https://datacarpentry.org/spreadsheet-ecology-lesson/fig/single-info.png

view(surveys)
# rows contain values of variables associated with each record or unit: weight or sex of each animal
# Now it is easy to compare between records
# What if we wanted to compare mean genus weight between plots?
  # There are 24 plots and each plot appears multiple times in the current format
  # Instead of one row per record, we need a data frame with one row per plot
  # Genera would become column names

# open picture of rotating data: https://datacarpentry.org/R-ecology-lesson/img/tidyr-pivot_wider_longer.gif


# pivot_wider: reshape from long format to wide format
  # data frame
  # names_from = column variable whose values become new column names
  # values_from = column variable whose values become new column variables

# transform surveys to find mean weight of each genus in each plot over survey period:
surveys_gw <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(plot_id, genus) %>% 
  summarise(mean_weight = mean(weight))

view(surveys_gw) # long format data frame, multiple rows per plot

# What we want: one row per plot and mean weight for each genus column: https://datacarpentry.org/R-ecology-lesson/img/pivot_wider_graphic.png

surveys_wide <- surveys_gw %>% 
  pivot_wider(names_from = genus, values_from = mean_weight)

view(surveys_wide)

# There are missing values, fill these with 0
surveys_wide <- surveys_gw %>% 
  pivot_wider(names_from = genus, values_from = mean_weight, values_fill = 0)

# Why did we want to do this?
# Primary reason is that it makes it easier to visualize comparisons between weights in different plots
# Also makes it easier to see how the plots compare in representation of genera


# Pivot wide to long format:

# pivot_longer: reshape from wide format to long format
  # data frame
  # names_to = column variable we want to create from multiple columns
  # values_to = column variable we want to create and fill with values
  # also need to specify which columns to reshape

# What we want: one row per genus and mean weight for each genus column: https://datacarpentry.org/R-ecology-lesson/img/pivot_longer_graphic.png

colnames(surveys_wide)  # want genus names to come from Baiomys through Spermophilus
surveys_long <- surveys_wide %>% 
  pivot_longer(cols = Baiomys:Spermophilus, names_to = "genus", values_to = "mean_weight")  # the first column does not contain weight values, so don't include it for the pivot

view(surveys_long)
# This is very similar to surveys_gw EXCEPT
  # Each plot has the same number of genera
  # The genera that are not represented have a mean weight of 0

surveys_long <- surveys_wide %>% 
  pivot_longer(cols = -plot_id, names_to = "genus", values_to = "mean_weight")  # the first column does not contain weight values, so don't include it for the pivot

view(surveys_long)
###
# Challenge 4:----
# 1. Reshape the surveys data frame with year as columns, plot_id as rows, 
#    and the number of genera per plot as the values. You will need to summarize 
#    before reshaping, and use the function n_distinct() to get the number of unique 
#    genera within a particular chunk of data. It’s a powerful function! 
#    See ?n_distinct for more.

surveys_wide_genera <- surveys %>% 
  group_by(plot_id, year) %>% 
  summarise(n_genera = n_distinct(genus)) %>% 
  pivot_wider(names_from = year, values_from = n_genera)

# 2. Now take that data frame and pivot_longer() it, so each row is a unique 
#    plot_id by year combination.

surveys_wide_genera %>% 
  pivot_longer(cols = -plot_id, names_to = "year", values_to = "n_genera")

# 3. The surveys data set has two measurement columns: hindfoot_length and weight. 
#    This makes it difficult to do things like look at the relationship between 
#    mean values of each measurement per year in different plot types. Let’s walk 
#    through a common solution for this type of problem. 

#   First, use pivot_longer() 
#    to create a dataset where we have a names column called measurement and a 
#    value column that takes on the value of either hindfoot_length or weight. 
#    Hint: You’ll need to specify which columns will be part of the reshape.

surveys_long <- surveys %>% 
  pivot_longer(cols = c(hindfoot_length, weight), names_to = "measurement", values_to = "value")

#  Then calculate the average of each measurement in each year for each different 
#    plot_type. Then pivot_wider() them into a data set with a column for 
#    hindfoot_length and weight. Hint: You only need to specify the names and 
#    values columns for pivot_wider().

surveys_long %>% 
  group_by(year, measurement, plot_type) %>% 
  summarise(mean_value = mean(value, na.rm = TRUE)) %>% 
  pivot_wider(names_from = measurement, values_from = mean_value)
###
# Exporting data:----

# Data manipulation is easy with tidyvers, but that doesn't mean you want to do
# the same set of operations every time you run your analysis.

# We can use write_csv() to write a file, but we need a place to put it first:
# Make a directory called data/
# Store the processed data files in a new place to protect the original files
# We can always regenerate the processed files from the originals

# Make a cleaned data file for the next section:

# remove observations missing weight and hindfoot_length measurements and sex id:
surveys_complete <- surveys %>% 
  filter(!is.na(weight),
         !is.na(hindfoot_length),
         !is.na(sex))

view(surveys_complete)


# We eventually want to plot species abundance through time:
  # remove observations for rare species (observed less than 50 times)

# extract the most common species:
species_count <- surveys_complete %>% 
  count(species_id) %>% 
  filter(n >= 50)

view(species_count)

# only keep the most common species:
surveys_complete <- surveys_complete %>% 
  filter(species_id %in% species_count$species_id) # keep the rows that match species_id in species_count

# Check dimensions:
dim(surveys_complete)

# Write file:
write_csv(surveys_complete, file = "data/surveys_complete.csv")
###
