//
//  User.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/26/21.
//

import Foundation

var userProfileStruct = UserProfileStruct()

struct UserProfileStruct {
    
    var user_first_name: String?
    var user_last_name: String?
    var users_email : String?
    var users_phone_number : String?
    var profile_image_url: String?
    var uploaded_document_url: String?
    var pets: [Pet] = [Pet]()
    var appointments: [Appointment]?
    var is_groomer : Bool?
    var groomers_full_name : String?
    var users_full_name : String?
    
}
