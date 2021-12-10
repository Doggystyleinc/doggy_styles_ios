//
//  TruckTrackerModel.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 12/10/21.
//

struct TruckTrackerModel {
    
    var raw_speed : Double?,
        speed_mph : Double?,
        speed_kph : Double?,
        longitude : Double?,
        latitude : Double?,
        altitude_feet : Double?,
        user_first_name : String?,
        user_last_name : String?,
        users_firebase_uid : String?,
        users_ref_key : String?,
        is_groomer : Bool?,
        users_profile_image_url : String?
    
    init(JSON: [String : Any]) {
        
        self.raw_speed = JSON["raw_speed"] as? Double ?? 0.0
        self.speed_mph = JSON["speed_mph"] as? Double ?? 0.0
        self.speed_kph = JSON["speed_kph"] as? Double ?? 0.0
        self.longitude = JSON["longitude"] as? Double ?? 0.0
        self.latitude = JSON["latitude"] as? Double ?? 0.0
        self.altitude_feet = JSON["altitude_feet"] as? Double ?? 0.0
        
        self.user_first_name = JSON["user_first_name"] as? String ?? "nil"
        self.user_last_name = JSON["user_last_name"] as? String ?? "nil"
        self.users_firebase_uid = JSON["users_firebase_uid"] as? String ?? "nil"
        self.users_ref_key = JSON["users_ref_key"] as? String ?? "nil"
        self.users_ref_key = JSON["users_ref_key"] as? String ?? "nil"
        self.users_profile_image_url = JSON["users_profile_image_url"] as? String ?? "nil"
        self.is_groomer = JSON["is_groomer"] as? Bool ?? false
        
    }
}
