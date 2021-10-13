//
//  UserModel.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 9/26/21.
//

import Foundation

//MARK: - ONBOARDING BUILDER ONLY
var userOnboardingStruct = UserOnboardingStruct()

struct UserOnboardingStruct {
    
    var user_first_name: String?,
        user_last_name: String?,
        users_full_name : String?,
        users_email : String?,
        users_phone_number : String?,
        users_country_code : String?,
        users_full_phone_number : String?,
        is_groomer : Bool?,
        users_password : String?,
        
        chosen_grooming_location_name : String?,
        chosen_grooming_location_latitude : Double?,
        chosen_grooming_location_longitude : Double?,
        
        referral_code_grab : String?,
        user_enabled_notifications : Bool?,
        user_grooming_locational_data : [String : Any]?

    //MARK: - LOCATION FOUND SPECIFIC

}


//MARK: - GENERAL APPLICATION USE
var userProfileStruct = UserProfileStruct()

struct UserProfileStruct {
    
    var user_first_name: String?,
        user_last_name: String?,
        users_full_name: String?,
        users_email : String?,
        users_phone_number : String?,
        users_country_code : String?,
        users_full_phone_number : String?,
        is_groomer : Bool?,
        users_profile_image_url: String?,
        chosen_grooming_location_name : String?,
        chosen_grooming_location_latitude : Double?,
        chosen_grooming_location_longitude : Double?,
        referral_code_grab : String?,
        user_enabled_notifications : Bool?,
        users_firebase_uid : String?,
        users_sign_up_date : String?,
        uploaded_document_url : String?,
        users_ref_key : String?,
        user_grooming_locational_data : [String : Any]?,
        user_has_doggy_profile : Bool?

}
