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
    
    func twilioSendTextMessage(type_of_message : String, users_country_code: String, users_phone_number: String, stringMessage : String, completion: @escaping (_ isComplete : Bool, Error?) -> Void) {
        
        let database = Database.database().reference()
        
        database.child("secret_keys").child("twilio").observeSingleEvent(of: .value, with: { (snap : DataSnapshot) in
            
            guard let dic = snap.value as? [String : AnyObject] else {return}
            
            guard let account_sid = dic["account_sid"] as? String else {return}
            
            guard let access_token = dic["access_token"] as? String else {return}
            
            guard let from_number = dic["from_number"] as? String else {return}
            
            guard let message = dic["message"] as? String else {return}
            
            let sendersFirstName = userProfileStruct.user_first_name ?? "Doggy lover"
            let referralCode = userProfileStruct.user_created_referral_code_grab ?? "Doggy lover"
            let appStoreUrl = Statics.DOGGYSTYLE_CONSUMER_APP_URL
            
            //MARK: - FORMATTING FOR THE HOT URL
            let firstEdit = message.replacingOccurrences(of: "[NAME_NAME]", with: sendersFirstName)
            let secondEdit = firstEdit.replacingOccurrences(of: "[CODE_CODE]", with: referralCode)
            let thirdEdit = secondEdit.replacingOccurrences(of: "[URL_URL]", with: appStoreUrl)

            //Woof! Woof! [NAME_NAME] has invited you to the Doggystyle iOS application (Groomers for Dirty Dogs) - Please use the following referral code during registration: [CODE_CODE]. Get it now: [URL_URL]
            
            let url = "https://api.twilio.com/2010-04-01/Accounts/\(account_sid)/Messages"
            
            let toPhoneNumber = "+\(users_country_code)\(users_phone_number)"
            
            var finalMessage = message
            
            if type_of_message == "referral" {
                finalMessage = thirdEdit
            } else {
                finalMessage = stringMessage
            }
            
            let parameters : Parameters = ["To": toPhoneNumber, "From" : from_number, "Body" : finalMessage]
            
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



