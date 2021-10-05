//
//  NewDogBuilder.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/4/21.
//

import Foundation
import UIKit

var globalNewDogBuilder = NewDogBuilder()

struct NewDogBuilder {
    
    //MARK: - NEWDOGONE
    var dogBuilderName : String?
    var dogBuilderBreed : String?
    var dogBuilderBirthday : String?
    var dogBuilderProfileImage : UIImage?
    
    //MARK: - NEWDOGTWO
    enum dogSize : String {
        case small = "Small"
        case medium = "Medium"
        case large = "Large"
        case xlarge = "X-Large"
    }
    
    var dogBuilderSize = dogSize.small
    
    enum groomingFrequency : String {
        case fourWeeks = "4 weeks"
        case eightWeeks = "8 weeks"
    }
    
    var dogBuilderGroomingFrequency = groomingFrequency.fourWeeks
    
    //MARK: - NEWDOGTHREE
    var dogBuilderFavoriteTreat : String?
    var dogBuilderFavoriteFood : String?
    
    //MARK: - NEWDOGFOUR
    var dogBuilderHasMedicalConditions : Bool?
    var dogBuilderHasBehaviouralConditions : Bool?
    var dogBuilderHasUploadedVaccineCard : Bool? = false
    var dogBuilderHasUploadedVaccineImage: UIImage?
    var dogBuilderHasUploadedVaccineFilePath: String?
    var medicalConditionDescription : String?
    var behavioralConditionDescription : String?
    
}

