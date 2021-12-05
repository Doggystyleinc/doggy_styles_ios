//
//  SupportChatModel.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/29/21.
//

import Foundation

class ChatSupportModel : NSObject {

    var senders_firebase_uid : String?
    var message : String?
    var message_parent_key : String?
    var time_stamp : Double?
    var type_of_message : String?
    var users_selected_image_url : String?
    
    var is_groomer : Bool?
    var user_first_name : String?
    var user_last_name : String?
    var users_email : String?
    var users_profile_image_url : String?
    
    var image_height : Double?
    var image_width : Double?

    init(JSON : [String : Any]) {
        
        self.senders_firebase_uid = JSON["senders_firebase_uid"] as? String ?? "nil"
        self.message = JSON["message"] as? String ?? "nil"
        self.message_parent_key = JSON["message_parent_key"] as? String ?? "nil"
        self.time_stamp = JSON["time_stamp"] as? Double ?? 0.0
        self.type_of_message = JSON["type_of_message"] as? String ?? "nil"
        self.users_selected_image_url = JSON["users_selected_image_url"] as? String ?? "nil"
        
        self.is_groomer = JSON["is_groomer"] as? Bool ?? false
        self.user_first_name = JSON["user_first_name"] as? String ?? "nil"
        self.user_last_name = JSON["user_last_name"] as? String ?? "nil"
        self.users_email = JSON["users_email"] as? String ?? "nil"
        self.users_profile_image_url = JSON["users_profile_image_url"] as? String ?? "nil"
        
        self.image_height = JSON["image_height"] as? Double ?? 0.0
        self.image_width = JSON["image_width"] as? Double ?? 0.0

        
    }
}
