//
//  LocationFormatter.swift
//  WeatherDemo
//
//  Created by Mike Pollard on 26/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import Foundation
import CoreLocation

class LocationFormatter {
    
    open func formatCoords(coords: CLLocationCoordinate2D?) -> (String?,String?) {
        guard let coords = coords else { return (nil,nil) }
        
        var latitude: String = "Latitude: "
        latitude += String(format: "%.5f", coords.latitude)
        var longitude: String = "Longitude: "
        longitude += String(format: "%.5f", coords.longitude)

        return (latitude,longitude)
    }
    
    open func formatDate(date: Date?) -> String {
        guard let date = date else { return "Unknown update date" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        let formattedDate = dateFormatter.string(from: date)
        
        return "Last Updated: \(formattedDate)"
    }
}
