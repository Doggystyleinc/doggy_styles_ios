//
//  BiometricData.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/21/21.
//

import Foundation
import LocalAuthentication
import UIKit

class Biometrics : NSObject {

    static let shared = Biometrics()
   
    //MARK: - CHECK IF THE USER HAS BIOMETRICS ENABLES ON THEIR DEVICE OR TOUCH
    func biometricAuth(completion : @escaping (_ isComplete : Bool) -> ()) {
       let context = LAContext()
       var error: NSError?

       if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
           let reason = "Authentication"

           context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
               [] success, authenticationError in

               DispatchQueue.main.async {
                   if success {
                    //MARK: - USER DOES HAVE BIOMETRICS ENABLED
                    completion(true)
                   } else {
                    //MARK: - USER DOES HAVE BIOMETRICS ENABLED BUT IT FAILED RECOGNITION
                       completion(false)
                   }
               }
           }
       } else {
        //MARK: - USER DOES NOT HAVE BIOMETRICS OR HAS THEM DISABLED
        completion(false)
       }
   }
}
