//
//  ViewController.swift
//  Stormy
//
//  Created by Johnny Romano on 9/30/15.
//  Copyright © 2015 Johnny Romano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentHumidityLabel: UILabel?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentWeatherSummary: UILabel?
    @IBOutlet weak var refreshButton: UIButton?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    fileprivate let forecastAPIKey = "112d613d610a4b7bdfb45f83c660b957"
    let coordinate: (lat: Double, long: Double) = (41.923143,-87.711846)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        retrieveWeatherForecast()
        
        /*
        // Build Network API URL
        // https ://api.forecast.io/forecast/APIKEY/LATITUDE,LONGITUDE
        // ...set base...
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
        // ...hardcode lat+long.
        let forecastURL = NSURL(string: "41.923143,-87.711846", relativeToURL: baseURL)
        
        // Use NSURLSession API to fetch data
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        // ...Return directly to memory...
        // NSURLRequest object, unwrapped incase it doesn't exist
        let request = NSURLRequest(URL: forecastURL!)
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            print(data)
        })

        dataTask.resume()
        
        // Load current weather plist with optional binding so it doesn't crash
        // ...can we load the plist...
        if let plistPath = NSBundle.mainBundle().pathForResource("CurrentWeather", ofType: "plist"),
            
            // ...can the plist be converted to an NSDictionary...
            let weatherDictionary = NSDictionary(contentsOfFile: plistPath),
        
            // ...does the dictionary actually contain information using the key currently...
            let currentWeatherDictionary = weatherDictionary["currently"] as? [String: AnyObject]{
            
            // ...then load plist
            let currentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
            
            // Display the data from the plist
            // ...for temperature...
            currentTemperatureLabel?.text = "\(currentWeather.temperature)º"
            
            // ...for humidity...
            currentHumidityLabel?.text = "\(currentWeather.humidity)%"
        
            // ...for precipitation.
            currentPrecipitationLabel?.text = "\(currentWeather.precipProbability)%"
        }
        */
    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func retrieveWeatherForecast () {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getForecast(coordinate.lat, long: coordinate.long) {
            (currently) in
            
            if let currentWeather = currently {
                
                DispatchQueue.main.async {
                    // Execute trailing closure
                    if let temperture = currentWeather.temperature {
                        self.currentTemperatureLabel?.text = "\(temperture)º"
                    }
                    if let humidity = currentWeather.humidity {
                        self.currentHumidityLabel?.text = "\(humidity)%"
                    }
                    if let precipitation = currentWeather.precipProbability {
                        self.currentPrecipitationLabel?.text = "\(precipitation)%"
                    }
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    if let sumary = currentWeather.summary {
                        self.currentWeatherSummary?.text = sumary
                    }
                    
                    self.toggleRefreshAnimation(false)
                    
                }
            }
        }
    }
    
    @IBAction func refreshWeather() {
        toggleRefreshAnimation(true)
        retrieveWeatherForecast()
    }
    
    func toggleRefreshAnimation(_ on: Bool) {
        refreshButton?.isHidden = on
        if on {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }

}

