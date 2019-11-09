//
//  WeatherDataPacket.swift
//  WeatherDemo
//
//  Created by Mike Pollard on 26/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import Foundation

class WeatherDataPacket: NSObject, NSCoding {
    
    var title: WeatherDescription = .main
    var data: String = ""
    var icon: String?
    
    init(description: WeatherDescription, data: String, icon: String? = nil) {
        self.title = description
        self.data = data
        self.icon = icon
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        var description: WeatherDescription = .main
        if let codedDesc = aDecoder.decodeObject(forKey: "description") as? String, let enumDesc = WeatherDescription(rawValue: codedDesc) {
            description = enumDesc
        }
        let data = aDecoder.decodeObject(forKey: "data") as? String ?? ""
        let icon = aDecoder.decodeObject(forKey: "icon") as? String
        self.init(description: description, data: data, icon: icon)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title.rawValue, forKey: "description")
        aCoder.encode(data, forKey: "data")
        aCoder.encode(icon, forKey: "icon")
    }

}

enum WeatherDescription: String {
    case main = "Conditions:"
    case temp = "Temperature:"
    case speed = "Wind Speed:"
    case deg = "Wind Direction:"
}
