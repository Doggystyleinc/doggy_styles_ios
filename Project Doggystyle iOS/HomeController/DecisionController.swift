//
//  ViewController.swift
//  Project Doggystyle
//
//  Created by Charlie Arcodia on 5/3/21.
//

/*
 From here, Auth is decided and routed accordingly.
 */

import UIKit
import Firebase

final class DecisionController: UIViewController {
    
    private let backgroundImage: UIImageView = {
        
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "splash_screen")?.withRenderingMode(.alwaysOriginal)
        iv.image = image
        iv.contentMode = .scaleAspectFill
        
        return iv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .dsViewBackground
        NetworkMonitor.shared.startMonitoring()
        self.addViews()
        self.authenticationCheck()
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let insetsTop = self.view.window?.safeAreaInsets.top else {return}
        guard let insetsBottom = self.view.window?.safeAreaInsets.bottom else {return}
        
        globalFooterHeight = insetsBottom
        globalStatusBarHeight = insetsTop
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.backgroundImage)
        
        self.backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func authenticationCheck() {
       
        let auth = Auth.auth().currentUser?.uid ?? nil
        
        //USER IS NOT AUTHENTICATED
        if auth == nil {
            self.perform(#selector(self.presentWelcomeController), with: nil, afterDelay: 1.0)
            //USER IS AUTHENTICATED
        } else if auth != nil {
            //DOUBLE CHECK A NODE UNDER ALL USERS TO MAKE SURE IT EXISTS-> WE CAN ROUTE HERE AND AUTOFILL THEIR DATA
            Service.shared.authCheck { (hasAuth) in
                if hasAuth {
                    //MARK: - USER HAS AUTH AND IS FOUND IN OUR SYSTEM
                    Service.shared.fetchCurrentUserData { isComplete in
                        
                        if isComplete == true {
                            self.perform(#selector(self.presentHomeController), with: nil, afterDelay: 1.0)
                        } else {
                            self.perform(#selector(self.presentWelcomeController), with: nil, afterDelay: 1.0)
                        }
                    }
                } else {
                    //MARK: - USER HAS AUTH BUT WAS DELETED FROM OUR SYSTEM
                    Service.shared.handleFirebaseLogout()
                    self.perform(#selector(self.presentWelcomeController), with: nil, afterDelay: 1.0)
                }
            }
        }
    }
    
    @objc func presentHomeController() {
        
        groomLocationFollowOnRoute = .fromApplication

        let homeVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: homeVC)
        navVC.modalPresentationStyle = .fullScreen
        navVC.navigationBar.isHidden = true
        navigationController?.present(navVC, animated: true)
    }
    
    @objc func presentWelcomeController() {
        
        let signUpVC = WelcomePageController()
        let navVC = UINavigationController(rootViewController: signUpVC)
        navVC.modalPresentationStyle = .fullScreen
        navVC.navigationBar.isHidden = true
        navigationController?.present(navVC, animated: true)
    }
}
