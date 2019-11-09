//
//  Weather.swift
//  WeatherDemo
//
//  Created by Mike Pollard on 24/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import Foundation
import CoreLocation

class Weather {
    
    typealias WeatherCompetion = (WeatherData?)->()
    
    private let weatherApiUrl = "https://api.openweathermap.org/data/2.5/weather?"
    private var weatherApiKey = ""
    
    open func set(key: String) {
        self.weatherApiKey = key
    }
    
    open func request(location: CLLocationCoordinate2D, completion: @escaping WeatherCompetion) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: sessionConfig)
        
        let request = "\(weatherApiUrl)lat=\(location.latitude)&lon=\(location.longitude)&appid=\(self.weatherApiKey)&units=metric"
        guard let url = URL(string: request) else { return }
        
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let weatherResult = try? JSONDecoder().decode(WeatherData.self, from: data)
                completion(weatherResult)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
