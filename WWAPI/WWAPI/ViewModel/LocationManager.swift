//
//  LocationManager.swift
//  WWAPI
//
//  Created by Sara Sd on 03/02/1445 AH.
//

import Foundation
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var userLocation: CLLocation?
    @Published var isAuthorized: Bool = false
    @Published var isShowingAlert: Bool = false
    @Published var region: MKCoordinateRegion = .init(center: CLLocationCoordinate2D(latitude: 25.869619,
                                                                                     longitude: 43.498501),
                                                      span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        print("DEBUG: status \(status)")
        switch status {
        case .notDetermined:
            isAuthorized = false
            return "notDetermined"
        case .authorizedWhenInUse:
            if let userLocation{
                region = MKCoordinateRegion(center: userLocation.coordinate,
                                            span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
            return "authorizedWhenInUse"
        case .authorizedAlways:
            if let userLocation{
                region = MKCoordinateRegion(center: userLocation.coordinate,
                                            span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
            self.isAuthorized = true
            return "authorizedAlways"
        case .restricted:
            isAuthorized = false
            return "restricted"
        case .denied:
            isAuthorized = false
            return "denied"
        default:
            return "unknown"
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.startUpdatingLocation()
        guard let location = locations.last else { return }
        userLocation = location
        
        if let userLocation {
            region.center = userLocation.coordinate
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: error while getting location")
    }
}
