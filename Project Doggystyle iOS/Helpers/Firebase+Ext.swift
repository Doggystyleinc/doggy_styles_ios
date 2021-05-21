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
//import GoogleSignIn

//MARK: - URLS AND ENDPOINTS TODO: ENVIRONMENTAL VARIABLE
struct Statics {
    static let  HTTPURL : String = "https://doggystyle-dev.herokuapp.com/"
    static let  COMPANYAUTHENDPOINT : String = "company_authentication"
    static let  MANAGEUSERSENDPOINT : String = "manage_users"
    static let  EMAIL : String = "email"
    static let  GOOGLE : String = "google"
    static let  REFERRALCODE: String = "no_code"
    
}

//MARK:- SERVICE SINGLETON FOR CRUD OPERATIONS
class Service : NSObject {
    
    static let shared = Service()
    
    //MARK:- DOUBLE CHECK FOR AUTH SO WE CAN MAKE SURE THERE ALL USERS NODE IS CURRENT
    func authCheck(completion : @escaping (_ hasAuth : Bool)->()) {
        
        if let user_uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference().child("all_users").child(user_uid).child("users_firebase_uid")
            
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
    
    
    //MARK:- REGISTRATION: ERROR CODE 200 PROMPTS REGISTRATION SUCCESS WITH LOGIN FAILURE, SO CALL LOGIN FUNCTION AGAIN INDEPENDENTLY. 500 = REGISTRATION FAILED, CALL THIS FUNCTION AGAIN FROM SCRATCH.
    func FirebaseRegistrationAndLogin(usersEmailAddress : String, usersPassword : String, mobileNumber : String, referralCode : String?, signInMethod : String, completion : @escaping (_ registrationSuccess : Bool, _ response : String, _ responseCode : Int)->()) {
        let databaseRef = Database.database().reference()
        
        var referralCodeGrab : String = "no_code"
        referralCodeGrab = referralCode != nil ? referralCode! : "no_code"
        
        //STEP 1 - AUTHENTICATE A NEW ACCOUNT ON BEHALF OF THE USER
        Auth.auth().createUser(withEmail: usersEmailAddress, password: usersPassword) { (result, error) in
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
                Auth.auth().signIn(withEmail: usersEmailAddress, password: usersPassword) { (user, error) in
                    
                    if error != nil {
                        completion(false, "Login Error: \(error?.localizedDescription as Any).", 200)
                        return
                    }
                    
                    //STEP 3 - UPDATE THE USERS CREDENTIALS IN THE DATABASE AS A BACKUP
                    guard let firebase_uid = user?.user.uid else {
                        completion(false, "UID Error: \(error?.localizedDescription as Any).", 200)
                        return
                    }
                    
                    let ref = databaseRef.child("all_users").child(firebase_uid)
                    
                    let timeStamp : Double = NSDate().timeIntervalSince1970,
                        ref_key = ref.key ?? "nil_key"
                    
                    let values : [String : Any] = ["users_firebase_uid" : firebase_uid, "users_email" : usersEmailAddress, "users_sign_in_method" : signInMethod, "users_sign_up_date" : timeStamp, "is_users_terms_and_conditions_accepted" : true, "users_phone_number" : mobileNumber, "users_ref_key" : ref_key, "referral_code_grab" : referralCodeGrab]
                    
                    ref.updateChildValues(values) { (error, ref) in
                        if error != nil {
                            completion(false, "Login Error: \(error?.localizedDescription as Any).", 200)
                            return
                        }
                        completion(true, "Success", 200)
                    }
                }
            }
        }
    }
    
    //MARK:- IN THE CASE LOGIN FAILS DURING REGISTRATION AND LOGIN, CALL LOGIN AGAIN ONLY.
    func FirebaseLogin(usersEmailAddress : String, usersPassword : String, completion : @escaping (_ loginSuccess : Bool, _ response : String, _ responseCode : Int) -> ()) {
        
        Auth.auth().signIn(withEmail: usersEmailAddress, password: usersPassword) { (user, error) in
            
            if error != nil {
                completion(false, "Login Error: \(error!.localizedDescription as Any).", 500)
                return
            }
            completion(true, "Success", 200)
        }
    }
    
    //MARK:- MANUAL HTTPS AUTH
    func firebaseAuthPOSTRequest(parameters : [String : String], endpoint : String,  completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        guard let url = URL(string: "\(Statics.HTTPURL) + \(endpoint)") else {return} //ALWAYS SUCCEEDS PER UNIT TEST STRING VALIDATION
        
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
    
    //MARK:- PASSWORD RESET WITH EMAIL VALIDATION (WEBVIEW)
    func firebaseForgotPassword(validatedEmail : String, completion : @escaping (_ success : Bool, _ response : String)->()) {
            Auth.auth().sendPasswordReset(withEmail: validatedEmail, completion: { (error) in
                if error != nil {
                    completion(false, "Failed: \(error!.localizedDescription as Any)")
                    return
                }
                completion(true, "Success")
            })
    }
    
    func firebaseGoogleSignIn(credentials : AuthCredential, referralCode : String?, completion : @escaping (_ success : Bool, _ response : String)->()) {
        
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
            
            var referralCodeGrab : String = Statics.REFERRALCODE
            
            referralCodeGrab = referralCode != "no_code" ? referralCode! : Statics.REFERRALCODE
            
            let ref = databaseRef.child("all_users").child(usersUID)
            
            let timeStamp : Double = NSDate().timeIntervalSince1970,
                ref_key = ref.key ?? "nil_key"
            
            let values : [String : Any] = [
                "users_firebase_uid" : usersUID,
                "users_email" : usersEmail,
                "users_sign_in_method" : Statics.GOOGLE,
                "users_sign_up_date" : timeStamp,
                "is_users_terms_and_conditions_accepted" : true,
                "users_ref_key" : ref_key,
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
    
    func updateAllUsers(usersEmail: String, userSignInMethod: String, completion: @escaping (_ updateUserSuccess: Bool) -> ()) {
        if let user_uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("all_users").child(user_uid)
            let timeStamp : Double = NSDate().timeIntervalSince1970
            let ref_key = ref.key ?? "nil_key"
            
            let values : [String : Any] = [
                "users_firebase_uid" : user_uid,
                "users_email" : usersEmail,
                "users_sign_in_method" : userSignInMethod,
                "users_sign_up_date" : timeStamp,
                "is_users_terms_and_conditions_accepted" : true,
                "users_ref_key" : ref_key]
            
            ref.updateChildValues(values) { error, databaseReference in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
}


