Detailed install steps

### Data scrapers
* See https://developers.google.com/gmail/api/quickstart/python for more info
* From github - https://github.com/akora/gmail-message-counter-python modify for your inbox, setup Oauth credentials
   ** Modified to write to a file the unread mail count, add categories - updates, social, 
      use counter.py provided, instead of one from github
* Install node js server within that folder
* Install node js scripts for ical, fs, weather, cnn
* natday1.js is the event info JS, change location to write variable file
* modify weather scripts enter api keys, your city and change location to write js variable file
     * within my github there are modified weather scripts of the originals
     * use these in place of the ones downloaded from above
* Copy systemd scripts to systemd folder and start and enable services
* Edit supplied qml files to change location of JS variables for your system
* Copy qml files to the new theme folder created

### Systemd
* There are systemd service/timer scripts for each part of the lockscreen data scapers
* Copy these to /etc/systemd/system
* enable the .service/timer files - sudo systemctl enable gmail.service
* start the .timer service files  - sudo systemctl enable gmail.timer, sudo systemctl start gmail.timer
* To update when system awakes from sleep mode
    * Copy the wakeup.sh scripts to /lib/systemd/system-sleep/
    


### Testing 
___________
* Change global theme to new MyBreeze theme <br/>
  ** test lockscreen with <br/>
      /usr/lib/kscreenlocker_greet --testing --theme $HOME/.local/share/plasma/look-and-feel/MyBreeze   <br/>
* Test ical event info with > with node natday1.js  will retrieve calendar event and create <br/>
   natday.js variable file used in Clock.qml
* Test current weather info with > node index.js will retrieve temperature info and create temp.js <br/>
  variable file used in Clock.qml
  * Test weather forecast with >  node forecast.js <br/>
* Test gmail count with python3 counter.py - use counter.py provided, <br/>
    will retrieve unread mail count info and create gmail.js 
* Test Lockscreen with /usr/lib/kscreenlocker_greet --testing --theme $HOME/.local/share/plasma/look-and-feel/MyBreeze
* Verify SYSTEMD settings in System Settings  > SYSTEMD > TIMERS  - should be a description of the timers installed above.

### Notes
____________
* node js server required for js scripts
* ical, fs, weather-app install required to work
* using node JS functions and systemd to run the scripts at certain times to keep lockscreen current
* you must edit the qml files to reflect the location of these files, also the node JS files must be changed 
    to reflect the location to write the JS variable files
* optional - modify natday1.js to your own public event calendar
* weather function from https://github.com/nahidulhasan/nodejs-weather-app - 
       modified to write to file, use provided index.js to get the file system write logic
* Weather forecast from https://github.com/josephjguerra/node-weather-forecast-command-line <br/>
      * modified to write to file, use provided forecast.js to get the file system write logic
#### Node JS functions
* node natday1.js creates file called natday.js which is used in Clock.qml as a variable with import statement
* node weather creates file called temp.js which is used in Clock.qml as a variable with import statement
* current weather info function from https://github.com/nahidulhasan/nodejs-weather-app - modified to write to file instead of console

#### Python 3 functions
* python3 counter.py calls gmail to get unread mail messages and creates a file gmail.js  used in Clock.qml as a variable with import statement
