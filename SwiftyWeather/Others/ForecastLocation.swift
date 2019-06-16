//
//  LocationHelper.swift
//  SwiftyWeather
//
//  Created by lingzhao on 2019/6/15.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import CoreLocation

protocol ForecastLocationDelegate: class {
    //MARK: - Required method definition
    func locationDidDenied()
    func locationDidAuthorized()
    func locationDidFound(longitude: String, latitude: String)
    func locationDidGeocode(city: String, state: String)
}


class ForecastLocation: NSObject {
    // MARK: - Member variables
    var locationManager: CLLocationManager = CLLocationManager()
    weak var delegate: ForecastLocationDelegate? = nil
    var searchOK = true
    
    // MARK: - Overrides
    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Methods
    func startLocation() {
        if CLLocationManager.locationServicesEnabled() {
            searchOK = true
            locationManager.startUpdatingLocation()
        } else {
            if let dlgt = delegate {
                dlgt.locationDidDenied()
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate Implementation
extension ForecastLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let dlgt = delegate {
            if (status == .denied) {
                dlgt.locationDidDenied()
            } else if ((status == .authorizedAlways) || (status == .authorizedWhenInUse)) {
                dlgt.locationDidAuthorized()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (searchOK) {
            searchOK = false
            locationManager.stopUpdatingLocation()
            if let loc = manager.location {
                CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
                    if (error != nil) {
                        return
                    }
                    
                    if let plcMk = placemarks {
                        if (plcMk.count) > 0 {
                            let pm = plcMk[0] as CLPlacemark
                            self.delegate!.locationDidGeocode(city: pm.locality ?? "", state: pm.administrativeArea ?? "")
                        } else {
                            print("Problem with the data received from geocoder")
                        }
                    }
                })
            }
            
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as? CLLocation
            if let locObj = locationObj {
                let coord = locObj.coordinate
                let currentLoc: CLLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                if let dlgt = delegate {
                    dlgt.locationDidFound(longitude: "\(currentLoc.coordinate.longitude)", latitude: "\(currentLoc.coordinate.latitude)")
                }
            }
            
        }
    }

}
