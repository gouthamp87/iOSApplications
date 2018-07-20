//
//  AppList.Swift
//  iStoreApp
//
//  This is the model class that represents the cell for a application

import UIKit
class AppList : UITableViewCell {
    //This would hold the Application Title
    
    @IBOutlet var appThumbNail: UIImageView!
    
    @IBOutlet var appTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    }
}
