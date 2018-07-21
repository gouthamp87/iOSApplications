//
//  AppData.swift
//  QoCSample
//
//  Created by Goutham on 7/21/18.
//  Copyright © 2018 Citrix. All rights reserved.
//

import Foundation
protocol AppDataDelegate {
    func DataChanged(appList : [AppDataModel])
}

class AppData {
    var appsList : [AppDataModel] = [AppDataModel]()
    var appEntries : NSArray?
    var dataDelegate : AppDataDelegate?
    
    /* This would be the function Triggered, When App needs to Get New info.
    Triggered when either Refresh or At the start of New App
    */
    
    func getAppsData() {
        let path = "http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=100/json"
        Utilities.getDataFromUrl(url: URL(string: path)!) { (data, response, error) in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200{
                guard let appData = data else {
                    print("request failed \(String(describing: error))")
                    return
                }
                if !self.parseJSONData(jsonData: appData) {
                    print("Error with the Response Data.")
                    return
                }
            }
        }
    }

    /*
     Function to Parse the JSON result from the Network Request.
     Validate if it is of expected format and has the info required.
     */
    
    func parseJSONData(jsonData:Any) -> Bool {
        //Parse and load the View
        //Check if the result is a of the expected type
        guard let jsonResult = Utilities.parseResponse(jsonData: jsonData) as NSDictionary as? [String:AnyObject] else {
            print("Error with Parsing JSON Response, Might be an issue.")
            return false
        }
        if !Utilities.validateJSON(jsonData: jsonResult) {
            print("Error with JSON Response, Might not be of expected Type")
            return false
        }
        // Check if the Data has changed. If it has Then Reload the data. Else ignore.
        // This will reduce the network request.
        let newAppEntries = Utilities.fetchEntries(jsonResult: jsonResult as NSDictionary)
        if(newAppEntries != self.appEntries){
            self.appEntries = newAppEntries
            self.readAppEntries()
        }
        return true
    }
    
    /*
     Function to Parse the JSON Entries from the Info we have.
     Validate if it is of expected format and has the info required.
     */
    
     func readAppEntries() {
        for (index,app) in (self.appEntries?.enumerated())! {
            // We have a new AppData Entry
            // Create a new AppDataModel Object
            let appData = AppDataModel()
            // Now Append This AppData Model
            self.appsList.append(appData)
            Utilities.appEntryToAppData(app: app as AnyObject, appData: self.appsList[index])
        }
        Utilities.imageDownloadGroup.notify(queue: DispatchQueue.main, execute: {
                print("Data Has Changed.")
                self.dataDelegate?.DataChanged(appList: self.appsList)
            })
    }
    
}
