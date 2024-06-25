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
    private var locationUpdated: ((CLLocation?, NSError?) -> Void)?
    
    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation(with locationUpdated: @escaping(CLLocation?, NSError?) -> Void) {
        locationManager.requestLocation()
        print("Starting Location Updates")
        self.locationUpdated = locationUpdated
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
        print("Check didUpdateLocations")
        
        guard let location = locations.first else { return }
        locationUpdated?(location, nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error 13")
        print(error)
        print(error.localizedDescription)
        
        locationUpdated?(nil, error as NSError)
    }
}
