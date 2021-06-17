//
//  User.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/26/21.
//

import Foundation

var userProfileStruct = UserProfileStruct()

struct UserProfileStruct {
    var userName: String?
    var email : String?
    var phoneNumber : String?
    var profileURL: String?
    var uploadedDocumentURL: String?
    var pets: [Pet]?
    var appointments: [Appointment]?
}
