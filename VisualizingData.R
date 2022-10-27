# Data Visualization with ggplot2

# Welcome back:----

# Check-in, thumbs up if you are still logged on, thumbs down if not
# Let's reload the data 

library(tidyverse)
surveys_complete <- read_csv("data/surveys_complete.csv")

# if needed:
# download.file(url = "https://ndownloader.figshare.com/files/2292169",
#               destfile = "data_raw/portal_data_joined.csv")

###
# Let's review:----

# We learned how to:
  # Read in a raw data file
  # Clean up raw data by removing missing observations and low observations 
      # (you would normally have some criteria for doing this with your own data)
  # Alter the format of your raw data to answer specific questions

# Now our goal is to visualize the data:
  # Three plot types: scatterplot, boxplot, time series plot
  # Customize and save plot settings
  # Produce meaningful plots based on data

# ggplot2:
  # Plotting package contained in tidyverse
  # Builds plots in a series of layers starting with the axes and then adding data
    # Building plots in layers allows extensive flexibility and customization
  # ggplot() is the command from the ggplot2 package
  # Works best in long format

# What is long format data?
  # A column for every variable, a row for every observation
  # open picture of rotating data: https://datacarpentry.org/R-ecology-lesson/img/tidyr-pivot_wider_longer.gif

# Resources: 
  # Hadley Wickham's book: https://ggplot2-book.org
  # Cheatsheet: https://www.rstudio.com/resources/cheatsheets/

###
# Basic plotting:----

# ggplot() syntax:
args(ggplot)   # function (data = NULL, mapping = aes(), ..., environment = parent.frame()) 

# Generic syntax:
# ggplot(data = <DATA>, mapping = aes(<MAPPINGS>)) + <GEOM_FUNCTION>()
  # mapping allows x and y axis to be specified
  # GEOM_FUNCTION is a placeholder for adding different plotting functions


# Layer 1:
ggplot(data = surveys_complete) # opens a plotting window

# Layer 2:
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) # adds axes and labels

# Layer 3:
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +  # + operator allows new layers to be added
  geom_point()  # adds a point for evey observation, makes a scatterplot


# + operator allows you to continue adding layers:
# assign plot to a variable
surveys_plot <- ggplot(data = surveys_complete, 
                       mapping = aes(x = weight, y = hindfoot_length))

# draw the plot
surveys_plot
surveys_plot + 
  geom_point()

###
# Challenge 1:----

# Scatterplots are good exploratory tools for small(ish) datasets.
# Scatterplots are less useful when there are large numbers of observations
# because the information is overplotted (points are on top of each other). 

# Hexagonal binning can help with "dense" scatterplots. 

# First, install and load hexbin:
install.packages("hexbin")
library(hexbin)

# Use geom_hex() to plot the data:

surveys_plot +
  geom_hex()

surveys_plot +
  geom_hex(bins = 50) # can change the resolution of the picture with bins = 

###
# Building plots iteratively:----

# Iteratively = modifying one thing at a time

# Start:
surveys_plot +
  geom_point()

# look up geom_point()

# Add transparency to points:
surveys_plot +
  geom_point(alpha = 0.1) # ranges 0 - 1

# Add color:
surveys_plot +
  geom_point(alpha = 0.1, color = "blue")

# Add color based on species:
head(surveys_complete)

surveys_plot +
  geom_point(alpha = 0.1, aes(color = species_id))

###
# Challenge 2:----

# Use what you just learned to create a scatter plot of weight over species_id with
# plot_type showing in different colors. Is this a good way to show the data?

ggplot(surveys_complete, aes(x = species_id, y = weight)) +
  geom_point(aes(color = plot_type))

# Not a great visual. What would be better?

###
# Boxplots:----

# Used to show distribution of observations within category:

ggplot(surveys_complete, aes( x = species_id, y = weight)) +
  geom_boxplot() 

# Customize boxplot:
# look up geom_poxplot

ggplot(surveys_complete, aes( x = species_id, y = weight)) +
  geom_boxplot(alpha = 0) + # make boxes clear
  geom_jitter(alpha = 0.3, color = "tomato")

