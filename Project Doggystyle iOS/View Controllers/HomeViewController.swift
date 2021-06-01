//
//  HomeViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/3/21.
//

import UIKit
import Firebase

final class HomeViewController: UIViewController {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 57
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.tag = 0
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let uploadVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 1
        button.setTitle("Upload Video", for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.leftImage(image: UIImage(systemName: "video.bubble.left.fill")!, renderMode: .alwaysTemplate)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let uploadDocumentButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 2
        button.setTitle("Upload Document", for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.leftImage(image: UIImage(systemName: "doc.fill.badge.plus")!, renderMode: .alwaysTemplate)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let uploadImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 3
        button.setTitle("Upload Image", for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.leftImage(image: UIImage(systemName: "photo.fill")!, renderMode: .alwaysTemplate)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private var signOutButton : UIButton = {
        let sob = UIButton(type: .system)
        let buttonTitle = NSLocalizedString("LogOut", comment: "Log Out")
        sob.backgroundColor = .orange
        sob.tintColor = .white
        sob.setTitle(buttonTitle, for: .normal)
        sob.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        sob.layer.cornerRadius = 5.0
        return sob
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.addViews()
    }
}


//MARK: - Configure Views
extension HomeViewController {
    private func addViews() {
        self.view.addSubview(profileImageView)
        profileImageView.height(114)
        profileImageView.width(114)
        profileImageView.top(to: view, offset: 150)
        profileImageView.centerX(to: view)
        
        self.view.addSubview(addButton)
        addButton.topToBottom(of: profileImageView, offset: -18)
        addButton.centerX(to: profileImageView)
        addButton.height(34)
        addButton.width(34)
        
        self.view.addSubview(uploadVideoButton)
        uploadVideoButton.topToBottom(of: addButton, offset: 60)
        uploadVideoButton.height(44)
        uploadVideoButton.width(200)
        uploadVideoButton.centerX(to: view)
        
        self.view.addSubview(uploadDocumentButton)
        uploadDocumentButton.topToBottom(of: uploadVideoButton, offset: 30)
        uploadDocumentButton.height(44)
        uploadDocumentButton.width(200)
        uploadDocumentButton.centerX(to: view)
        
        self.view.addSubview(uploadImageButton)
        uploadImageButton.topToBottom(of: uploadDocumentButton, offset: 30)
        uploadImageButton.height(44)
        uploadImageButton.width(200)
        uploadImageButton.centerX(to: view)
        
        self.view.addSubview(signOutButton)
        signOutButton.bottom(to: view, offset: -50)
        signOutButton.height(44)
        signOutButton.width(160)
        signOutButton.centerX(to: view)
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
        
        //LOGGING OUT, REMOVE ALL THE DATABASE OBSERVERS
        Database.database().reference().removeAllObservers()

        let decisionController = DecisionController()
        let nav = UINavigationController(rootViewController: decisionController)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("Upload Profile Tapped!")
        case 1:
            print("Upload Video Tapped!")
        case 2:
            print("Upload Document Tapped!")
        case 3:
            print("Upload Image Tapped!")
        default:
            break
        }
    }
}
