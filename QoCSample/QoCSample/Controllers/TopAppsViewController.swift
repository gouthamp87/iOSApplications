//
//  TopAppsViewController.swift
//  QoCSample
//
//  Created by Goutham on 7/19/18.
//  Copyright © 2018 Citrix. All rights reserved.
//

import UIKit

class TopAppsViewController : UITableViewController {

    var appsList : [AppDataModel] = [AppDataModel]()
    
    @IBOutlet var appListView: UITableView!
    
//    dispatch_queue_t myCustomQueue;
//    myCustomQueue = dispatch_queue_create("com.citrixiOSblr.QoCSampleImages", NULL);
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        appListView.register(UINib(nibName: "AppList", bundle: nil), forCellReuseIdentifier: "AppList")
        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTopApps()
    }

    // Pragma Mark - Table View Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppList", for: indexPath) as! AppList
        cell.appTitle.text = appsList[indexPath.row].title
        cell.appThumbNail.image = appsList[indexPath.row].thumbNailImage
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    func fetchTopApps() {
        let path = "http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=100/json"
        let urlPath = URL.init(string: path)
        var request = URLRequest.init(url: urlPath!)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200{
                guard let data = data else {
                    print("request failed \(String(describing: error))")
                    return
                }
                self.parseJSONData(jsonData: data)
            }
        }
        task.resume()
    }
    
    func parseJSONData(jsonData:Any) -> Void {
        //Parse and load the View
        
        // TODO: Use guard let to be more robust.
        let jsonResult = Utilities.parseResponse(jsonData: jsonData)
        let appEntries = Utilities.fetchEntries(jsonResult: jsonResult)
        var index = 0
        for app in appEntries {
            let appData = AppDataModel()
            // Fetch Title
            appData.title = Utilities.fetchTitleFromEntry(app: app as! [String : AnyObject])
            // Summary
            appData.summary = Utilities.fetchSummaryFromEntry(app: app as! [String : AnyObject])
            // Link
            appData.appLink = Utilities.fetchAppLinkFromEntry(app: app as! [String : AnyObject])
            //TODO: Release Data as MM/DD/YY
            appData.releaseDate = Utilities.fetchReleaseDateFromEntry(app: app as! [String : AnyObject])
            // ICON Paths
            appData.thumbNailPath = Utilities.fetchThumbNailLinkFromEntry(app: app as! [String : AnyObject])
            //         thumbNail = iconPaths![2] as? NSDictionary
            //Download the image and Store it.
//            dispatch_async(myCustomQueue, ^{
                downloadImage(url: URL(string: appData.thumbNailPath!)!, index: index)
//            });
            
            appData.iconPath = Utilities.fetchAppICONFromEntry(app: app as! [String : AnyObject])
            // Price
            appData.priceWithCurrency = Utilities.fetchPriceFromEntry(app: app as! [String : AnyObject])
            // Publisher Link And Name
            appData.publisherLink = Utilities.fetchPublisherLinkFromEntry(app: app as! [String : AnyObject])
            appData.publisherName = Utilities.fetchPublisherNameFromEntry(app: app as! [String : AnyObject])
            self.appsList.append(appData)
            index = index + 1
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    func configureTableView() {
        appListView.rowHeight = 57
        appListView.estimatedRowHeight = 120
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    func downloadImage(url: URL, index : Int) {

        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            let image = UIImage(data: data)!
            self.appsList[index].thumbNailImage = image
        }
    }
    

}

