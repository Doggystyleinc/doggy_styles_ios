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
    private let iconLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "DS App Icon")!)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeholderLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "DS Logo")!)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .dsViewBackground
        NetworkMonitor.shared.startMonitoring()
        self.authenticationCheck()
        self.addLogoView()
    }
}

//MARK: - Layout Views
extension DecisionController {
    private func addLogoView() {
        self.view.addSubview(iconLogo)
        iconLogo.centerX(to: view)
        iconLogo.centerY(to: view, offset: -50)
        
        self.view.addSubview(placeholderLogo)
        placeholderLogo.topToBottom(of: iconLogo, offset: 12)
        placeholderLogo.left(to: view, offset: 31.0)
        placeholderLogo.right(to: view, offset: -31.0)
    }
}

//MARK: - Authentication Checks
extension DecisionController {
    
    private func authenticationCheck() {
        let auth = Auth.auth().currentUser?.uid ?? nil
        
        //USER IS NOT AUTHENTICATED
        if auth == nil {
            self.perform(#selector(presentSignUpController), with: nil, afterDelay: 1.0)
            
            //USER IS AUTHENTICATED
        } else if auth != nil {
            //DOUBLE CHECK A NODE UNDER ALL USERS TO MAKE SURE IT EXISTS-> WE CAN ROUTE HERE AND AUTOFILL THEIR DATA
            Service.shared.authCheck { (hasAuth) in
                if hasAuth {
                    Service.shared.fetchCurrentUser()
                    self.perform(#selector(self.presentHomeController), with: nil, afterDelay: 1.0)
                } else {
                    guard let userEmail = Auth.auth().currentUser?.email else { return }
                    Service.shared.updateAllUsers(usersEmail: userEmail, userSignInMethod: Constants.email) { success in
                        self.perform(#selector(self.presentHomeController), with: nil, afterDelay: 1.0)
                    }
                }
            }
        }
    }
}

//MARK: - @objc Functions
extension DecisionController {
    @objc func presentHomeController() {
        let homeVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: homeVC)
        
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
    
    @objc func presentSignUpController() {
        let signUpVC = SignUpViewController()
        let navVC = UINavigationController(rootViewController: signUpVC)
        
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
}
