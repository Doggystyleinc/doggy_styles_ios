//
//  ProfileViewController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 5/28/21.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    var homeController: HomeViewController?
    private let containerHeight: CGFloat = 70
    private let spacing: CGFloat = 22
    private let iconSize: CGFloat = 24
    
    private let rightIcon = DSNavButton(imageName: Constants.signOutNavIcon)
    private let logo = LogoImageView(frame: .zero)
    
    private let dogIcon = UIImage(named: Constants.dogIcon)?.withTintColor(.dsOrange)
    private let paymentIcon = UIImage(named: Constants.paymentIcon)?.withTintColor(.dsOrange)
    private let contactIcon = UIImage(named: Constants.contactIcon)?.withTintColor(.dsOrange)
    private let refurIcon = UIImage(named: Constants.refurIcon)?.withTintColor(.dsOrange)

    private let nameContainer = DSContainerView(frame: .zero)
    private let petContainer = DSContainerView(frame: .zero)
    private let paymentContainer = DSContainerView(frame: .zero)
    private let contactUsContainer = DSContainerView(frame: .zero)
    private let refurContainer = DSContainerView(frame: .zero)
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Annie Schultz"
        label.font = UIFont.poppinsBold(size: 20)
        label.textColor = .dsTextColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
       return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        addNavViews()
        addContainers()
        addContainerViews()
        addTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fetchJSON()
    }
}

//MARK: - Configure View Controller
extension ProfileViewController {
    private func configureVC() {
        view.backgroundColor = .dsViewBackground
    }
}

//MARK: - Configure Views
extension ProfileViewController {
    private func addNavViews() {
        self.view.addSubview(logo)
        logo.topToSuperview(offset: 26, usingSafeArea: true)
        logo.centerX(to: view)
        
        self.view.addSubview(rightIcon)
        rightIcon.leftToRight(of: logo, offset: 70)
        rightIcon.topToSuperview(offset: 14, usingSafeArea: true)
    }
    
    private func addContainers() {
        self.view.addSubview(nameContainer)
        nameContainer.height(136)
        nameContainer.left(to: view, offset: 30)
        nameContainer.right(to: view, offset: -30)
        nameContainer.topToBottom(of: rightIcon, offset: 96)
        
        self.view.addSubview(petContainer)
        petContainer.height(containerHeight)
        petContainer.left(to: nameContainer)
        petContainer.right(to: nameContainer)
        petContainer.topToBottom(of: nameContainer, offset: spacing)
        
        self.view.addSubview(paymentContainer)
        paymentContainer.height(containerHeight)
        paymentContainer.left(to: nameContainer)
        paymentContainer.right(to: nameContainer)
        paymentContainer.topToBottom(of: petContainer, offset: spacing)
        
        self.view.addSubview(contactUsContainer)
        contactUsContainer.height(containerHeight)
        contactUsContainer.left(to: nameContainer)
        contactUsContainer.right(to: nameContainer)
        contactUsContainer.topToBottom(of: paymentContainer, offset: spacing)
        
        self.view.addSubview(refurContainer)
        refurContainer.height(containerHeight)
        refurContainer.left(to: nameContainer)
        refurContainer.right(to: nameContainer)
        refurContainer.topToBottom(of: contactUsContainer, offset: spacing)
    }
    
    private func addContainerViews() {
        let petLabel = DSBoldLabel(title: "My dogs", size: 16)
        let petImageView = UIImageView(image: dogIcon)
        petImageView.contentMode = .scaleAspectFit
        
        petContainer.addSubview(petImageView)
        petImageView.height(iconSize)
        petImageView.width(iconSize)
        petImageView.left(to: petContainer, offset: 26)
        petImageView.centerY(to: petContainer)
        
        petContainer.addSubview(petLabel)
        petLabel.leftToRight(of: petImageView, offset: 20)
        petLabel.centerY(to: petImageView)
        
        let paymentLabel = DSBoldLabel(title: "Payment", size: 16)
        let paymentImageView = UIImageView(image: paymentIcon)
        paymentImageView.contentMode = .scaleAspectFit
        
        paymentContainer.addSubview(paymentImageView)
        paymentImageView.height(iconSize)
        paymentImageView.width(iconSize)
        paymentImageView.left(to: paymentContainer, offset: 26)
        paymentImageView.centerY(to: paymentContainer)
        
        paymentContainer.addSubview(paymentLabel)
        paymentLabel.leftToRight(of: paymentImageView, offset: 20)
        paymentLabel.centerY(to: paymentImageView)
        
        let contactLabel = DSBoldLabel(title: "Contact Us", size: 16)
        let contactImageView = UIImageView(image: contactIcon)
        contactImageView.contentMode = .scaleAspectFit
        
        contactUsContainer.addSubview(contactImageView)
        contactImageView.height(iconSize)
        contactImageView.width(iconSize)
        contactImageView.left(to: contactUsContainer, offset: 26)
        contactImageView.centerY(to: contactUsContainer)
        
        contactUsContainer.addSubview(contactLabel)
        contactLabel.leftToRight(of: contactImageView, offset: 20)
        contactLabel.centerY(to: contactImageView)
        
        let refurLabel = DSBoldLabel(title: "Re-fur a Friend", size: 16)
        let refurImageView = UIImageView(image: refurIcon)
        refurImageView.contentMode = .scaleAspectFit
        
        refurContainer.addSubview(refurImageView)
        refurImageView.height(iconSize)
        refurImageView.width(iconSize)
        refurImageView.left(to: refurContainer, offset: 26)
        refurImageView.centerY(to: refurContainer)
        
        refurContainer.addSubview(refurLabel)
        refurLabel.leftToRight(of: refurImageView, offset: 20)
        refurLabel.centerY(to: refurImageView)
    }
}

//MARK: - @objc Methods
extension ProfileViewController {
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            return
        }

        Database.database().reference().removeAllObservers()

        let decisionController = DecisionController()
        let nav = UINavigationController(rootViewController: decisionController)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    @objc func didTapView(_ sender: UIButton) {
        print("Sender Tag - \(sender.tag)")
    }
}

//MARK: - Helpers
extension ProfileViewController {
    //GOOD IDEA TO CHECK THIS EVERYTIME THE VIEW LOADS, INCASE THEY CHANGE THEIR PHOTO, NAME ETC.
    func fetchJSON() {
        //DATA SHOULD BE FILLED ON APPLICATION LOAD AFTER AUTHENTICATION OR SIGN IN
        let userName = userProfileStruct.userName ?? "Pet Lover"
        self.nameLabel.text = userName
        
        //THROW A DEFAULT PHOTO IN STORAGE AND GRAB THE URL THEN REPLACE "nil" WITH THE URL
//        let userProfilePhoto = userProfileStruct.profileURL ?? "nil"
//        self.profileImageView.loadImageGeneralUse(userProfilePhoto)
        
    }
    
    private func addTargets() {
        rightIcon.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }
}
