//
//  WeatherController.swift
//  WeatherDemo
//
//  Created by Mike Pollard on 23/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import UIKit
import CoreLocation

protocol WeatherControllerDelegte: class {
    func newWeatherData(weatherData: [WeatherDataPacket], updated: Date?)
}

class WeatherController {
    
    private let location = Location()
    private let weather = Weather()
    
    private var weatherData: WeatherData? {
        didSet {
            let data = self.getData()
            self.delegate?.newWeatherData(weatherData: data.0, updated: data.1)
        }
    }
    
    open weak var delegate: WeatherControllerDelegte?
    
    init() {
        self.location.delegate = self
        self.weather.set(key: "010bd3e27261365be1622798d170138e")
    }
    
    open func getCoords() -> CLLocationCoordinate2D? {
        return location.get()
    }
    
    open func getData() -> ([WeatherDataPacket],Date?) {
        guard let weatherData = self.weatherData else {
            self.location.useCache(true)
            return self.loadData()
        }
        let weatherDataFormatter = WeatherDataFormatter()
        
        var data: [WeatherDataPacket] = []
        if let weather = weatherData.weather.first, let main = weather.main {
            let weatherData = WeatherDataPacket(description: .main, data: main, icon: weather.icon)
            data.append(weatherData)
        }
        if let temp = weatherData.main.temp {
            let temperatureData = WeatherDataPacket(description: .temp, data: weatherDataFormatter.formatTemp(temp: temp))
            data.append(temperatureData)
        }
        if let speed = weatherData.wind.speed {
            let speedData = WeatherDataPacket(description: .speed, data: weatherDataFormatter.formatWindSpeed(speed: speed))
            data.append(speedData)
        }
        if let direction = weatherData.wind.deg {
            let directionData = WeatherDataPacket(description: .deg, data: weatherDataFormatter.formatWindDirection(deg: direction))
            data.append(directionData)
        }
        self.saveData(data: data)
        return (data, Date())
    }
    
    open func update() {
        guard let coords = location.get() else { self.weatherData = nil; return }
        self.weather.request(location: coords) { (data)  in
            if data == nil, let parent = self.delegate as? UIViewController {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Connection Error", message: "We were unable to connect to the weather service, please check your internet connection and try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                    parent.present(alert, animated: true, completion: nil)
                }
            }
            self.weatherData = data
        }
    }
    
    private func saveData(data: [WeatherDataPacket]) {
        if let encodedData: Data = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false) {
            UserDefaults.standard.set(encodedData, forKey: SavedData.Weather.rawValue)
        }
        self.location.cache()
        UserDefaults.standard.set(Date(), forKey: SavedData.Updated.rawValue)
    }
    
    private func loadData() -> ([WeatherDataPacket],Date?) {
        guard let loadedData = UserDefaults.standard.data(forKey: SavedData.Weather.rawValue) else { return ([],nil) }
        var data = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedData) as? [WeatherDataPacket]) ?? []
        
        let date = UserDefaults.standard.object(forKey: SavedData.Updated.rawValue) as? Date
        if let date = date, Date().timeIntervalSince(date) > 86400 {
            data = []
        }
        return (data, date)
    }
    
}

extension WeatherController: LocationDelegate {
    func didChange(coords: CLLocationCoordinate2D) {
        self.weather.request(location: coords) { (data) in
            self.weatherData = data
        }
    }
}

enum SavedData: String {
    case Weather
    case Updated
    case Latitude
    case Longitude
}
