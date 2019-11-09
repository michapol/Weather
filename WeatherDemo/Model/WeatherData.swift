//
//  WeatherData.swift
//  WeatherDemo
//
//  Created by Mike Pollard on 24/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import Foundation

class WeatherData: Codable {
    var weather: [OWM_Weather]
    var main: OWM_Main
    var wind: OWM_Wind
}

class OWM_Weather: Codable {
    var main: String?
    var icon: String?
}

class OWM_Main: Codable {
    var temp: Double?
}

class OWM_Wind: Codable {
    var speed: Double?
    var deg: Double?
}
