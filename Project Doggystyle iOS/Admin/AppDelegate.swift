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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = false
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        //GOOGLE PLACES KEY
        GMSPlacesClient.provideAPIKey("AIzaSyBBe3beW4gVBST98T2oHFdqrNeCJV-GWKM")
        
        //GOOGLE MAPS KEY
        GMSServices.provideAPIKey("AIzaSyD0QooK2JJuDUBU0MSlRBLU0FT3STJoFVw")
        
        //FACEBOOK CALLBACK
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions:
            launchOptions
        )
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       
        //FACEBOOK CALLBACK
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            options: options
        )
    }
  
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
