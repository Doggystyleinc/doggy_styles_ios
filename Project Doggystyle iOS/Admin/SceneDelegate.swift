//
//  SceneDelegate.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 5/17/21.
//

import UIKit
import TinyConstraints

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?,
        counter : Int = 0
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        //MARK: - INITIAL ENTRY INTO THE APPLICATION
        guard let sceneWindow = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: sceneWindow)
        window.makeKeyAndVisible()
        
        //MARK: - DEMO CONTROLLERS FROM LAST WEEK
        
        /*
         DecisionController
         GroomerConfirmation
         GroomerTimeLineController
         ApointmentReportController
         CancelAptController
         */
        
        let decisionController = DecisionController()
        let navigationController = UINavigationController(rootViewController: decisionController)
        
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .dsOrange
        
        window.rootViewController = navigationController
        
        self.window = window
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {

        self.counter += 1
        
        if self.counter > 1 {
        //APPLICATION - IS PUSHED TO THE FOREGROUND FROM ANY STATE
        NotificationCenter.default.post(name: NSNotification.Name(Statics.RUN_LOCATION_CHECKER), object: nil)
            
        }
    }
}

