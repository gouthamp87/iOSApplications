//
//  ViewController.swift
//  diceApp
//
//  Created by Goutham on 6/11/18.
//  Copyright © 2018 Citrix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var diceIndex1  : Int   = 0;
    var diceIndex2  : Int   = 0;
    
    

    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
 
    
    @IBAction func rollDice(_ sender: UIButton) {
        getDice();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getDice();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getDice(){
        diceIndex1 = Int(arc4random_uniform(6)+1);

        diceIndex2 = Int(arc4random_uniform(6)+1);
        NSLog("\nValue of Dice1 is %d\nValue of Dice2 is %d", diceIndex1, diceIndex2);
        var diceName = "dice" + String(diceIndex1);
        diceImageView1.image = UIImage(named: diceName);
        diceName = "dice" + String(diceIndex2);
        diceImageView2.image = UIImage(named: diceName);
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        getDice();
    }
}

