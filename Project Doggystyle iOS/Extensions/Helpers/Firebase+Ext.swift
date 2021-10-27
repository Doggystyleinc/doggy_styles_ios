//
//  Firebase+Ext.swift
//  Project Doggystyle
//
//  Created by Charlie Arcodia on 5/11/21.

//Apple Auth: https://firebase.google.com/docs/auth/ios/apple
//Google Auth: https://firebase.google.com/docs/auth/ios/google-signin
//Email Auth: https://firebase.google.com/docs/auth/ios/password-auth

import Foundation
import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
//import GoogleSignIn

//MARK: - SERVICE SINGLETON FOR CRUD OPERATIONS
class Service : NSObject {
    
    static let shared = Service()
    
    func locationChecker(preferredLatitude : Double?, preferredLongitude : Double?, completion : @escaping (_ foundLocation : Bool, _ latitude : Double, _ longitude : Double, _ address : String, _ website : String, _ distanceInMeters : Double)->()) {
        
        let databaseRef = Database.database().reference()
        
        var isFound : Bool = false
        
        var counter : Int = 0,
            observingRefOne = Database.database().reference(),
            handleOne = DatabaseHandle()
        
        if preferredLatitude == nil || preferredLongitude == nil {
            completion(true, 0.0, 0.0, "nil", "nil", 0.0)
        } else {
            
            guard let safePreferredLatitude = preferredLatitude else {return}
            guard let safePreferredLongitude = preferredLongitude else {return}
            
            let clients_preferred_location = CLLocation(latitude: safePreferredLatitude, longitude: safePreferredLongitude)
            
            let clients_preferred_location_coordinates = clients_preferred_location
            
            let ref = databaseRef.child("service_locations")
            
            ref.observeSingleEvent(of: .value) { snapCount in
                
                if snapCount.exists() {
                    
                    let snapChildrenCount = Int(snapCount.childrenCount)
                    
                    observingRefOne = databaseRef.child("service_locations")
                    
                    handleOne = observingRefOne.observe(.childAdded, with: { snapLoop in
                        
                        if isFound == true {return}
                        
                        if let JSON = snapLoop.value as? [String : Any] {
                            
                            counter += 1
                            
                            let latitude = JSON["latitude"] as? Double ?? 0.0
                            let longitude = JSON["longitude"] as? Double ?? 0.0
                            let address = JSON["address"] as? String ?? "nil"
                            let website = JSON["website"] as? String ?? "nil"
                            
                            let doggystyle_services_preferred_location = CLLocation(latitude: latitude, longitude: longitude)
                            
                            let differenceInMeters = abs(clients_preferred_location_coordinates.distance(from: doggystyle_services_preferred_location))
                            
                            let threeMileThresholdInMeters = 4828.03
                            
                            if differenceInMeters > threeMileThresholdInMeters {
                                print("not servicing \(address) because the client is \(differenceInMeters) meters away which is greater than the threshold of \(threeMileThresholdInMeters) - they can be found at \(website)")
                                
                                if counter >= snapChildrenCount {
                                    //MARK: - HERE NO BUILDING WAS FOUND, SO WE HAVE TO ADD THEM TO A WAIT LIST AND SEE IF SOME MORE PEOPLE VOTE ON THEIR LOCATION TO HAVE IT ADDED
                                    completion(false, safePreferredLatitude, safePreferredLongitude, "nil", "nil", differenceInMeters)
                                    observingRefOne.removeObserver(withHandle: handleOne)
                                    return
                                }
                                
                            } else {
                                print("MATCH FOUND! We are servicing \(address) because the client is \(differenceInMeters) meters away which is less than the threshold of \(threeMileThresholdInMeters) - they can be found at \(website)")
                                isFound = true
                                counter = snapChildrenCount
                                observingRefOne.removeObserver(withHandle: handleOne)
                                
                                completion(true, latitude, longitude, address, website, differenceInMeters)
                                return
                            }
                            
                        } else {
                            observingRefOne.removeObserver(withHandle: handleOne)
                            completion(false, 0.0, 0.0, "nil", "nil", 0.0)
                        }
                        
                    })
                    
                } else {
                    observingRefOne.removeObserver(withHandle: handleOne)
                    completion(false, 0.0, 0.0, "nil", "nil", 0.0)
                }
            }
        }
    }
    
