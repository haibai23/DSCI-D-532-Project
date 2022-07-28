# DSCI-D-532-Project

Nicholas Perry
Final Project Part 3

Overview:
For the model, I am using MongoDB for storing the necessary data. The view will be developed with Shiny in R using mongolite to connect to the MongoDB database. The controller will also be developed using Shiny in R.
Data Storage:
Web application architecture is an important component of any data-based project. The data for this project is being stored in a noSQL MongoDB. 
Back-end Development:
This database will be accessed by using the mongolite package in R.  
Database Access:
The database will be accessed via a connection using the API by providing the necessary credentials to access it. It will only be editable by those with the necessary credentials. 
Front-end Layout:
For the front-end, I will be using the shiny package within R in order to create a detailed web app interface application. This will also assist in hosting the web app and controlling permissions for who can and cannot access the underlying data. 
Application Deployment:
The application will be deployed using the shiny server in order to be deployable. 
App Interactivity:
The application will have drop-down menus in order to select teams and seasons. There will also be drop-down menus to toggle between different charts showing the outcome of 4th down plays. Users with the necessary credentials will also be able to create the necessary characteristics of a play in order to update the database. 






Web App Schema:
 
Web App Layout:
Users of this web app will first be asked for their credentials in order to access the application. A prototype of a credential input screen is shown below:
 
Users must enter a proper email address and password in order to read or edit data. Once credentials are correctly submitted, the users will then be taken to the main page of the web application. A prototype of the main page is shown below:
   
Users will be asked to input the NFL team they are interested in, as well as the NFL season and the down of play. They will also be able to customize the visualization by choosing which result, or results, they are interested in seeing. Users will have the options of viewing histograms with TD, FG, INT, FUMB, and TOD (Touchdowns, Field Goals, Interceptions, Fumbles, and Turnover on Downs, respectively). 
There will also be a secondary page where users with proper credentials can input new data into the database. A mockup of the input screen is shown below:
 
Users will be asked to enter all of the necessary information in order to add to the database. There will be input controls in order to ensure that only proper data is entered. All data fields shown will also be constrained to be necessary for input.


Individual Work Assessment:
I am satisfied with my work to this point. I feel I have met the necessary milestones and am well positioned to finish the final part on time. I think that the scope of the work that I have done is proportional to that of larger groups. 
