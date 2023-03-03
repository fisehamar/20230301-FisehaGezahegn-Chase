//
//  LocationPermission.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import CoreLocation
import Foundation

/// Manages the location permission request and lifecycle. Use the publisher `coordinates` property
/// to automatically update any view that uses this class.
class LocationPermission: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    var locationManager: CLLocationManager!
    @Published var coordinates: (lat: Double, lon: Double)?
    
    // MARK: - Init
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    // MARK: - Methods
    
    /// Requests location permission if it doesn't have any yet.
    func requestPermission() {
        if locationManager.authorizationStatus != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func isPermissionGranted() -> Bool {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse: return true
        default: return false
        }
    }
    
    // MARK: - Protocol Methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse: locationManager?.requestLocation()
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = manager.location?.coordinate else { return }
        // Once these coordinates are assigned, it will notifiy all subscribers of `coordinates`.
        self.coordinates = (coordinates.latitude, coordinates.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // We are not currently worried about any location errors as it's not a must for the
        // app to work.
    }
}
