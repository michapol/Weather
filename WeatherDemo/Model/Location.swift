//
//  Location.swift
//  WeatherDemo
//
//  Created by Mike Pollard on 23/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationDelegate: class {
    func didChange(coords: CLLocationCoordinate2D)
}

class Location: NSObject {
    
    private let locationManager = CLLocationManager()
    private var currentCoords: CLLocationCoordinate2D? {
        didSet {
            guard let currentCoords = currentCoords else { return }
            delegate?.didChange(coords: currentCoords)
        }
    }
    private var locationCache: CLLocationCoordinate2D?
    
    open weak var delegate: LocationDelegate?
    
    override init() {
        super.init()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            self.locationManager.startUpdatingLocation()
        }
    }
    
    open func get() -> CLLocationCoordinate2D? {
        return locationCache ?? currentCoords
    }
    
    open func update() {
        self.locationManager.requestLocation()
    }
    
    open func cache() {
        guard let currentCoords = self.currentCoords else { return }
        self.locationCache = nil
        UserDefaults.standard.set(currentCoords.latitude, forKey: SavedData.Latitude.rawValue)
        UserDefaults.standard.set(currentCoords.longitude, forKey: SavedData.Longitude.rawValue)
    }
    
    open func useCache(_ useCache: Bool) {
        if useCache {
            if
                self.locationCache == nil,
                let lat = UserDefaults.standard.object(forKey: SavedData.Latitude.rawValue) as? Double,
                let long = UserDefaults.standard.object(forKey: SavedData.Longitude.rawValue) as? Double
            {
                self.locationCache = CLLocationCoordinate2D(latitude: lat, longitude: long)
            }
        } else {
            self.locationCache = nil
        }
    }
    
}

extension Location: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinates = locations.first?.coordinate {
            self.currentCoords = coordinates
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let controller = delegate as? WeatherController, let viewController = controller.delegate as? WeatherDisplayController {
            DispatchQueue.main.async {
                let alertView = UIAlertController(title: "Location Error", message: error.localizedDescription, preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                viewController.present(alertView, animated: true, completion: nil)
            }
        }
    }
}
