//
//  SceneDelegate.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 5/17/21.
//

import UIKit
import TinyConstraints

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let sceneWindow = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: sceneWindow)
        window.makeKeyAndVisible()
        
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
}

