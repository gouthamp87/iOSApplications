//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Goutham on 6/29/18.
//  Copyright © 2018 Goth iOS Apps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencyConverterBaseURL = "http://data.fixer.io/api/"
    let currencyConverterAPIID = "d78dd41bff10b7bc8213b649be3c989d"
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
 

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
//        print(finalURL)
        getBitCoinPrice(url: finalURL, parameters: ["":""])
        
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitCoinPrice(url: String, parameters: [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Price data")
                    let priceJSON : JSON = JSON(response.result.value!)
                    print(priceJSON)
                    self.updatePriceData(json: priceJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
//    
//    func <#name#>(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }

    
    
    

    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updatePriceData(json : JSON) {

        if let tempResult = json["last"].double {
            print(json["last"].stringValue)
            self.bitcoinPriceLabel.text = json["last"].stringValue
//            weatherData.city = json["name"].stringValue
//            weatherData.condition = json["weather"][0]["id"].intValue
//            weatherData.weatherIconName =    weatherData.updateWeatherIcon(condition: weatherData.condition)
        }

//        updateUIWithWeatherData()
    }
//




}

