//
//  DashboardDatasource.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/9/21.
//

import Foundation
import UIKit

public class DoggyProfileDataSource : NSObject {
    
    var dog_builder_name : String?
    var dog_builder_breed : String?
    var dog_builder_birthday : String?
    var dog_builder_favorite_treat : String?
    var dog_builder_favorite_food : String?
    var dog_builder_size : String?
    var dog_builder_frequency : String?
    var dog_builder_profile_url : String?
    var dog_builder_vaccine_card_url : String?
    var ref_key : String?
    var user_uid : String?
    var parent_key : String?
    
    var dog_builder_has_medical_conditions : Bool?
    var dog_builder_has_behavioral_conditions : Bool?
    var dog_builder_has_vaccine_card : Bool?

    var time_stamp : Double?


    init(json : [String : Any]) {
        
        dog_builder_name = json["dog_builder_name"] as? String ?? ""
        dog_builder_breed = json["dog_builder_breed"] as? String ?? ""
        dog_builder_birthday = json["dog_builder_birthday"] as? String ?? ""
        dog_builder_favorite_treat = json["dog_builder_favorite_treat"] as? String ?? ""
        dog_builder_favorite_food = json["dog_builder_favorite_food"] as? String ?? ""
        dog_builder_size = json["dog_builder_size"] as? String ?? ""
        dog_builder_frequency = json["dog_builder_frequency"] as? String ?? ""
        dog_builder_profile_url = json["dog_builder_profile_url"] as? String ?? ""
        dog_builder_vaccine_card_url = json["dog_builder_vaccine_card_url"] as? String ?? ""
        ref_key = json["ref_key"] as? String ?? ""
        user_uid = json["user_uid"] as? String ?? ""
        parent_key = json["parent_key"] as? String ?? ""
        
        dog_builder_has_medical_conditions = json["dog_builder_has_medical_conditions"] as? Bool ?? false
        dog_builder_has_behavioral_conditions = json["dog_builder_has_behavioral_conditions"] as? Bool ?? false
        dog_builder_has_vaccine_card = json["dog_builder_has_vaccine_card"] as? Bool ?? false

        time_stamp = json["time_stamp"] as? Double ?? 0.0

        
    }
}
