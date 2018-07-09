//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Goutham on 08/24/17.
//  Copyright © 2018 Goth iOS Apps. All rights reserved.
//

import UIKit


protocol ChangeCityDelegate {
    func userEnteredCity(city : String)
}


class ChangeCityViewController: UIViewController {
    
    var delegate : ChangeCityDelegate?

    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        let cityName = changeCityTextField.text!
        delegate?.userEnteredCity(city: cityName)
        
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
