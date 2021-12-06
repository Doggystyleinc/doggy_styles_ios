//
//  DataPostStructures.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 12/5/21.
//

import Foundation
import UIKit
import Firebase

class DataPostStructures : NSObject {
    
    static let shared = DataPostStructures()
    
    //MARK: - MOBILE GROOMING DATA POST (ONE TIME POST OR FOR UPDATING)
    func postMobileGroomingServiceLocations(completion : @escaping ( _ isComplete : Bool)->()) {
        
        let databaseRef = Database.database().reference()
        
        let dicOne : [String : Any] = ["address" : "501 Queen St W #200, Toronto, ON M5V 2B4, Canada", "latitude" : 43.648205592514856, "longitude" : -79.3985467892444, "website" : "mrcondo.com"]
        
        let dicTwo : [String : Any] = ["address" : "8 York St, Toronto, ON M5J 2Y2, Canada", "latitude" : 43.64023365065314, "longitude" : -79.38089629984559, "website" : "https://www.waterclubcondo.ca/"]
        
        let values = ["1" : dicOne, "2" : dicTwo]
        
        let ref = databaseRef.child("service_locations")
        
        ref.updateChildValues(values) { error, ref in
            completion(true)
        }
    }
    
    //MARK: - FLAGSHIP GROOMING DATA POST (ONE TIME POST OR FOR UPDATING)
    func postFlagShipGroomingServiceLocations(completion : @escaping ( _ isComplete : Bool)->()) {
        
        let databaseRef = Database.database().reference()
        
        let dicOne : [String : Any] = ["address" : "2527 Yonge St, Toronto, ON M4P 2H9, Canada, Canada", "latitude" : 43.71279880646641, "longitude" : -79.39932257379911, "website" : "https://artofsmile.ca"]
       
        let values = ["1" : dicOne]
        
        let ref = databaseRef.child("flagship_locations")
        
        ref.updateChildValues(values) { error, ref in
            completion(true)
        }
    }
    
    //MARK: - SECRET KEYS FOR TWILIO
    func postSecretKeys(completion : @escaping ( _ isComplete : Bool)->()) {
     
        let databaseRef = Database.database().reference()
        
        let values : [String : Any] = ["access_token" : "abf1431d6d3686184909f4ea32fa8d15", "account_sid" : "AC4e1423b3649a619f1216c228f9f3096c", "from_number" : "+17865898806"]
        
        let ref = databaseRef.child("secret_keys").child("twilio")
        
        ref.updateChildValues(values) { error, ref in
            completion(true)
        }
    }
    
    //MARK: - CALL TO BACKFILL THE DATABASE INCASE OF A DATA WIPE, NEW DATABASE ETC 
    func postAllDummyNodes() {
        
        DataPostStructures.shared.postMobileGroomingServiceLocations { complete in
            DataPostStructures.shared.postFlagShipGroomingServiceLocations { complete in
                DataPostStructures.shared.postSecretKeys { complete in
                    print("data structs updated")
                }
            }
        }
    }
}



