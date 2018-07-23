#  QoCSample
A sample project to interact with http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=100/json and get the info of top 100 paid iOS apps on AppStore.

## Hack for App Transport Security Override Since this isn't licenced.

```XML
<key>NSAppTransportSecurity</key>
<dict>
<key>NSExceptionDomains</key>
<dict>
<key>openweathermap.org</key>
<dict>
<key>NSIncludesSubdomains</key>
<true/>
<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
<true/>
</dict>
</dict>
</dict>
```

## ToDO
- Unit Tests(ah the necessary evil)
- Move around the Data out of ViewController.   - Done
- Move the fetching of Data and Network Request to Utilitites + make a Generic URL wrapper function. It would make more sense. - Done
- The currency can be trimmed down to two decimals. - TODO
- Parse the date to the correct format. - Done
- The utilities description need to be written. But most of them are intuitive.

## Caveats
- It a intruiging challenge and I was doing this up from scratch, including the custom Cells.
- Since there was an ask to use iOS Network API's assumed the same would be true for JSON Parsing, else we could have used Alamofire and SwiftyJSON to make things simpler. Also I didn't see the need to import a complete library for just parsing a few json values and making a few simple URLRequests.
- I tried to keep the UI Simple and strictly towards iPhones, haven't even considered iPads. The UI might be going totally awry if someone tries to do that.
- I tried to keep the code as modular as possible, but due to the speed of tryign to get this app up I might have missed something.
- The initial launch/first install would take a while for the apps to showup. But the user interaction can be avoided using a heads up display library like SVProgressHUD, but then again I didn't want to bloat up the app, tried to keep it to requirements. There is an experience Glitch.
- Haven't used any state persistence to store the data, so everytime the app loads it has to fetch info from the Server. But we can just use either CoreData(I am not too proficient, might have been good thing to learn) or Codable(Swift4 perks ) to write to file system.
- Initially thought of providing a Navigation bar to refresh the apps, but then found that it was ruining the space and just went ahead with drag to refresh to acheive that.
- Tried to segregate the code as much as possible.
- Have two image download functions.



