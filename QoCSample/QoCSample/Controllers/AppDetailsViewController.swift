//
//  AppDetailsViewController.swift
//  QoCSample
//
//  Created by Goutham on 7/20/18.
//  Copyright © 2018 Citrix. All rights reserved.
//

import UIKit

class AppDetailsViewController: UIViewController {

    @IBOutlet var navigationBar: UINavigationBar!

    @IBOutlet var appIcon: UIImageView!
    @IBOutlet var dateOfRelease: UILabel!
    @IBOutlet var nameOfPublisher: UILabel!
    @IBOutlet var linkOfPublisher: UILabel!
    @IBOutlet var priceOfApp: UILabel!
    @IBOutlet var linkToApp: UILabel!
    @IBOutlet var summaryOfApp: UITextView!
    
    var appDetails : AppDataModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.topItem?.title = appDetails?.title
        appIcon.image = appDetails?.iconImage
        dateOfRelease.text = appDetails?.releaseDate
        nameOfPublisher.text = appDetails?.publisherName
        linkOfPublisher.text = appDetails?.publisherLink
        linkOfPublisher.sizeToFit()
        priceOfApp.text = appDetails?.priceWithCurrency
        linkToApp.text = appDetails?.appLink
        linkToApp.sizeToFit()
        summaryOfApp.text = appDetails?.summary
        summaryOfApp.isEditable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
