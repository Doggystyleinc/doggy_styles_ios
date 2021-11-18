//
//  AppDelegate.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/17/21.
//

import UIKit
import Firebase
import SDWebImage
import GoogleSignIn
import GooglePlaces
import GoogleMaps
import FBSDKCoreKit
import NotificationCenter
import AVFoundation


@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = false
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        //MARK: - GOOGLE PLACES KEY
        GMSPlacesClient.provideAPIKey("AIzaSyCsQHp5h7ReANC8G4hSJ3xFF-unyiSfgBs")
      
        //MARK: - GOOGLE MAPS KEY
        GMSServices.provideAPIKey("AIzaSyD3yW8pu0esbp5zZTdBd-i--qEm1e1DxyY")
        
        //MARK: - FACEBOOK CALLBACK
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions:
            launchOptions
        )
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
        })
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       
        //MARK: - FACEBOOK CALLBACK
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            options: options
        )
    }
  
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    //MARK: - CALLED WHEN THE APNS ARE ASSIGNED A DEVICE TOKEN - USING THE NEW INSTANCE ID FOR FIREBASE 2.1.0^
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        var secondToken : String = ""
        
        //MARK: - ROTATION MOVING FORWARD IS GOING TO BE DIFFICULT, THE COIN ROTATES AS OF IOS 14
        guard let identifierForVendor = UIDevice.current.identifierForVendor else {
            return
        }
        
        //MARK: - DEVICE IDENTIFIER
        let deviceIdentifier = identifierForVendor.uuidString,
            stringAsNS = NSString(string: deviceIdentifier)
        
        //MARK: - PREVIOUS INSTANCE ID METHOD WAS DEPRECATED, THIS IS THE REPLACEMENT WITH A HANDLER
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching token from Firebase Messaging: \(error)")
                return
            } else if let token = token {
                secondToken = token
                
                Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.unknown)
                
                if Auth.auth().currentUser?.uid != nil {
                    
                    if secondToken.count > 10 {
                        
                        guard let userUid = Auth.auth().currentUser?.uid else { return }
                        let dataBaseRef = Database.database().reference()
                        
                        let value : [String : Any] = ["users_push_token" : secondToken, "users_device_UDID" : stringAsNS]
                        
                        userProfileStruct.usersPushToken = secondToken
                        userProfileStruct.deviceUDID = deviceIdentifier
                        
                        dataBaseRef.child("all_users").child(userUid).updateChildValues(value, withCompletionBlock: { (error, ref) in
                            if error != nil {
                                print("Error with storing/updating user token",error?.localizedDescription as Any)
                            }
                        })
                    }
                }
            }
        }
    }
}
