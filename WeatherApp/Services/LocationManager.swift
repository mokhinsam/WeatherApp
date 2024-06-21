//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Дарина Самохина on 20.06.2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var didUpdateLocations: (([CLLocation]) -> Void)?
    
    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation(with didUpdateLocations: @escaping(([CLLocation]) -> Void)) {
        print("Starting Location Updates")
        locationManager.requestLocation()
        self.didUpdateLocations = didUpdateLocations
    }
    
    func getCoordinate(from addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard error == nil else {
                completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
                return
            }
            guard let placemarks = placemarks else { return }
            guard let placemark = placemarks.first else { return }
            guard let location = placemark.location else { return }
            completionHandler(location.coordinate, nil)
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        didUpdateLocations?(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error 13")
        print(error)
        print(error.localizedDescription)
    }
}
