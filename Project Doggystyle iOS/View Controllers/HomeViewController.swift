//
//  HomeViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/3/21.
//

import UIKit
import Firebase

final class HomeViewController: UIViewController {
    lazy private var signOutButton : UIButton = {
        let sob = UIButton(type: .system)
        let buttonTitle = NSLocalizedString("LogOut", comment: "Log Out")
        sob.translatesAutoresizingMaskIntoConstraints = false
        sob.backgroundColor = .orange
        sob.setTitle(buttonTitle, for: .normal)
        sob.addTarget(self, action: #selector(self.handleLogOut), for: .touchUpInside)
        return sob
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemTeal
        self.addViews()
        Service.shared.fetchCurrentUser()
    }
}


//MARK: - Configure Views
extension HomeViewController {
    private func addViews() {
        self.view.addSubview(self.signOutButton)
        self.signOutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        self.signOutButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.signOutButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.signOutButton.heightAnchor.constraint(equalToConstant: self.view.frame.height / 10).isActive = true
    }
}


//MARK: - @objc Functions
extension HomeViewController {
    @objc func handleLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        //Logging out, remove all database observers.
        Database.database().reference().removeAllObservers()

        let decisionController = DecisionController()
        let nav = UINavigationController(rootViewController: decisionController)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
}
