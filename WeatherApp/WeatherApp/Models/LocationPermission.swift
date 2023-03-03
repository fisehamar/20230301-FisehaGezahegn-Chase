//
//  LocationPermission.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import CoreLocation
import Foundation

/// Manages the location permission request and lifecycle.
class LocationPermission: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    private var locationManager: CLLocationManager?
    @Published var coordinates: (lat: Double, lon: Double) = (0, 0)
    
    // MARK: - Init
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
    
    // MARK: - Methods
    
    /// Requests location permission if it doesn't have any yet.
    func requestPermission() {
        if locationManager?.authorizationStatus != .authorizedWhenInUse {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - Protocol Methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager?.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = manager.location?.coordinate else { return }
        self.coordinates = (coordinates.latitude, coordinates.longitude)
    }
}
