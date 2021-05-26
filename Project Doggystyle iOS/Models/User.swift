//
//  User.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/26/21.
//

import Foundation

struct User: Codable {
    let uuid: String
    let email: String
    let mobileNumber: String
    let referralCode: String
    let signUpDate: String
}
