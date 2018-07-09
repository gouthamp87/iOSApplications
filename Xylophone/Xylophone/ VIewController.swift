//
//  ViewController.swift
//  Xylophone
//
//  Created by Goutham on 5/29/18.
//  Copyright © 2018 Goth iOS Apps. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController{
    
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }



    @IBAction func notePressed(_ sender: UIButton) {
        playSound(index: sender.tag)
    }
    
    func playSound(index: Int) {
//        print(index);
        let url = Bundle.main.url(forResource: "note" + "\(index)", withExtension: "wav")!
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                guard let player = player else {
                    return
                }
                player.prepareToPlay();
                player.play()
                
            } catch {
                print(error )
            }
    }
}



