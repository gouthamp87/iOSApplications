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
    var refresh : UIRefreshControl = UIRefreshControl()
    var selectedItem : Int?
    @IBOutlet var appListView: UITableView!

//    dispatch_queue_t myCustomQueue;
//    myCustomQueue = dispatch_queue_create("com.citrixiOSblr.QoCSampleImages", NULL);
    let imageDownloadQueue = DispatchQueue(label: "com.citrixiOSblr.QoCSampleImages")
    let imageDownloadGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add pull to refresh feature
        refresh.backgroundColor = UIColor.clear
        refresh.tintColor = UIColor.black
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(fetchTopApps), for: .valueChanged)
        self.tableView.addSubview(refresh)
        appListView.register(UINib(nibName: "AppList", bundle: nil), forCellReuseIdentifier: "AppList")
        // Configure the Table View.
        configureTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTopApps()
    }

    // Pragma Mark - Table View Delegates to create Cells
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
    
    // Delegates for Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        displayAppDetails();
    }
    
    
    @objc func fetchTopApps() {
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
        if (self.refresh.isRefreshing)
        {
            self.refresh.endRefreshing()
        }
    }
    
    func parseJSONData(jsonData:Any) -> Void {
        //Parse and load the View
        
        // TODO: Use guard let to be more robust.
        let jsonResult = Utilities.parseResponse(jsonData: jsonData)
        let appEntries = Utilities.fetchEntries(jsonResult: jsonResult)
        for (index,app) in appEntries.enumerated() {
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
            imageDownloadGroup.enter()
            imageDownloadQueue.async(group: imageDownloadGroup, execute: {self.downloadThumbNailImage(url: URL(string: appData.thumbNailPath!)!, index: index)})
            
            appData.iconPath = Utilities.fetchAppICONFromEntry(app: app as! [String : AnyObject])
            imageDownloadGroup.enter()
            imageDownloadQueue.async(group: imageDownloadGroup, execute: {self.downloadAppIconImage(url: URL(string: appData.iconPath!)!, index: index)})
            // Price
            appData.priceWithCurrency = Utilities.fetchPriceFromEntry(app: app as! [String : AnyObject])
            // Publisher Link And Name
            appData.publisherLink = Utilities.fetchPublisherLinkFromEntry(app: app as! [String : AnyObject])
            appData.publisherName = Utilities.fetchPublisherNameFromEntry(app: app as! [String : AnyObject])
            self.appsList.append(appData)
        }
//        imageDownloadGroup.notify(queue: DispatchQueue.main, work: {self.reloadTableView()})
        imageDownloadGroup.notify(queue: DispatchQueue.main, execute: {
            print("Finished Downloading All Images")
            self.reloadTableView()})
        
    }

    func configureTableView() {
        appListView.rowHeight = 64
        appListView.estimatedRowHeight = 120
    }
    
    func getDataFromUrl(url: URL,  index : Int, completion: @escaping (Data?, URLResponse?, Error?, Int?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error, index)
        }.resume()
    }
    
    func downloadThumbNailImage(url: URL, index : Int) {
        print("Download Started")
        getDataFromUrl(url: url, index : index) { data, response, error, index in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download AppThumbNail Finished for \(index!)")
            let image = UIImage(data: data)!
            self.appsList[index!].thumbNailImage = image
            self.imageDownloadGroup.leave()
        }
    }
    
    func downloadAppIconImage(url: URL, index : Int) {
        print("Download Started")
        getDataFromUrl(url: url, index : index) { data, response, error, index in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download AppICON Finished for \(index!)")
            let image = UIImage(data: data)!
            self.appsList[index!].iconImage = image
            self.imageDownloadGroup.leave()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func displayAppDetails()  {
        performSegue(withIdentifier: "appDetails", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : AppDetailsViewController = segue.destination as! AppDetailsViewController
        destVC.appDetails = appsList[selectedItem!]
    }
   
    
}

