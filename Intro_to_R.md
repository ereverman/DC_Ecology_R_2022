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

weight_kg <- 55

