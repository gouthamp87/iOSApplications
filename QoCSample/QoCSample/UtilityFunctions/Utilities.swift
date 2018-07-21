//
//  Utilities.swift
//  QoCSample
//
//  Created by Goutham on 7/19/18.
//  Copyright © 2018 Citrix. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    
    static let imageDownloadQueue = DispatchQueue(label: "com.citrixiOSblr.QoCSampleImages")
    static let imageDownloadGroup = DispatchGroup()
    
    static func parseResponse(jsonData:Any) -> NSDictionary {
        var jsonResult: NSDictionary?
        do{
            jsonResult = (try JSONSerialization.jsonObject(with: jsonData as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary)!
        } catch{
            jsonResult = ["Error":error]
        }
        return jsonResult!
    }
    
    static func validateJSON(jsonData:[String:Any]) -> Bool{
        var result = false;
        //Check for "feed" key in jsonData/ Else return
        if jsonData["feed"] != nil {
            let feed = jsonData["feed"] as? NSDictionary
            // Now check if there is a field "entry" and if it is of type TypeArray
            if (feed!["entry"] as? NSArray) != nil{
                result = true
            }
        }
        return result
    }
    
    static func appEntryToAppData(app : AnyObject, appData: AppDataModel){
        appData.title = Utilities.fetchTitleFromEntry(app: app as! [String : AnyObject])
        // Summary
        appData.summary = Utilities.fetchSummaryFromEntry(app: app as! [String : AnyObject])
        // Link
        appData.appLink = Utilities.fetchAppLinkFromEntry(app: app as! [String : AnyObject])
        //TODO: Release Data as MM/DD/YY
        appData.releaseDate = Utilities.fetchReleaseDateFromEntry(app: app as! [String : AnyObject])
        // ICON Paths
        appData.thumbNailPath = Utilities.fetchThumbNailLinkFromEntry(app: app as! [String : AnyObject])
        appData.iconPath = Utilities.fetchAppICONFromEntry(app: app as! [String : AnyObject])
        //Download the image and Store it.
        Utilities.imageDownloadGroup.enter()
        Utilities.imageDownloadQueue.async(group: imageDownloadGroup, execute: {Utilities.downloadThumbNailImage(url: URL(string: appData.thumbNailPath!)!, appData: appData)})
        Utilities.imageDownloadGroup.enter()
        Utilities.imageDownloadQueue.async(group: imageDownloadGroup, execute: {Utilities.downloadAppIconImage(url: URL(string: appData.iconPath!)!, appData: appData)})
        // Price
        appData.priceWithCurrency = Utilities.fetchPriceFromEntry(app: app as! [String : AnyObject])
        // Publisher Link And Name
        appData.publisherLink = Utilities.fetchPublisherLinkFromEntry(app: app as! [String : AnyObject])
        appData.publisherName = Utilities.fetchPublisherNameFromEntry(app: app as! [String : AnyObject])
    }
    
    static func fetchEntries(jsonResult:NSDictionary) -> NSArray{
        let feed = jsonResult["feed"] as? NSDictionary
        let appEntries = feed!["entry"] as! NSArray
        return appEntries
    }
    
    static func fetchTitleFromEntry(app: [String:AnyObject])->String{
        let title = app["title"]?["label"] as? String
        return title!
    }
    
    static func fetchSummaryFromEntry(app: [String:AnyObject])->String{
        let summary = app["summary"]?["label"] as? String
        return summary!
    }
    
    static func fetchAppLinkFromEntry(app: [String:AnyObject])->String{
        let appLink = app["link"] as! [String:AnyObject]
        let link = appLink["attributes"]?["href"] as? String
        return link!
    }
    static func fetchReleaseDateFromEntry(app: [String:AnyObject])->String{
        let releaseDate = app["im:releaseDate"]?["label"] as? String
        //TODO: Release Date as MM/DD/YY Format
        let date = releaseDate?.split(separator: "T")[0]
        let columns = date?.split(separator: "-")
        let finalDateString = columns![1] + "/" + columns![2] + "/" + columns![0]
        return String(finalDateString)
    }
    
    static func fetchThumbNailLinkFromEntry(app: [String:AnyObject])->String{
        let iconPaths = app["im:image"] as? NSArray
        let thumbNail = iconPaths?[0] as? NSDictionary
        let thumbNailPath = thumbNail!["label"] as? String
        return thumbNailPath!
    }
    
    static func fetchAppICONFromEntry(app: [String:AnyObject])->String{
        let iconPaths = app["im:image"] as? NSArray
        let icons = iconPaths?[2] as? NSDictionary
        let iconPath = icons!["label"] as? String
        return iconPath!
    }
    
    static func fetchPriceFromEntry(app: [String:AnyObject])->String{
        let price = app["im:price"] as? [String:AnyObject]
        let val = price!["attributes"]?["amount"] as? String
        let cur = price!["attributes"]?["currency"] as? String
        let priceCurrency = val! + cur!
        return priceCurrency
    }
    
    static func fetchPublisherNameFromEntry(app: [String:AnyObject])->String{
       let publisher = app["im:artist"] as? [String:AnyObject]
        //TODO: Release Date as MM/DD/YY Format
        let publisherName = publisher!["label"] as? String
        return publisherName!
    }
    
    static func fetchPublisherLinkFromEntry(app: [String:AnyObject])->String{
        let publisher = app["im:artist"] as? [String:AnyObject]
        let publisherLink = publisher!["attributes"]?["href"] as? String
        return publisherLink!
    }
    
    // TODO: Remove This
    static func getDataFromUrl(url: URL,  index : Int, completion: @escaping (Data?, URLResponse?, Error?, Int?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error, index)
            }.resume()
    }
    
    static func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    static func downloadThumbNailImage(url: URL, appData : AppDataModel) {
        print("Download Started")
        Utilities.getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Thumbnail Image Finished for \(appData.title!)")
            let image = UIImage(data: data)!
            appData.thumbNailImage = image
            Utilities.imageDownloadGroup.leave()
        }
    }
    
    static func downloadAppIconImage(url: URL, appData : AppDataModel) {
        print("Download Started")
        Utilities.getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Icon Image Finished for \(appData.title!)")
            let image = UIImage(data: data)!
            appData.iconImage = image
            Utilities.imageDownloadGroup.leave()
        }
    }
}