    func handleFirebaseLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            return
        }
        
        Database.database().reference().removeAllObservers()
    }
    
    //MARK: - DOUBLE CHECK FOR AUTH SO WE CAN MAKE SURE THERE ALL USERS NODE IS CURRENT
    func authCheck(completion : @escaping (_ hasAuth : Bool)->()) {
        
        if let user_uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference().child(Constants.allUsers).child(user_uid).child("users_firebase_uid")
            
            ref.observeSingleEvent(of: .value) { (snap : DataSnapshot) in
                
                if snap.exists() {
                    print(snap.value as? String ?? "none-here")
                    completion(true)
                } else {
                    completion(false)
                }
                
            } withCancel: { (error) in
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
    
    //MARK: - REGISTRATION: ERROR CODE 200 PROMPTS REGISTRATION SUCCESS WITH LOGIN FAILURE, SO CALL LOGIN FUNCTION AGAIN INDEPENDENTLY. 500 = REGISTRATION FAILED, CALL THIS FUNCTION AGAIN FROM SCRATCH.
    func FirebaseRegistrationAndLogin( completion : @escaping (_ registrationSuccess : Bool, _ response : String, _ responseCode : Int)->()) {
        let databaseRef = Database.database().reference()
        
        guard let user_first_name = userOnboardingStruct.user_first_name else {return}
        guard let user_last_name = userOnboardingStruct.user_last_name else {return}
        guard let users_full_name = userOnboardingStruct.users_full_name else {return}
        guard let users_email = userOnboardingStruct.users_email else {return}
        guard let users_phone_number = userOnboardingStruct.users_phone_number else {return}
        guard let users_country_code = userOnboardingStruct.users_country_code else {return}
        guard let users_full_phone_number = userOnboardingStruct.users_full_phone_number else {return}
        guard let is_groomer = userOnboardingStruct.is_groomer else {return}
        guard let users_password = userOnboardingStruct.users_password else {return}
        guard let user_enabled_notifications = userOnboardingStruct.user_enabled_notifications else {return}
        
        guard let chosen_grooming_location_name = userOnboardingStruct.chosen_grooming_location_name else {return}
        guard let chosen_grooming_location_latitude = userOnboardingStruct.chosen_grooming_location_latitude else {return}
        guard let chosen_grooming_location_longitude = userOnboardingStruct.chosen_grooming_location_longitude else {return}
        guard let user_grooming_locational_data = userOnboardingStruct.user_grooming_locational_data else {return}
        
        let referral_code_grab = userOnboardingStruct.referral_code_grab ?? "nil"
        
        //STEP 1 - AUTHENTICATE A NEW ACCOUNT ON BEHALF OF THE USER
        Auth.auth().createUser(withEmail: users_email, password: users_password) { (result, error) in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .emailAlreadyInUse: completion(false, "\(errCode)", 500)
                    case .accountExistsWithDifferentCredential: completion(false, "\(errCode)", 500)
                    case .credentialAlreadyInUse: completion(false, "\(errCode)", 500)
                    case .emailChangeNeedsVerification: completion(false, "\(errCode)", 500)
                    case .expiredActionCode: completion(false, "\(errCode)", 500)
                    default: completion(false, "Registration Error: \(error?.localizedDescription as Any).", 500)
                    }
                    
                    return
                    
                } else {
                    completion(false, "Registration Error: \(error?.localizedDescription as Any).", 500)
                }
            } else {
                //STEP 2 - SIGN THE USER IN WITH THEIR NEW CREDENTIALS
                Auth.auth().signIn(withEmail: users_email, password: users_password) { (user, error) in
                    
                    if error != nil {
                        completion(false, "Login Error: \(error?.localizedDescription as Any).", 200)
                        return
                    }
                    
                    //STEP 3 - UPDATE THE USERS CREDENTIALS IN THE DATABASE AS A BACKUP
                    guard let firebase_uid = user?.user.uid else {
                        completion(false, "UID Error: \(error?.localizedDescription as Any).", 200)
                        return
                    }
                    
                    let ref = databaseRef.child(Constants.allUsers).child(firebase_uid)
                    
                    let timeStamp : Double = NSDate().timeIntervalSince1970,
                        ref_key = ref.key ?? "nil_key"
                    
                    let values : [String : Any] = [
                        
                        "users_firebase_uid" : firebase_uid,
                        "user_first_name" : user_first_name,
                        "user_last_name" : user_last_name,
                        "users_full_name" : users_full_name,
                        "users_email" : users_email,
                        "users_phone_number" : users_phone_number,
                        "users_country_code" : users_country_code,
                        "users_full_phone_number" : users_full_phone_number,
                        
                        "users_sign_in_method" : "email",
                        "users_sign_up_date" : timeStamp,
                        "is_groomer" : is_groomer,
                        "is_users_terms_and_conditions_accepted" : true,
                        
                        "users_ref_key" : ref_key,
                        
                        "chosen_grooming_location_name" : chosen_grooming_location_name,
                        "chosen_grooming_location_latitude" : chosen_grooming_location_latitude,
                        "chosen_grooming_location_longitude" : chosen_grooming_location_longitude,
                        "referral_code_grab" : referral_code_grab,
                        "user_created_referral_code_grab" : "nil",
                        "user_enabled_notifications" : user_enabled_notifications,
                        "user_grooming_locational_data" : user_grooming_locational_data
                        
                    ]
                    
                    ref.updateChildValues(values) { (error, ref) in
                        if error != nil {
                            completion(false, "Login Error: \(error?.localizedDescription as Any).", 200)
                            return
                        }
                        
                        let found_grooming_location = user_grooming_locational_data["found_grooming_location"] as? Bool ?? false
                        
                        if found_grooming_location == true {
                            completion(true, "Success", 200)
                        } else {
                            
                            //MARK: - DID NOT FIND GROOMING LOCATION, SO ADD IT TO THE REQUESTS FOR VOTERS
                            let requestRef = databaseRef.child("requested_locations_per_user").child(firebase_uid)
                            
                            let values : [String : Any] = ["client_location_request" : user_grooming_locational_data]
                            requestRef.updateChildValues(values) { error, ref in
                                
                                //MARK: - REFERRAL CODE GRAB IS NIL, CHECK THE PHONE NUMBER
                                if referral_code_grab == "nil" {
                                    
                                    //MARK: - SINCE THERE IS NO REFERRAL CODE, CHECK THE PHONE NUMBER OUT OF GOOD FAITH
                                    self.checkForPhoneNumberBackupReferral(selectedusersPhoneNumber: users_phone_number, completion: { userWasInvited, invitersData, parentKey  in
                                        
                                        //MARK: - USER WAS NOT INVITED THROUGH REFERRAL OR PHONE, SEND THEM ON IN.
                                        if userWasInvited == false {
                                            completion(true, "Success", 200)
                                        } else {
                                            
                                            //MARK: - USER DOES HAVE A REFERRAL CODE, CHECK WHO OWNS IT AND THROW THEM THE CASH THROUGH THE NODE 'inviters_email_companion_success'
                                            if invitersData != nil {
                                                
                                                guard let data = invitersData else {return}
                                                
                                                let invitersUID = data["inviters_UID"] as? String ?? "nil"
                                                
                                                let values : [String : Any] = ["inviters_email_companion_success" : true]
                                                
                                                let refOne = databaseRef.child("global_pending_invites").child(parentKey)
                                                
                                                refOne.updateChildValues(values) { error, ref in
                                                    
                                                    //MARK: - NOW UPDATE THE NODE 'personal_pending_invites'
                                                    self.updatePersonalReferralNode(invitersUID: invitersUID, passedRecipientPhoneNumber: users_phone_number) { complete in
                                                        
                                                        completion(true, "Success", 200)
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    })
                                    
                                    //MARK: - USER HAS A REFERRAL CODE, CHECK IF THEY ARE INVITED OR MOOCHING
                                } else {
                                    
                                    //CHECK IF THE CLIENT WAS PERSONALLY INVITED OR IF SOMEONE VERBALLY GAVE THEM THE CODE
                                    self.checkForPhoneNumberBackupReferral(selectedusersPhoneNumber: users_phone_number) { userWasInvited, invitersData, parentKey in
                                        
                                        //USER WAS INVITED AND THE USER IS USING THE CODE
                                        if userWasInvited == true {
                                            
                                            //MARK: - USER DOES HAVE A REFERRAL CODE, CHECK WHO OWNS IT AND THROW THEM THE CASH THROUGH THE NODE 'inviters_email_companion_success'
                                            if invitersData != nil {
                                                
                                                guard let data = invitersData else {return}
                                                
                                                let invitersUID = data["inviters_UID"] as? String ?? "nil"
                                                
                                                let values : [String : Any] = ["inviters_email_companion_success" : true]
                                                
                                                let refOne = databaseRef.child("global_pending_invites").child(parentKey)
                                                
                                                refOne.updateChildValues(values) { error, ref in
                                                    
                                                    //MARK: - NOW UPDATE THE NODE 'personal_pending_invites'
                                                    self.updatePersonalReferralNode(invitersUID: invitersUID, passedRecipientPhoneNumber: users_phone_number) { complete in
                                                        completion(true, "Success", 200)
                                                    }
                                                }
                                            }
                                            
                                            //MARK: USER HAS NO FORMAL INVITE BUT THEY HAVE A CODE
                                        } else {
                                            
                                            self.checkForValidReferralCodeAndReturnOwnerData(passedReferralCode: referral_code_grab) { foundCode, parentKey, ownerData in
                                                
                                                if foundCode == true {
                                                    
                                                    if ownerData != nil {
                                                        
                                                        guard let safeData = ownerData else {return}
                                                        
                                                        let inviters_UID = safeData["users_firebase_uid"] as? String ?? "nil"
                                                        let inviters_firstName = safeData["user_first_name"] as? String ?? "nil"
                                                        let inviters_lastName = safeData["user_last_name"] as? String ?? "nil"
                                                        let inviters_phoneNumber = safeData["users_phone_number"] as? String ?? "nil"
                                                        let inviters_fullPhoneNumber = safeData["users_full_phone_number"] as? String ?? "nil"
                                                        let inviters_fullName = safeData["users_full_name"] as? String ?? "nil"
                                                        let inviters_country_code = safeData["users_country_code"] as? String ?? "nil"
                                                        let inviters_email = safeData["users_email"] as? String ?? "nil"
                                                        let _ = safeData["referral_code_grab"] as? String ?? "nil"
                                                        
                                                        let recipient_family_name = userOnboardingStruct.user_last_name ?? "nil"
                                                        let recipient_given_name = userOnboardingStruct.user_first_name ?? "nil"
                                                        let recipient_phone_number = userOnboardingStruct.users_phone_number ?? "nil"
                                                        let recipient_full_phone_number = userOnboardingStruct.users_full_phone_number ?? "nil"
                                                        
                                                        let timeStamp : Double = Date().timeIntervalSince1970
                                                        
                                                        //MARK: - INVITERS INFORMATION
                                                        let values : [String : Any] = ["inviters_firstName" : inviters_firstName,
                                                                                       "inviters_lastName" : inviters_lastName,
                                                                                       "inviters_fullName" : inviters_fullName,
                                                                                       "inviters_phoneNumber" : inviters_phoneNumber,
                                                                                       "inviters_fullPhoneNumber" : inviters_fullPhoneNumber,
                                                                                       "inviters_UID" : inviters_UID,
                                                                                       "inviters_country_code" : inviters_country_code,
                                                                                       "inviters_email" : inviters_email,
                                                                                       "inviters_email_companion_success" : true,
                                                                                       
                                                                                       //MARK: - RECIPIENTS INFORMATION
                                                                                       "recipient_family_name" : recipient_family_name,
                                                                                       "recipient_given_name" : recipient_given_name,
                                                                                       "recipient_phone_number" : recipient_phone_number,
                                                                                       "recipient_full_phone_number" : recipient_full_phone_number,
                                                                                       "time_stamp" : timeStamp,
                                                                                       "from_code_search" : true]
                                                        
                                                        let refPersonal = databaseRef.child("personal_pending_invites").child(inviters_UID).childByAutoId()
                                                        refPersonal.updateChildValues(values) { error, ref in
                                                            let refGlobal = databaseRef.child("global_pending_invites").child(inviters_UID).childByAutoId()
                                                            refGlobal.updateChildValues(values) { error, ref in
                                                                completion(true, "Success", 200)
                                                            }
                                                        }
                                                        
                                                    } else {
                                                        completion(true, "Success", 200)
                                                    }
                                                    
                                                } else {
                                                    //IF NOONE, LET THEM KNOW AND COMPLETE
                                                    completion(true, "Success", 200)
                                                }
                                            }
                                        }
                                    }
                                    
                                    completion(true, "Success", 200)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkForValidReferralCodeAndReturnOwnerData(passedReferralCode : String, completion : @escaping (_ foundCode : Bool, _ parentKey : String,  _ ownerData : [String : AnyObject]?)->()) {
        
        let databaseRef = Database.database().reference()
        let ref = databaseRef.child("all_users")
        var passedJSON = [String : AnyObject]()
        var fetchedRefKey : String = "nil"
        
        ref.observeSingleEvent(of: .value) { JSONdata in
            
            var foundOwnersCode : Bool = false
            
            for child in JSONdata.children.allObjects as! [DataSnapshot] {
                
                let JSON = child.value as? [String : AnyObject] ?? [:]
                passedJSON = JSON
                
                let fetchedReferralCode = JSON["referral_code_grab"] as? String ?? "nil"
                
                if passedReferralCode == fetchedReferralCode {
                    
                    fetchedRefKey = ref.key ?? "nil"
                    foundOwnersCode = true
                    
                }
            }
            
            //MARK: - CODE EXISTS
            if foundOwnersCode == true {
                                
                //grab the parent key for personal and grooming
                let refTwo = databaseRef.child("personal_pending_invites").child(fetchedRefKey)
                
                refTwo.observeSingleEvent(of: .value) { JSONdata in
                    completion(true, fetchedRefKey, passedJSON)
                }
                
                //MARK: - CODE DOES NOT EXIST
            } else {
                completion(false, "nil", nil)
            }
        }
    }
    
    func checkForPhoneNumberBackupReferral(selectedusersPhoneNumber : String, completion : @escaping (_ hasBeenInvited : Bool, _ invitersData : [String : AnyObject]?, _ parentKey : String) -> ()) {
        
        let databaseRef = Database.database().reference()
        let ref = databaseRef.child("global_pending_invites")
        var passedJSON = [String : AnyObject]()
        var fetchedRefKey : String = "nil"
        
        ref.observeSingleEvent(of: .value) { JSONdata in
            
            var alreadyTaken : Bool = false
            
            for child in JSONdata.children.allObjects as! [DataSnapshot] {
                
                let JSON = child.value as? [String : AnyObject] ?? [:]
                passedJSON = JSON
                
                let databasePhoneNumber = JSON["recipient_full_phone_number"] as? String ?? "nill"
                
                //MARK: - SELECTED RECIPIENTS - CHECK AGAINST THE DATABASE FOR PRIOIR INVITES
                let selectedUserPhoneNumber = selectedusersPhoneNumber
                
                if selectedUserPhoneNumber == databasePhoneNumber {
                    fetchedRefKey = ref.key ?? "nil"
                    alreadyTaken = true
                }
            }
            
            //MARK: - USER HAS BEEN INVITED
            if alreadyTaken == true {
                completion(true, passedJSON, fetchedRefKey)
            } else {
                //MARK: - USER HAS NOT BEEN INVITED
                completion(false, nil, fetchedRefKey)
            }
        }
    }
    
    func updatePersonalReferralNode(invitersUID : String, passedRecipientPhoneNumber : String, completion : @escaping (_ isComplete : Bool) -> ()) {
        
        let databaseRef = Database.database().reference()
        
        let ref = databaseRef.child("personal_pending_invites").child(invitersUID)
        
        ref.observeSingleEvent(of: .value) { JSONdata in
            
            for child in JSONdata.children.allObjects as! [DataSnapshot] {
                
                let JSON = child.value as? [String : AnyObject] ?? [:]
                
                let databasePhoneNumber = JSON["recipient_full_phone_number"] as? String ?? "nil"
                
                if databasePhoneNumber == passedRecipientPhoneNumber {
                    
                    let parentKey = ref.key ?? "nil"
                    
                    if parentKey != "nil" {
                        
                        let values : [String : Any] = ["inviters_email_companion_success" : true]
                        let updateRef = databaseRef.child("personal_pending_invites").child(invitersUID).child(parentKey)
                        
                        updateRef.updateChildValues(values) { error, ref in
                            
                            completion(true)
                            return
                            
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - IN THE CASE LOGIN FAILS DURING REGISTRATION AND LOGIN, CALL LOGIN AGAIN ONLY.
    func FirebaseLogin(usersEmailAddress : String, usersPassword : String, completion : @escaping (_ loginSuccess : Bool, _ response : String, _ responseCode : Int) -> ()) {
        
        Auth.auth().signIn(withEmail: usersEmailAddress, password: usersPassword) { (user, error) in
            
            if error != nil {
                completion(false, "Login Error: \(error!.localizedDescription as Any).", 500)
                return
            }
            completion(true, "Success", 200)
        }
    }
    
    //MARK: - MANUAL HTTPS AUTH
    func firebaseAuthPOSTRequest(parameters : [String : String], endpoint : String,  completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        guard let url = URL(string: "\(Constants.httpURL) + \(endpoint)") else {return} //ALWAYS SUCCEEDS PER UNIT TEST STRING VALIDATION
        
        let session = URLSession.shared,
            fetchedParameters = parameters
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: fetchedParameters, options: .prettyPrinted)
        } catch let error {
            completion(nil, error)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                completion(json, nil)
            } catch let error {
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
    //MARK: - PASSWORD RESET WITH EMAIL VALIDATION (WEBVIEW)
    func firebaseForgotPassword(validatedEmail: String, completion: @escaping (_ success: Bool, _ response: String) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: validatedEmail, completion: { (error) in
            if error != nil {
                completion(false, "Failed: \(error!.localizedDescription as Any)")
                return
            }
            completion(true, "Success")
        })
    }
    
    func firebaseGoogleSignIn(credentials : AuthCredential, referralCode: String?, completion : @escaping (_ success: Bool, _ response: String) -> ()) {
        
        let databaseRef = Database.database().reference()
        
        Auth.auth().signIn(with: credentials) { (result, error) in
            
            guard let usersUID = result?.user.uid else {
                completion(false, "Failed to grab the users UID for firebase")
                return
            }
            guard let usersEmail = result?.user.email else {
                completion(false, "Failed to grab the users email")
                return
            }
            
            var referralCodeGrab : String = Constants.referralCode
            
            referralCodeGrab = referralCode != "no_code" ? referralCode! : Constants.referralCode
            
            let ref = databaseRef.child(Constants.allUsers).child(usersUID)
            
            let timeStamp : Double = NSDate().timeIntervalSince1970,
                ref_key = ref.key ?? "nil_key"
            
            let values : [String : Any] = [
                "users_firebase_uid" : usersUID,
                "users_email" : usersEmail,
                "users_sign_in_method" : Constants.google,
                "users_sign_up_date" : timeStamp,
                "is_users_terms_and_conditions_accepted" : true,
                "users_ref_key" : ref_key,
                "is_groomer" : false,
                "referral_code_grab" : referralCodeGrab]
            
            ref.updateChildValues(values) { (error, ref) in
                if error != nil {
                    completion(false, "Login Error: \(error?.localizedDescription as Any).")
                    return
                }
                completion(true, "Success")
            }
        }
    }
}

//MARK: - Fetch Current User Data
extension Service {
    
    func fetchCurrentUserData(completion : @escaping (_ isComplete : Bool)->()) {
        
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference()
        let ref = databaseRef.child(Constants.allUsers).child(userUID)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            if let JSON = snapshot.value as? [String : Any] {
                
                let users_firebase_uid = JSON["users_firebase_uid"] as? String ?? "nil"
                let user_first_name = JSON["user_first_name"] as? String ?? "nil"
                let user_last_name = JSON["user_last_name"] as? String ?? "nil"
                let users_full_name = JSON["users_full_name"] as? String ?? "nil"
                let users_email = JSON["users_email"] as? String ?? "nil"
                let users_phone_number = JSON["users_phone_number"] as? String ?? "nil"
                let users_country_code = JSON["users_country_code"] as? String ?? "nil"
                let users_full_phone_number = JSON["users_full_phone_number"] as? String ?? "nil"
                
                let users_sign_up_date = JSON["users_sign_up_date"] as? String ?? "nil"
                let is_groomer = JSON["is_groomer"] as? Bool ?? false
                
                let users_ref_key = JSON["users_ref_key"] as? String ?? "nil"
                
                let chosen_grooming_location_name = JSON["chosen_grooming_location_name"] as? String ?? "nil"
                let chosen_grooming_location_latitude = JSON["chosen_grooming_location_latitude"] as? Double ?? 0.0
                let chosen_grooming_location_longitude = JSON["chosen_grooming_location_longitude"] as? Double ?? 0.0
                let referral_code_grab = JSON["referral_code_grab"] as? String ?? "nil"
                let user_enabled_notifications = JSON["user_enabled_notifications"] as? Bool ?? false
                
                let users_profile_image_url = JSON["users_profile_image_url"] as? String ?? "nil"
                let uploaded_document_url = JSON["uploaded_document_url"] as? String ?? "nil"
                let user_grooming_locational_data = JSON["user_grooming_locational_data"] as? [String : Any] ?? ["nil":"nil"]
                let user_created_referral_code_grab = JSON["user_created_referral_code_grab"] as? String ?? "nil"
                
                userProfileStruct.users_firebase_uid = users_firebase_uid
                userProfileStruct.user_first_name = user_first_name
                
                userProfileStruct.user_last_name = user_last_name
                userProfileStruct.users_full_name = users_full_name
                userProfileStruct.users_email = users_email
                userProfileStruct.users_phone_number = users_phone_number
                userProfileStruct.users_country_code = users_country_code
                userProfileStruct.users_full_phone_number = users_full_phone_number
                
                userProfileStruct.users_sign_up_date = users_sign_up_date
                userProfileStruct.is_groomer = is_groomer
                
                userProfileStruct.users_ref_key = users_ref_key
                
                userProfileStruct.chosen_grooming_location_name = chosen_grooming_location_name
                userProfileStruct.chosen_grooming_location_latitude = chosen_grooming_location_latitude
                userProfileStruct.chosen_grooming_location_longitude = chosen_grooming_location_longitude
                userProfileStruct.referral_code_grab = referral_code_grab
                userProfileStruct.user_enabled_notifications = user_enabled_notifications
                
                userProfileStruct.users_profile_image_url = users_profile_image_url
                userProfileStruct.uploaded_document_url = uploaded_document_url
                userProfileStruct.user_grooming_locational_data = user_grooming_locational_data
                userProfileStruct.user_created_referral_code_grab = user_created_referral_code_grab
                
                completion(true)
                
            } else {
                
                completion(false)
                
            }
        }
    }
}

//MARK: - Add / Update Profile Image
extension Service {
    func uploadProfileImageData(data: Data, completion: @escaping (_ success: Bool) -> ()) {
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child(Constants.profileImages).child(imageName)
        
        imageReference.putData(data, metadata: nil) { metaData, error in
            if error != nil {
                print(error?.localizedDescription as Any)
                completion(false)
                return
            }
            
            imageReference.downloadURL { url, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    completion(false)
                    return
                }
                
                guard let url = url else {
                    print(error?.localizedDescription as Any)
                    completion(false)
                    return
                }
                let urlString = url.absoluteString
                
                Service.shared.updateProfileImage(url: urlString) { success in
                    if success {
                        completion(true)
                    }
                }
            }
            
        }
    }
    
    func updateProfileImage(url: String, completion: @escaping (_ success: Bool) -> ()) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference()
        let ref = databaseRef.child(Constants.allUsers).child(userUID)
        
        let values: [String : Any] = [
            "profile_image_url" : url
        ]
        
        ref.updateChildValues(values) { error, reference in
            if error != nil {
                print(error?.localizedDescription as Any)
                completion(false)
                return
            }
            completion(true)
        }
    }
}

//MARK: - Update/Add User Location
extension Service {
    func uploadAddress(latitude: Double, longitude: Double, address: String, completion: @escaping (_ isComplete: Bool) -> ()) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference()
        let ref = databaseRef.child(Constants.allUsers).child(userUID)
        let values: [String : Any] = [
            "latitude" : latitude,
            "longitude" : longitude,
            "address" : address
        ]
        ref.updateChildValues(values) { error, reference in
            if error != nil {
                print(error?.localizedDescription as Any)
                completion(false)
                return
            }
            completion(true)
        }
    }
}

//MARK: - Notify Later
extension Service {
    func notifyUserLater(mobileNumber: String, completion: @escaping (_ isComplete: Bool) -> ()) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference()
        let ref = databaseRef.child(Constants.allUsers).child(userUID)
        
        let values: [String : Any] = [
            "notify_later_number" : mobileNumber
        ]
        
        ref.updateChildValues(values) { error, reference in
            if error != nil {
                print(error?.localizedDescription as Any)
                completion(false)
                return
            }
            completion(true)
        }
    }
}

//MARK: - Upload Documents
extension Service {
    func uploadDocument(url: URL, completion: @escaping (_ isComplete: Bool) -> ()) {
        let fileName = "UploadedFile " + UUID().uuidString
        let fileReference = Storage.storage().reference().child(Constants.uploadFiles).child(fileName)
        
        fileReference.putFile(from: url, metadata: nil) { _, error in
            if error != nil {
                completion(false)
                return
            }
            completion(true)
            
            fileReference.downloadURL { url, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    completion(false)
                    return
                }
                
                guard let url = url else {
                    print(error?.localizedDescription as Any)
                    completion(false)
                    return
                }
                
                let urlString = url.absoluteString
                Service.shared.storeDocument(url: urlString) { success in
                    if !success {
                        print("Error storing document.")
                    }
                }
            }
        }
    }
    
    func storeDocument(url: String, completion: @escaping (_ success: Bool) -> ()) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference()
        let ref = databaseRef.child(Constants.allUsers).child(userUID)
        
        let values: [String : Any] = [
            "uploaded_document_url" : url
        ]
        
        ref.updateChildValues(values) { error, reference in
            if error != nil {
                print(error?.localizedDescription as Any)
                completion(false)
                return
            }
            userProfileStruct.uploaded_document_url = url
            completion(true)
        }
    }
}

//MARK: - Add/Upload Pet
extension Service {
    func uploadData(forPet pet: Pet, completion: @escaping (_ isComplete: Bool) -> ()) {
        let databaseRef = Database.database().reference()
        guard let user_uid = Auth.auth().currentUser?.uid else { return }
        
        let path = databaseRef.child(Constants.allUsers).child(user_uid).child("pets").childByAutoId()
        
        let value : [String : String] = [
            "pet_name" : pet.name
        ]
        
        path.updateChildValues(value) { error, databaseRef in
            if error != nil {
                print(error?.localizedDescription as Any)
                completion(false)
                return
            }
            print("* Successfully Updated Pet Data *")
            completion(true)
        }
    }
}

//MARK: Add/Upload Appointment
extension Service {
    func uploadData(forAppointment appointment: Appointment, completion: @escaping (_ isComplete: Bool) -> ()) {
        let databaseRef = Database.database().reference()
        guard let user_uid = Auth.auth().currentUser?.uid else { return }
        
        let path = databaseRef.child(Constants.allUsers).child(user_uid).child("appointments").childByAutoId()
        
        let value : [String : String] = [
            "appointment_stylist" : appointment.stylist
        ]
        
        path.updateChildValues(value) { error, databaseRef in
            if error != nil {
                print(error?.localizedDescription as Any)
                completion(false)
                return
            }
            print("* Successfully Updated Appointment Data *")
            completion(true)
        }
    }
}

//MARK: - Twilio
extension Service {
    //INITIAL TWILIO PING TO RECEIVE A CODE
    func twilioPinRequest(phone: String, countryCode: String, deliveryMethod: String, completion: @escaping ( _ isComplete: Bool) -> () ) {
        let unique_key = NSUUID().uuidString
        
        GrabDeviceID.getID { (isComplete, device_id) in
            let ref = Database.database().reference().child("verification_requests").child(unique_key)
            let values = [
                "unique_key" : unique_key,
                "users_phone_number" : phone,
                "users_country_code" : countryCode,
                "delivery_method" : deliveryMethod,
                "device_id" : device_id
            ]
            
            ref.updateChildValues(values) { (error, ref) in
                if error != nil {
                    completion(false)
                    return
                }
                
                //ALL CLEAR AND SUCCESSFUL
                self.twilioPinRequestListener(listeningKey: unique_key, phone: phone, countryCode: countryCode) { allSuccess in
                    
                    if allSuccess {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
        
    }
    
    func twilioPinRequestListener(listeningKey: String, phone: String, countryCode: String, completion: @escaping ( _ isComplete: Bool) -> () ) {
        
        var observingRefOne = Database.database().reference(),
            handleOne = DatabaseHandle()
        
        observingRefOne = Database.database().reference().child("verification_responses").child(listeningKey)
        
        handleOne = observingRefOne.observe(.value) { (snap : DataSnapshot) in
            if snap.exists() {
                guard let dic = snap.value as? [String : AnyObject] else {return}
                
                let status = dic["status"] as? String ?? ""
                
                switch status {
                case "error":
                    observingRefOne.removeObserver(withHandle: handleOne)
                    completion(false)
                    
                default: print("Default for pin request")
                    observingRefOne.removeObserver(withHandle: handleOne)
                    completion(true)
                }
                
            } else if !snap.exists() {
                print("nothing yet here from the doggystyle linker")
            }
        }
    }
    
    //TWILIO - SEND RECEIVED PIN UP FOR APPROVAL
    func twilioPinApprovalRequest(phone : String, countryCode : String, enteredCode : String, completion : @escaping ( _ isComplete : Bool)->()) {
        
        let unique_key = NSUUID().uuidString
        let ref = Database.database().reference().child("pin_verification_requests").child(unique_key)
        let values = [
            "unique_key" : unique_key,
            "users_phone_number" : phone,
            "users_country_code" : countryCode,
            "entered_code" : enteredCode
        ]
        
        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                completion(false)
                return
            }
            
            //ALL CLEAR
            self.twilioPinApprovalRequestListener(listeningKey: unique_key, phone: phone, countryCode: countryCode) { isComplete in
                if isComplete {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    //TWILIO - RECEIVE TWILIO PIN RESPONSE
    func twilioPinApprovalRequestListener(listeningKey : String, phone : String, countryCode : String, completion : @escaping ( _ isComplete : Bool)->()) {
        
        var observingRefOne = Database.database().reference(),
            handleOne = DatabaseHandle()
        
        observingRefOne = Database.database().reference().child("pin_verification_responses").child(listeningKey)
        
        handleOne = observingRefOne.observe(.value) { (snap : DataSnapshot) in
            
            if snap.exists() {
                guard let dic = snap.value as? [String : AnyObject] else {return}
                
                let status = dic["status"] as? String ?? ""
                switch status {
                
                case "error":
                    print("Error on the listening key")
                    observingRefOne.removeObserver(withHandle: handleOne)
                    completion(false)
                    
                case "expired":
                    print("Verification has expired")
                    observingRefOne.removeObserver(withHandle: handleOne)
                    completion(false)
                    
                case "failed":
                    print("Failed Verification")
                    observingRefOne.removeObserver(withHandle: handleOne)
                    completion(false)
                    
                case "canceled":
                    print("Canceled Verification")
                    observingRefOne.removeObserver(withHandle: handleOne)
                    completion(false)
                    
                case "approved":
                    print("Verification code has been approved")
                    observingRefOne.removeObserver(withHandle: handleOne)
                    completion(true)
                    
                default:
                    print("Default for pin approval")
                    observingRefOne.removeObserver(withHandle: handleOne)
                    completion(false)
                }
                
            } else if !snap.exists() {
                print("Waiting for pin approval response...")
            }
        }
    }
}
