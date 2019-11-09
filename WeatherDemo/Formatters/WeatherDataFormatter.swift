//
//  WeatherDataFormatter.swift
//  WeatherDemo
//
//  Created by Mike Pollard on 26/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import Foundation

class WeatherDataFormatter {
    
    private let fullCompass: Double = 360.0
    private let directions: [Int : String] = [
        0 : "North",
        1 : "North East",
        2 : "East",
        3 : "South East",
        4 : "South",
        5 : "South West",
        6 : "West",
        7 : "North West"
    ]
    
    open func formatTemp(temp: Double) -> String {
        let temp = Int(temp.rounded())
        return "\(temp)°C"
    }
    
    open func formatWindSpeed(speed: Double) -> String {
        let speed = Int(speed.rounded())
        return "\(speed)mph"
    }
    
    open func formatWindDirection(deg: Double) -> String {
        var deg = deg + (fullCompass / Double(directions.count) / 2.0)
        if deg >= self.fullCompass { deg -= self.fullCompass }
        
        let quad = Int(deg / (fullCompass / Double(directions.count)))
        return directions[quad] ?? "Unknown"
    }
    
    open func getDirection(direction: Int) -> String {
        return self.directions[direction] ?? "Out of Range"
    }
}

