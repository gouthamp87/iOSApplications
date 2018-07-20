//
//  Utilities.swift
//  QoCSample
//
//  Created by Goutham on 7/19/18.
//  Copyright © 2018 Citrix. All rights reserved.
//

import Foundation

class Utilities{
    
    static func parseResponse(jsonData:Any) -> NSDictionary {
        var jsonResult: NSDictionary?
        
        do{
            jsonResult = (try JSONSerialization.jsonObject(with: jsonData as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary)!
        } catch{
            jsonResult = ["Error":error]
        }
        return jsonResult!
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
        return releaseDate!
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
}
