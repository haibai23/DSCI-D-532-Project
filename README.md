Nicholas Perry
Final Project Part 4


For the model, I am using MySQL for storing the necessary data. The view will be developed with Shiny in R using RMySQL to connect to the MySQL database. The controller will also be developed using Shiny in R.
Data Storage:
Web application architecture is an important component of any data-based project. The data for this project is being stored in a noSQL MySQL. 
Back-end Development:
This database will be accessed by using the RMySQL package in R.  
Database Access:
The database will be accessed via a connection using the API by providing the necessary credentials to access it. It will only be editable by those with the necessary credentials. 
Front-end Layout:
For the front-end, I will be using the shiny package within R in order to create a detailed web app interface application. This will also assist in hosting the web app and controlling permissions for who can and cannot access the underlying data. 
Application Deployment:
The application will be deployed using the shinyapps.io server in order to be deployable. 
Data Used:
The dataset for this analysis was uploaded to Kaggle. Every play, no matter the result, was given a row in the data table. The dataset is composed of 356,768 rows and 100 columns. The data was originally collected by a group of researchers at Carnegie Mellon University in order to develop win probability models for the NFL. The data is in a tabular form with a column called “GameID” that acts as a unique identifier for each game, but there is no unique identifier inherently in the table. The data also includes penalties, time left in the game, the side of the field, the yards to go for a first down, the result of the play, and the rusher or receiver of the ball.
App Interactivity:
The application will have drop-down menus in order to select the variable for visualization on the “Histograms” tab. Users with the necessary credentials will also be able to create the necessary characteristics of a play in order to update the database or to add a new play. 

Individual Work Assessment:
I am satisfied with my work to this point. I feel that I could continuing working on this for other courses in the degree program. I could also continue working on the deployability and interactivity to share this app with future employers or schools. I enjoyed learning Shiny and using it to deploy an app. I also think that the database creation and querying portion was a fairly small part of this project. In the future, perhaps there could also be a project or homework assignment that focuses more on querying the various database technologies that we learned about. 
