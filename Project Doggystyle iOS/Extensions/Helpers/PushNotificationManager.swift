//
//  PushNotificationManager.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/18/21.
//


import Foundation
import UIKit
import Firebase
import Alamofire

final class PushNotificationManager: NSObject {
    
    static func sendPushNotification(title : String, body : String, recipients_user_uid : String, completion : @escaping (_ success : Any?, _ error : Any?) -> ()) {
        
        //MARK: - GUARD HERE JUST INCASE THE IMPORRIBLE BECOMES POSSIBLE
        if title.count == 0 {return}
        if body.count == 0 {return}
        
        let databaseRef = Database.database().reference()
        
        //MARK: - USER SHOULD NOT BE HERE IF THEY ARE NOT SIGNED IN
        guard let _ = Auth.auth().currentUser?.uid else { return }
        
        databaseRef.child("all_users").child(recipients_user_uid).observeSingleEvent(of: .value, with: { (snap : DataSnapshot) in
            
            guard let dic = snap.value as? [String : AnyObject] else { return }
            
            let pushToken = dic["users_push_token"] as? String ?? "nil"
            let sendersName = dic["user_first_name"] as? String ?? "nil"
            
            if pushToken == "nil" {return}
            if sendersName == "nil" {return}
            
            let token = pushToken
            
            let url = "https://fcm.googleapis.com/fcm/send"
            var secretKey = ""
            
            if EnvironemntModeHelper.isCurrentEnvironmentDebug() == true {
                secretKey = "key = AAAA7Ac2hzY:APA91bH3nYaC11MliJl7W5sSyMMkwD90r-Qphrgse51T_z-WmPLAKv8Z9myn4kf6NhJAVQ7MgrZPJR3zqiXpCRM0DO2YCvvds5US7kG4_aXYVe2wcq2A8BlSgfvM-XU_Rp1cYhFFqeMB"
            } else {
                secretKey = "key = AAAAtw2tTGs:APA91bGjykgZ6WXJpZKMwGzuD49SJqTKhDHmqhsFnxA31icmrlibVtgjTfzUUannS-o1o0ac8PO5UcqGr-4kMWgX6bA5ysin-RZ7irfaf1O2Bl9bGX9dQSVTpYZMsGG3g5Ew1ZaDG4me"
            }
            
            let headers : HTTPHeaders = ["Content-Type" : "application/json",
                                         "Authorization" : secretKey]
            
            let notificationsParameters: Parameters = [
                "to": token,
                "content-available":true,
                "priority":"high",
                "notification" : [
                    "title" : title,
                    "body" : body,
                ],
            ]
            
            AF.request(url, method: .post, parameters: notificationsParameters, encoding : JSONEncoding.default, headers: headers).responseJSON { response in
                
                switch response.result {
                
                case .success:
                    print("SUCCESS FROM THE PUSH NOTE")
                    let data = response.value
                    completion(data, nil)
                    
                case .failure(let error):
                    print("FAILURE FROM THE PUSH NOTE")
                    completion(nil, error)
                }
            }
        }) { (true) in }
    }
}
