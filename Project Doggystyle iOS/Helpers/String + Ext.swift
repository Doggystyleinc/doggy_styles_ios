//
//  String + Ext.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/5/21.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    //8 character minimum
    var isValidPassword: Bool {
        let passwordFormat = "(?=.*[a-z]).{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneNumberFormat = "^\\d{3}\\d{3}\\d{4}$"
//        let internationalFormat = "^\\+(?:[0-9]?){6,14}[0-9]$"
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberFormat)
        return numberPredicate.evaluate(with: self)
    }
}