//
//  ViewController.swift
//  magic8Ball
//
//  Created by Goutham on 6/12/18.
//  Copyright © 2018 Citrix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var magicBall: UIImageView!
    @IBAction func askClicked(_ sender: UIButton) {
        generateBall();
    }
    let imagePrefix = "ball";
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        generateBall();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateBall() {
        let index = arc4random_uniform(5);
        let ballNo = "\(imagePrefix)" + "\(index+1)";
        NSLog("The ball selected is %@", ballNo);
        magicBall.image = UIImage(named: ballNo);
    }
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        generateBall();
    }


}

