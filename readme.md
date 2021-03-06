# Custom Plasma Lockscreen
## Modifications
* Display unread gmail messages count, current weather conditions and forecast, stock market indexes
* Calendar events - birthdays/holidays
* Using qml animation timers to show current weather conditions, forecast, and stock market indexes
* kb/mouse movement, hide clock and status info, show login/password Ui <br/>
Click image for a short video demo
[![Plasma Lockscreen](lockscreen.png)](https://streamable.com/d5yiyq)

### How it works:
For security reasons, kscreenlocker does not allow internet acesss, 
Using javacript node and python to create JS variables written to file system <br/>
The JS variables are used within qml losckreen files and systemd scripts to update them. <br/>
Modified Breeze plasma qml files to get the desired effects. Designed for 1920x1080 screens. <br/>

## Requirements:
* KDE Plasma 5.15, Linux 4.x kernel w/ systemd, Node JS server, python3
* Node JS server - https://nodejs.dev/
* Python3 https://www.python.org/download/releases/3.0/
* Weather function from https://github.com/nahidulhasan/nodejs-weather-app <br/>
      * OpenWeather https://openweathermap.org/api
* Weather forecast from https://github.com/josephjguerra/node-weather-forecast-command-line <br/>
      * https://www.wunderground.com/signup
* National Day Calendar - https://natdaycal.wordpress.com/
* Stock Market info from CNN Money - 'npm install cnn' <br/>
* Python script for gmail https://github.com/akora/gmail-message-counter-python
* Gmail Oauth https://developers.google.com/gmail/api/quickstart/python
* Plasma Look And Feel Explorer installed as plasma-sdk from your distro repo
      https://userbase.kde.org/Plasma/Create_a_Look_and_Feel_Package
* Some knowledge of node javascript,python,plasma qml files,linux systemd

### Installation process. Backup original files so u can revert back.

* Extract all files to home directory / lockscreen <br/>
* Extract MyBreeze.zip to $HOME/.local/share/plasma/look-and-feel/ <br/>
   ** Custom Breeze theme for testing the qml and JS script <br/>
* Change global theme to new MyBreeze theme <br/>
  ** test lockscreen with <br/>
      /usr/lib/kscreenlocker_greet --testing --theme $HOME/.local/share/plasma/look-and-feel/MyBreeze   <br/>
 * Read install.md for detailed installation steps

