//
//  TwilioTextMessage.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/22/21.
//


import Foundation
import UIKit
import Firebase
import Alamofire

final class TextMessageHTTP : NSObject {
    
    //MARK: - SINGLETON FOR SHARES SERVICE
    static let shared = TextMessageHTTP()
    
    func twilioSendTextMessage(users_country_code: String, users_phone_number: String, stringMessage : String, completion: @escaping (_ isComplete : Bool, Error?) -> Void) {
        
        let database = Database.database().reference()
        
        database.child("secret_keys").child("twilio").observeSingleEvent(of: .value, with: { (snap : DataSnapshot) in
            
            guard let dic = snap.value as? [String : AnyObject] else {return}
            
            guard let account_sid = dic["account_sid"] as? String else {return}
            
            guard let access_token = dic["access_token"] as? String else {return}
            
            guard let from_number = dic["from_number"] as? String else {return}
            
            let url = "https://api.twilio.com/2010-04-01/Accounts/\(account_sid)/Messages"
            
            let toPhoneNumber = "+\(users_country_code)\(users_phone_number)"
            
            print(toPhoneNumber)
            
            let parameters : Parameters = ["To": toPhoneNumber, "From" : from_number, "Body" : stringMessage]
            
            AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
                .authenticate(username: account_sid, password: access_token)
                .response { response in

                    if response.error != nil {

                        print("TEXT MESSAGE ERROR DURINNG SENDING")
                        completion(false, response.error)

                    } else {

                        print("TEXT MESSAGE SENT SUCCESSFULLY")
                        completion(true, nil)

                    }
                }
        
    }) { (error) in
    
    completion(false, error)
    print("TEXT MESSAGE FAILURE DURINNG SENDING")
    
    }
}
}



