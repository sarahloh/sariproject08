# sari - 4th year project

sari stands for Spatial Augmented Reality Investigation.
Spatial augmented reality is also known as projection mapping.
This app uses the Twitter streaming api via the twitter client library - https://npmjs.org/twitter - to stream live tweets and sends them out over a websocket.    

Project website - http://sari.herokuapp.com/

Project blog available at http://sarahloh.wordpress.com/category/project-1/

Tutorial videos on YouTube at https://www.youtube.com/channel/UCy25WBlogHTEz6a2Ezfz4Sw/videos

## Directory contents:

     | layer 1       |  layer 2           | layer 3                |
---- | ------------- | ------------------ | ---------------------- |
 1*  | Readme.md     |                    |                        |
 2*  | app.js        |                    |                        | 
 3*  | lib           |                    |                        |        
 4*  │               | twitter.js         |                        |
 5*  | package.json  |                    |                        |
 6*  | processing    |                    |                        |
 7*  |               | libraries          |                        |
 8*  |               |                    | Syphon                 |
 9*  |               |                    | java_websocket         |
10*  |               |                    | json                   |
11*  |               | twitter_visualizer |                        |
     |               |                    | twitter_visualizer.pde |

-  1* - this Readme!
-  2* - node application ... streams live tweets and sends them out over websocket
-  3* - folder for custom node modules
-  4* - custom node module for streaming tweets ... used by app.js
-  5* - node config file
-  6* - folder for processing files
-  7* - folder for required processing libraries
-  8* - Syphon library ... taken from SyphonProcessing-1.0-RC1.zip ... https://code.google.com/p/syphon-implementations/downloads/list
-  9* - websocket library ... https://github.com/TooTallNate/Java-WebSocket
- 10* - json library ... http://www.blprnt.com/processing/json.zip
- 11* - processing sketch ... receives tweets and sends out to Syphon


## node setup:

 1. create Twitter app on https://dev.twitter.com/
 2. replace consumer_key, consumer_secret, access_token_key and access_token_secret in twitter.js (4*)
 3. install dependencies - $ npm install

## processing setup:

 1. download and install processing - https://www.processing.org/download/
 2. copy the libraries folder (7*) into your processing directory ... default is ~/Documents/Processing
 3. open the sketch (11*) 

 
## running the system:

 1. start app - $ node app
 2. run processing sketch (11*)
