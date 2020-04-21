# Shiny Classifier

This shiny application simplifies the manual classification of images in a R framework by providing a simple but usefull user interface. 

# How it works ? 

To set up this classification application, you need to : 
- Download this repository
- Modify the class name to suit your needs
- Put a csv file with a column containing the filepath of images you want to classify in the repository of the application

When you start the shiny application : 
- Load the csv file 
- Choose the column containing filepaths of images 
- Either start a new classification (this will create a column in your file on save) or resume a classification (this will update the column you selected on save)
- Save when you want to quit the application ! (This will modify the provided file)

