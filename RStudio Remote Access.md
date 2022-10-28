# DC_Ecology_R_2022
ERE instructor notes for DC Ecology R workshop 2022


## Logging on to access RStudio Remote Environment:

* Address: https://jupyter.lib.ku.edu
* Click "Sign in with CILogon"
* In the “Select an Identity Provider” box, pull down the menu and search for your institution.
* Choose your institution and click Log On. You will be routed to your institution’s Single Sign On, where you can authenticate.
* Once you have signed in, you will see Server Options. Choose “Stack RStudio” and click Start.
* The server will start; you will see the blue bar move as resources are assigned and the image builds. On first login, this may take 5 minutes or so. You don’t need to do anything while the image builds.
* When everything is ready, you will see a Jupyter Notebook interface in your browser window. RStudio will be a software option in the starter page.
* Since the data is loaded into R as a part of the lesson material, there is no dedicated workshop data directory in this server image – instructors can direct learners to create their working environment in the same way as working with a local installation.
* When you are ready to close the instance, go to File and choose Log Out. Once the server has closed you can close your browser tab.

## Exporting your work:

 * Click the box next to your R project in the file manager pane
 * Click the arrow next to the gear/settings icon
 * Click Export
 * Click Download (this will download a .zip file containing the project, directories, data, and plots)
 * Navigate to Downloads on your computer
 * Decompress the downloaded directory (this should contain all of your work)

## Helpful links:

* Executive summary of links you will need:
* Remote computing site: https://jupyter.lib.ku.edu (directions below)
* Workshop site: https://kulibraries.github.io/2022-10-28-ku-r-online/
* Workshop Etherpad: https://pad.carpentries.org/2022-10-28-ku-r-online
* Lesson site: https://datacarpentry.org/R-ecology-lesson/
 

## Troubleshooting:

###  RStudio isn't visible
If after logging on you reach an Untitled.ipynb and you do not see the option to click on RStudio, open a new Launchpage by
 * Click File
 * Click New Launcher
 * Click RStudio (located under Notebook)

### RStudio asks you to choose file encoding when saving a file
If non-ASCII characters are present (from copy and pasting a command) this prompt will appear
  * Choose UTF-8 
  * Click save