# boxplot is in the first plotting layer, points are in the second plotting layer

# How would we change the code so that the boxes are on top of the points?
ggplot(surveys_complete, aes( x = species_id, y = weight)) +
  geom_jitter(alpha = 0.3, color = "tomato") +
  geom_boxplot(alpha = 0) # make boxes clear

###
# Challenge 3:----

# 1. Boxplots provide good summaries but don't show the shape of the distribution.
#    Replace geom_boxplot() with geom_violin()

# 2. Data transformations can help visualize patterns in certain types of data.
#    Represent weight on the log10 scale with scale_y_log10()

# 3. Make a new boxplot for hindfoot_length. Overlay the boxplot layer on top of
#    a jitter layer to show actual measurements. Add color to the data points on 
#    your boxplot according to plot_id


# 1.
ggplot(surveys_complete, aes( x = species_id, y = weight)) +
  geom_violin() 

# 2. 
ggplot(surveys_complete, aes( x = species_id, y = weight)) +
  geom_violin() +
  scale_y_log10()

# log10 transformation:
  # compresses the upper tail and stretches out the lower tail
  # can "correct" for non-linear relationship in data
  # can stabilize variation among groups to maintain within vs among group variation
  # example: https://support.minitab.com/en-us/minitab/20/help-and-how-to/calculations-data-generation-and-matrices/calculator/calculator-functions/logarithm-calculator-functions/log-base-10-function/

# 3. 
ggplot(surveys_complete, aes(x = species_id, y = hindfoot_length)) +
  geom_jitter(alpha = 0.1, aes(color = plot_id)) +
  geom_boxplot()

# What happened with the color mapping?
class(surveys_complete$plot_id)

ggplot(surveys_complete, aes(x = species_id, y = hindfoot_length)) +
  geom_jitter(alpha = 0.1, aes(color = as.factor(plot_id))) +
  geom_boxplot()
# There are too many categories to make this look very meaningful, but the color
# mapping now makes more sense

###
# Plotting time series data:----

# plot number of counts per year per genus
head(surveys_complete) # there isn't a column yet with this info

# first calculate counts:
yearly_counts <- surveys_complete %>% 
  count(year, genus)

head(yearly_counts)

ggplot(yearly_counts, aes(x = year, y = n)) +
  geom_line()

# not what we want, we have to plot data for each genus separately
ggplot(yearly_counts, aes(x = year, y = n, group = genus)) +
  geom_line()

# Add color to help distinguish lines:
ggplot(yearly_counts, aes(x = year, y = n, color = genus)) + # color groups the same way that "group" does
  geom_line()

# Using the %>% pipe with ggplot
yearly_counts %>% 
  ggplot(aes(x = year, y = n, color = genus)) +
  geom_line()

# Combine data manipulation with plot generation:
yearly_counts_graph <- surveys_complete %>% 
  count(year, genus) %>% 
  ggplot(aes(x = year, y = n, color = genus)) +
  geom_line()

yearly_counts_graph
###
# Faceting:----

# Allows data to be split across multiple plots in the same plot window

# time series plot for each genus:
ggplot(yearly_counts, aes(x = year, y = n)) +
  geom_line() +
  facet_wrap(facets = vars(genus))

# Include sex in the time series plot:
yearly_sex_counts <- surveys_complete %>% 
  count(year, genus, sex)

