# Context
This folder holds a java/maven project to package the "DAISY Pipeline 2" conversion server. It also includes a command line interface and swing-based graphical interface to use the DAISY Pipeline 2 as a oneshot conversion tool to be launched from a terminal. 
Currently, the graphical interface provided is only reporting progression of a conversion requested from the command line.

# Features wanted

I would like to complete graphical interface with the following features or scenario

## Cached scripts and datatypes definitions

If they don't exists, a cached definition of scripts and datatypes should be stored in user space appdata (i.e. "%APPDATA%/DAISY Pipeline 2/scripts.xml" and "%APPDATA%/DAISY Pipeline 2/datatypes.xml")

Current export of those files is implemented in the command line interface for "scripts" and "datatypes" commands.

## Settings dialog

A new "Settings" dialog would allow to load, modify and store back settings in user space appdata folder of the DAISY pipeline 2 (i.e. on windows, in "%APPDATA%/DAISY Pipeline 2/user-settings.xml")
  - A list of most properties is defined in the `properties.xml` file along this markdown, but some are "hidden" and would need to be added manually while they are not formerly exposed.
  - by default, those settings value are textual (String), but there can boolean (true/false) or integer (-999/999) values, to deduce from the properties. The correct type of input should be deduced from the default value provided if it exists.
  - When saving back the settings :
    - The properties should be set accordingly
    - The cached definitions of scripts and datatypes should be recomputed before closing the settings dialog (an small label next to the save button should indicate to the user that the program is "Reenabling ")
  - Among settings, i would like to allow the user to create "scripts defaults settings" : in a "Scripts options" tab, user should be able to select a script in a list, and then view and modifiy default conversion options for this script. 
  those options should then be saved in the settings and reuse when launching a conversion with the script.

## Merged "Conversion form" and "Progress dialog"

Given a script definition, a new "conversion form" should allow a user to configure the script input, output and options. 
A "Convert" button would launch the conversion to be monitored, similarly as what is done with the current progress dialog implemented in the GraphicalInterface class.

If possible, i'd like to keep a "single window" approach : 
I would like the current progress dialog to begin a full fledge conversion form with progression report during execution.
With the current 

instead of opening a new window, i'd like the progress message and progress bar to be displayed on top, and a "details" button would expand the UI on the left to show the log in the text area. Clicking the button again would hide back the text area and reduce the UI area.


## Full GUI usage 

The following scenario are considered :
- If the GraphicalInterface main function is called without any argument
  - The code should open a file selection window, where the user can either browse for a file or drag-and-drop a file he wants to convert, and the user can browse for an output folder where the result would be stored
    - Authorized input files are zip, html, "ncc.html" (daisy2.02), opf file (daisy3 or unzipped epub), epub file, docx document, xml files and pdf
    - If the file is a zip :
      - check if it contains an opf and if so identify it as daisy3
      - check if it contains an ncc.html and if so identify it as daisy202
    - if the file is an xml file, 
      - Check if the file is a dtbook file (with a `<dtbook ...>` root node)
      - Check if the file is a zedai file (with a `<document ...>` root node)
    - When the window is opening, the code should also start to load and cache all available conversion scripts and datatypes
      - Those precomputed scripts and datatypes could be computed and loaded back as xml files stored in user data space (like "%APPDATA%/DAISY Pipeline 2" folder). A later goal would be to have both globals and script-specifics default settings modifiable by the user using another dialog.
    - The output folder is mandatory, and a warning should be displayed if the selected folder is not empty
    - A "Cancel" button would close the application
  - based on the selected file, the window should update to expose the list of available "scripts" that can take as input the file
    - if the document is a docx, only expose the script starting with the name "word-to"
    - if the document is a daisy202, only expose the script starting with the name "daisy202-to"
    - if the document is a daisy3, only expose the script starting with the name "daisy3-to"
    - if the document is a html (not ncc.html), only expose the script starting with the name "html-to"
    - if the document is an epub, only expose the script starting with the name "epub3-to"
    - if the document is an zedai document, only expose the script starting with the name "zedai-to"
    - if the document is a dtbook document, only expose the script starting with the name "dtbook-to"
    - if the document is a pdf, only expose the script starting with the name "pdf-to"
  - Depending on the selected script, the window should update to display the "conversion form" underneath the "scripts" list, that is :
    - The list of options to be set by the user to run the conversion script
    - A "Convert" button to launch the conversion with the currently selected options values.
      - This button could be first invisible in the UI next to the "Cancel" button and displayed only when a script is selected.
- If the GraphicalInterface main function is called with the command "prepare" followed by a script and a "--source inputfile" (and optionnaly other options of the script) : 
  - Open a window that displays
    - an output folder selector (label, text field and browse folder button that opens a folder selector
    - The conversion form 
  - Display the "conversion form" as previously 



