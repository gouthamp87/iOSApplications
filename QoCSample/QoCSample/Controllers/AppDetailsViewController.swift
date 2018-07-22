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

    // Upon Back Dismiss the current ViewController.
    @IBAction func dismissSelf(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet var appIcon: UIImageView!
    @IBOutlet var dateOfRelease: UILabel!
    @IBOutlet var nameOfPublisher: UILabel!
    @IBOutlet var linkOfPublisher: UITextView!
    @IBOutlet var priceOfApp: UILabel!
    @IBOutlet var summaryOfApp: UITextView!
    
    @IBOutlet var linkToApp: UITextView!
    var appDetails : AppDataModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // The Segue send would have filled up the appDetails.
        // Just populate them and we are good to present.
        navigationBar.topItem?.title = appDetails?.title
        appIcon.image = appDetails?.iconImage
        dateOfRelease.text = appDetails?.releaseDate
        nameOfPublisher.text = appDetails?.publisherName
        linkOfPublisher.text = appDetails?.publisherLink
        priceOfApp.text = appDetails?.priceWithCurrency
        linkToApp.text = appDetails?.appLink
        summaryOfApp.text = appDetails?.summary
        summaryOfApp.isEditable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
