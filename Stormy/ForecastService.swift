//
//  ForecastService.swift
//  Stormy
//
//  Created by Johnny Romano on 10/4/15.
//  Copyright © 2015 Johnny Romano. All rights reserved.
//

import Foundation

struct ForecastService {
    
    let forecastAPIKey: String
    let forecastBaseURL: URL?
    
    
    init(APIKey: String){
        forecastAPIKey = APIKey
        forecastBaseURL = URL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
        
    }
    
    func getForecast(_ lat: Double, long: Double, completion: @escaping ((CurrentWeather?)->Void)){
        if let forecastURL = URL(string: "\(lat),\(long)", relativeTo: forecastBaseURL){
            
            let networkOperation = NetworkOperation(url: forecastURL)
            
            networkOperation.downloadJSONFromURL{
                (JSONDictionary) in
                let currentWeather = self.currentWeatherFromJSON(JSONDictionary)
                completion(currentWeather)
            }
            
            
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func currentWeatherFromJSON(_ jsonDictionary: [String: AnyObject]?) ->
        CurrentWeather? {
        if let currentWeatherDictionary = jsonDictionary?["currently"] as? [String: AnyObject]{
            return CurrentWeather(weatherDictionary: currentWeatherDictionary)
        } else {
            print("JSON dictionary returned nil for 'currently' key")
            return nil
        }
    }
}
