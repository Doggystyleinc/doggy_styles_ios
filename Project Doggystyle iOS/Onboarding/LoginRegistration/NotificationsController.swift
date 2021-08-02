//
//  NotificationsController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/1/21.
//

import Foundation
import UIKit
import UserNotifications


class NotificationsController : UIViewController, UNUserNotificationCenterDelegate {
    
    lazy var backButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = UIColor.dsOrange
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        cbf.isHidden = true
        return cbf
        
    }()
    
    let dsCompanyLogoImage : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = false
        let image = UIImage(named: Constants.dsLogo)?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Don't miss a message\nfrom your Doggystylist"
        hl.font = UIFont(name: dsHeaderFont, size: 32)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        
        return hl
    }()
    
    lazy var enableNotificationsButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Enable Notifications", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 18
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.addTarget(self, action: #selector(self.handleEnableNotifications), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var disableNotificationsButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Disable Notifications", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 18
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreOrangeColor
        cbf.backgroundColor = coreOrangeColor.withAlphaComponent(0.1)
        cbf.addTarget(self, action: #selector(self.handleDisableNotifications), for: .touchUpInside)
        
        return cbf
        
    }()
    
    let dogImage : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFit
        vi.isUserInteractionEnabled = false
        let image = UIImage(named: "vehicle_image")?.withRenderingMode(.alwaysOriginal)
        vi.image = image
        
       return vi
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.dsCompanyLogoImage)
        self.view.addSubview(self.headerLabel)
        
        self.view.addSubview(self.enableNotificationsButton)
        self.view.addSubview(self.disableNotificationsButton)
        
        self.view.addSubview(self.dogImage)

        self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 57).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 11).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.dsCompanyLogoImage.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        self.headerLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 90).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.disableNotificationsButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
        self.disableNotificationsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.disableNotificationsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.disableNotificationsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.enableNotificationsButton.bottomAnchor.constraint(equalTo: self.disableNotificationsButton.topAnchor, constant: -20).isActive = true
        self.enableNotificationsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.enableNotificationsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.enableNotificationsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.dogImage.bottomAnchor.constraint(equalTo: self.enableNotificationsButton.topAnchor, constant: -30).isActive = true
        self.dogImage.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 30).isActive = true
        self.dogImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.dogImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true

    }
    
    @objc func handleEnableNotifications() {
        
        let center  = UNUserNotificationCenter.current()
          center.delegate = self
          center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                   DispatchQueue.main.async(execute: {
                      UIApplication.shared.registerForRemoteNotifications()
                      self.handleConfirmButton()
                   })
                }
             }
          }
    
    @objc func handleConfirmButton() {
        
        //FROM HERE WE NEED TO GO THROUGH THE LOCATION SCREENS
        let homeVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: homeVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
        
    }
    
    @objc func handleDisableNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
        self.handleConfirmButton()
    }
}