ggplot(yearly_sex_counts, aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_wrap(facets = vars(genus))

# Facet by sex and genus:
ggplot(yearly_sex_counts, aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_grid(rows = vars(sex), cols = vars(genus))

# Change the layout of rows and columns:
ggplot(yearly_sex_counts, aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_grid(rows = vars(genus))

ggplot(yearly_sex_counts, aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_grid(cols = vars(genus))
###
# ggplot2 themes:----

# Every component of ggplots can be modified using theme()
# There are preloaded themes that change multiple aspects at once.

# Change the background to white:
ggplot(yearly_sex_counts, aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_wrap(vars(genus)) +
  theme_bw()

# Remove grid lines:
ggplot(yearly_sex_counts, aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_wrap(vars(genus)) +
  theme_classic()

# complete list of themes: https://ggplot2.tidyverse.org/reference/ggtheme.html

###
# Challenge 4:----

# Plot the change in average weight of each species through the years:

yearly_weight <- surveys_complete %>% 
  group_by(year, species_id) %>% 
  summarise(avg_weight = mean(weight))

head(yearly_weight)

ggplot(yearly_weight, aes(x = year, y = avg_weight)) +
  geom_line() +
  facet_wrap(vars(species_id)) +
  theme_bw()
###
# Customization:----

# provide link to download ggplot cheat sheet: https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-visualization-2.1.pdf

# Change the name of axes:
ggplot(yearly_sex_counts, aes(year, n, color = sex)) +
  geom_line() +
  facet_wrap(vars(genus)) +
  labs(title = "Observed genera through time", 
       x = "Year of observation",
       y = "Number of individuals") +
  theme_bw()


# Increase font size:
ggplot(yearly_sex_counts, aes(year, n, color = sex)) +
  geom_line() +
  facet_wrap(vars(genus)) +
  labs(title = "Observed genera through time", 
       x = "Year of observation",
       y = "Number of individuals") +
  theme_bw() +
  theme(text = element_text(size = 16))

# Fix x-axis readability and italicize genera names:
ggplot(yearly_sex_counts, aes(year, n, color = sex)) +
  geom_line() +
  facet_wrap(vars(genus)) +
  labs(title = "Observed genera through time", 
       x = "Year of observation",
       y = "Number of individuals") +
  theme_bw() +
  theme(axis.text.x = element_text(color = "grey20",
                                   size = 12,
                                   angle = 90,
                                   hjust = 0.5,
                                   vjust = 0.5),
        axis.text.y = element_text(color = "grey20",
                                   size = 12),
        strip.text = element_text(face = "italic"),
        text = element_text(size = 16))

# Save customizations:
grey_theme <- theme(axis.text.x = element_text(color = "grey20",
                                               size = 12,
                                               angle = 90,
                                               hjust = 0.5,
                                               vjust = 0.5),
                    axis.text.y = element_text(color = "grey20",
                                               size = 12),
                    strip.text = element_text(face = "italic"),
                    text = element_text(size = 16))

ggplot(surveys_complete, aes(species_id, hindfoot_length)) +
  geom_boxplot() +
  grey_theme

# The parts that aren't needed (strip.text) are ignored

###
# Arranging plots:----

# faceting splits one plot into multiple, but sometimes you need multiple plots
# with different data in the same plotting window

install.packages("patchwork")
library(patchwork)

# patchwork syntax:
  # "+" places plots next to each other
  # "/" arranges plots vertically
  # plot_layout() determines how much space each plot uses

plot_weight <- ggplot(surveys_complete, aes(species_id, weight)) +
  geom_boxplot() +
  labs(x = "Species", y = expression(log[10](Weight))) + # allows placement of subscript
  scale_y_log10()

plot_count <- ggplot(yearly_counts, aes(year, n, color = genus)) +
  geom_line() +
  labs(x = "Year", y = "Abundance")

# Arrange the plots:
plot_weight / plot_count + plot_layout(heights = c(3, 2))

# Go here to find more layouts: https://patchwork.data-imaginist.com/
###
# Exporting plots:----

# Export tab in plot pane saves plots at low resolution (not publication/presentation quality)
# Some publications have specific themes and all have resolution requirements
# Extensions website has a list of packages that can be helpful in making publication quality plots:
# https://exts.ggplot2.tidyverse.org

# Use ggsave()
plot_count

ggsave("Yearly_Genus_Counts.png", plot_count, width = 15, height = 10 )

# make a new folder:
ggsave("plots/Yearly_Genus_Counts.png", plot_count, width = 15, height = 10)  # width and height also change font size


# Save patchwork plots:
plot_combined <- plot_weight / plot_count + plot_layout(heights = c(3, 2))
plot_combined

ggsave("plots/plot_combined.png", plot_combined, width = 10, dpi = 300)

###
# Other Resources: https://www.data-to-viz.com
