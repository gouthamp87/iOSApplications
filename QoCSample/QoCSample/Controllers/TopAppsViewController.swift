//
//  TopAppsViewController.swift
//  QoCSample
//
//  Created by Goutham on 7/19/18.
//  Copyright © 2018 Citrix. All rights reserved.
//

import UIKit

class TopAppsViewController : UITableViewController, AppDataDelegate {
    
    @IBOutlet var appListView: UITableView!
    let appData = AppData()
    var refresh : UIRefreshControl = UIRefreshControl()
    var selectedItem :Int?
    override func viewDidLoad() {
        print("View Will Appear")
        // Try to get the apps
        fetchTopApps()
        super.viewDidLoad()
        // Add pull to refresh feature
        setUpPullToRefresh()
        // Configure the Table View.
        appListView.register(UINib(nibName: "AppList", bundle: nil), forCellReuseIdentifier: "AppList")
        configureTableView()
        // Set the delegate to Observe changes to Data
        appData.dataDelegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("View Will Appear")
    }

    // Pragma Mark - Table View Delegates to create Cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appData.appsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppList", for: indexPath) as! AppList
        let index = indexPath.row
        cell.appTitle.text = appData.appsList[index].title
        cell.appThumbNail.image = appData.appsList[index].thumbNailImage
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Delegates for Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedItem = indexPath.row
        displayAppDetails();
    }
    
    @objc func fetchTopApps() {
        if (self.refresh.isRefreshing)
        {
            self.refresh.endRefreshing()
        }
        appData.getAppsData()
    }
    
    //Configure the refresh feature here
    func setUpPullToRefresh(){
        refresh.backgroundColor = UIColor.clear
        refresh.tintColor = UIColor.black
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(fetchTopApps), for: .valueChanged)
        self.tableView.addSubview(refresh)
    }
    
    func configureTableView() {
        appListView.rowHeight = 64
        appListView.estimatedRowHeight = 120
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
        destVC.appDetails = appData.appsList[selectedItem!]
    }
    
    // Delegate to Implement the AppData Changes
    func DataChanged(appList: [AppDataModel]) {
        reloadTableView()
    }
   
    
}

