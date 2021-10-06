//
//  LocationBroadcaster.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/6/21.
//

import Foundation
import UIKit
import GoogleMaps
import Firebase

class LocationBroadcaster : NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationBroadcaster()
    
    let locationManager = CLLocationManager()
    let databaseRef = Database.database().reference()

    var locationServicesEnabled : Bool = false
    
    func runBroadcaster() {
        
        self.checkForLocationPermissions { enabled in
            
            if !enabled {
                print("no location services available")
            } else {
              
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        if locations.count != 0 {
            
            guard let location = locations.last else {return}
            
            //MARK: - ALTITUDE
            let altitudeInMeters = abs(location.altitude)
            let altitudeInFeet = abs(location.altitude * 3.28084)
            
            //MARK: - COORDINATES
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            //MARK: - SPEED
            let rawSpeed = abs(location.speed)
            let speedToMPH = (rawSpeed * 2.23694)
            let speedToKPH = (rawSpeed * 3.6)
            
            //MARK: - UPDATE DATABASE FOR THE HEAT MAP
            guard let user_uid = Auth.auth().currentUser?.uid else {return}

            let ref = self.databaseRef.child("client_groomer_location_broadcaster").child(user_uid)
            
            let user_first_name = userProfileStruct.user_first_name ?? "no first name"
            let user_last_name = userProfileStruct.user_last_name ?? "no last name"
            let users_firebase_uid = userProfileStruct.users_firebase_uid ?? "no UID"
            let users_ref_key = ref.key ?? "no key"
         
            let values : [String : Any] = ["raw_speed" : rawSpeed, "speed_mph" :  speedToMPH, "speed_kph" : speedToKPH,
                                           "longitude" : longitude, "latitude" : latitude, "altitude_feet" : altitudeInFeet,
                                           "altitude_meters" : altitudeInMeters,
                                           "user_first_name" : user_first_name,
                                           "user_last_name" : user_last_name,
                                           "users_firebase_uid" : users_firebase_uid,
                                           "users_ref_key" : users_ref_key, "is_groomer" : false]
           
            ref.updateChildValues(values)
           
        }
    }
    
    func checkForLocationPermissions(completion : @escaping (_ hasLocationServicesEnabled : Bool)->()) {
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch self.locationManager.authorizationStatus {
            
            case .authorizedAlways, .authorizedWhenInUse: completion(true)
                self.locationServicesEnabled = true
            case .notDetermined, .restricted :
                self.locationManager.requestWhenInUseAuthorization()
            case .denied: completion(false)
                self.locationServicesEnabled = false
            default : completion(false)
            }
            
        } else {
            self.locationServicesEnabled = false
            completion(false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
        
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationServicesEnabled = true
            self.runBroadcaster()
        case .notDetermined, .restricted:
            self.locationServicesEnabled = false
        default:
            self.locationServicesEnabled = false
        }
    }
}
