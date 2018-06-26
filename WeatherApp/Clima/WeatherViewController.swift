//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {

    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "0416cc923da4a03d0dd18ffde89c073e"
    let weatherDataModel = WeatherDataModel()

    //TODO: Declare instance variables here
    var locationManager: CLLocationManager! /*{
        didSet{
            locationManager.delegate = self
        }
    }*/
    

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        //Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        //start location updates
//        locationManager.startUpdatingLocation()
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getWeatherData(url : String, params : [String:String]) {
        Alamofire.request(url, method: .get, parameters: params).responseJSON{
            response in
            if response.result.isSuccess{
                print("WEathare data Available")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else
            {
                print("\(response.result.error)")
                self.cityLabel.text = "Networking issues"
            }
        }
    }
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    func updateWeatherData(json : JSON) {
        let temp = json["main"]["temp"].double
        weatherDataModel.temperature = Int(temp! - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        self.updateUIWithWeatherData()
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got a location update")
        let location = locations[locations.count - 1]
        if(location.horizontalAccuracy > 0){
            locationManager.stopUpdatingLocation()
//            locationManager.delegate = nil
            print("Longitude Location : \(location.coordinate.longitude), Latitude Location : \(location.coordinate.longitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String:String] = ["lat":latitude, "lon":longitude, "appid": APP_ID]
            getWeatherData(url: WEATHER_URL, params: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        default:
            print("Could not Get location")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "LOCATION NOT FOUND.."
    }
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    func userEnteredCity(city: String) {
        let params : [String:String] = ["q":city, "appid":APP_ID]
        getWeatherData(url: WEATHER_URL, params: params)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destVC = segue.destination as! ChangeCityViewController
            destVC.delegate = self
        }
    }
    
    
    
    
    
}


