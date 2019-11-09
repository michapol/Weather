//
//  WeatherDemoTests.swift
//  WeatherDemoTests
//
//  Created by Mike Pollard on 23/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import XCTest
@testable import WeatherDemo

import CoreLocation

class WeatherDemoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWindDirectionFormatter() {
        let weatherFormatter = WeatherDataFormatter()
        
        for degree in stride(from: 0, to: 360, by: 45) {
            let direction = weatherFormatter.formatWindDirection(deg: Double(degree))
            XCTAssert(direction == weatherFormatter.getDirection(direction: degree/45))
        }
    }
    
    func testLocationcache() {
        let location = Location()
        
        let testLat = 10.0
        let testLong = 10.0
        
        UserDefaults.standard.set(10.0, forKey: SavedData.Latitude.rawValue)
        UserDefaults.standard.set(10.0, forKey: SavedData.Longitude.rawValue)

        location.useCache(true)
        let coords = location.get()
        
        XCTAssert(coords?.latitude == testLat)
        XCTAssert(coords?.longitude == testLong)
    }
    
    func testWeatherApiWithoutKey() {
        let testCoords = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let weather = Weather()
        weather.request(location: testCoords) { (data) in
            XCTAssertNil(data)
        }
    }
    
    func testWeatherApiWithKey() {
        let testCoords = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let weather = Weather()
        weather.set(key: "010bd3e27261365be1622798d170138e")
        weather.request(location: testCoords) { (data) in
            XCTAssertNotNil(data)
        }
    }
    
    func testWeatherDataPacketArchivable() {
        let weatherDataPacket = WeatherDataPacket(description: .main, data: "Clouds", icon: "09d")
        let encodedData: Data? = try? NSKeyedArchiver.archivedData(withRootObject: weatherDataPacket, requiringSecureCoding: false)
        XCTAssertNotNil(encodedData)
    }
    
    func testWeatherTemperatureFormatter() {
        let testTemp: Double = 4.2
        let expectedResult = "4°C"
        
        let weatherFormatter = WeatherDataFormatter()
        let formattedTemp = weatherFormatter.formatTemp(temp: testTemp)
        
        XCTAssert(formattedTemp == expectedResult)
    }
    
    func testLocationFormatter() {
        let testCoords = CLLocationCoordinate2D(latitude: 12.3456789, longitude: 0.12)
        let expectedLatitude = "Latitude: 12.34568"
        let expectedLongitude = "Longitude: 0.12000"
        
        
        let locationFormatter = LocationFormatter()
        let formattedCoords = locationFormatter.formatCoords(coords: testCoords)
        
        XCTAssert(formattedCoords.0 == expectedLatitude)
        XCTAssert(formattedCoords.1 == expectedLongitude)
    }
}
