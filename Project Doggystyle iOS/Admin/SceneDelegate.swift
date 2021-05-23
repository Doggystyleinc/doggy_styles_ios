//
//  SceneDelegate.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/17/21.
//

import UIKit
import TinyConstraints

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
          //MARK: - INITIAL ENTRY INTO THE APPLICATION
          guard let sceneWindow = (scene as? UIWindowScene) else { return }
          
          let window = UIWindow(windowScene: sceneWindow)
          window.makeKeyAndVisible()
          
          let decisionController = RequestUserLocationViewController() //Temp
//          let decisionController = DecisionController()
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
          UINavigationBar.appearance().tintColor = .black
          
          window.rootViewController = navigationController
          self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

