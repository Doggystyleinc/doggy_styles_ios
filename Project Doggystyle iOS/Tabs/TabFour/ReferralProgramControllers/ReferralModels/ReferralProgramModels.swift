//
//  ReferralProgramModels.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/21/21.
//

import Foundation


struct ContactsList {
    
    var givenName : String?
    var familyName : String?
    var phoneNumber : String?
    var isCurrentDoggystyleUser : Bool?
    var fullPhoneNumber : String?

    init(json : [String : Any]) {
        
        givenName = json["givenName"] as? String ?? "nil"
        familyName = json["familyName"] as? String ?? "nil"
        phoneNumber = json["phoneNumber"] as? String ?? "nil"
        fullPhoneNumber = json["fullPhoneNumber"] as? String ?? "nil"
        isCurrentDoggystyleUser = json["doggystyleUser"] as? Bool ?? false
    }
}

class UserPhoneNumberModel : NSObject {
    
    var users_phone_number : String?
    var user_first_name : String?
    var user_last_name : String?
    var users_ref_key : String?

     init(JSON : [String : Any]) {
        
        self.users_phone_number = JSON["users_phone_number"] as? String ?? ""
        self.user_first_name = JSON["user_first_name"] as? String ?? ""
        self.user_last_name = JSON["user_last_name"] as? String ?? ""
        self.users_ref_key = JSON["users_ref_key"] as? String ?? ""
    }
}
