//
//  NewDogFive.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/28/21.
//

import Foundation
import UIKit

class NewDogSix : UIViewController {
    
    lazy var profilePhoto : UIImageView = {
        
        let pv = UIImageView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = .clear
        pv.isUserInteractionEnabled = true
        pv.clipsToBounds = false
        pv.layer.masksToBounds = true
        pv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        pv.layer.shadowOpacity = 0.05
        pv.layer.shadowOffset = CGSize(width: 2, height: 3)
        pv.layer.shadowRadius = 9
        pv.layer.shouldRasterize = false
        pv.layer.masksToBounds = true
        pv.layer.borderColor = coreOrangeColor.cgColor
        pv.layer.borderWidth = 1.5
        
        return pv
    }()
    
    let profileLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "<name> Profile Created"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .center
        nl.numberOfLines = 1
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let profileSubHeaderLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.font = UIFont(name: rubikRegular, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .center
        nl.numberOfLines = 3
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var bookNowButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 18
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreWhiteColor
        cbf.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cbf.layer.shadowOpacity = 0.2
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 4
        cbf.layer.shouldRasterize = false
        
        
        let str = String.fontAwesomeIcon(name: .calendarPlus) + "   Book now"
        let attributedStr = NSMutableAttributedString(string: str)
        
        let range1 = NSRange(location: 0, length: 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.fontAwesome(ofSize: 18, style: .solid),
                                   range: range1)
        
        let range2 = NSRange(location: 1, length: (str as NSString).length - 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont(name: dsHeaderFont, size: 18)!,
                                   range: range2)
        
        cbf.setAttributedTitle(attributedStr, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBookNow), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var addAnotherPupButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Add another pup", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.addTarget(self, action: #selector(self.handleAddNewPup), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var returnToDashboard : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Return to Dashboard", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 16)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dsGreyMedium
        cbf.backgroundColor = .clear
        cbf.tintColor = dsGreyMedium
        cbf.addTarget(self, action: #selector(self.handleReturnToDashboard), for: .touchUpInside)
        
        return cbf
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        self.fillValues()
    }
    
    func fillValues() {
        
        let dogsName = globalNewDogBuilder.dogBuilderName ?? "Dog"
        self.profileLabel.text = "\(dogsName)'s Profile Created"
        self.profileSubHeaderLabel.text = "Welcome, \(dogsName)! Get ready to get the Doggystyle treatment!"
        
        let image = globalNewDogBuilder.dogBuilderProfileImage ?? UIImage(named: "doggy_profile_filler")?.withRenderingMode(.alwaysOriginal)
        self.profilePhoto.image = image
        
        if groomLocationFollowOnRoute == .fromRegistration {
            self.returnToDashboard.setTitle("Go to Dashboard", for: .normal)
        } else {
            self.returnToDashboard.setTitle("Return to Dashboard", for: .normal)
        }
        
        let locational_data = userProfileStruct.user_grooming_locational_data ?? ["nil" : "nil"]
        let hasGroomingLocation = locational_data["found_grooming_location"] as? Bool ?? false
        
        //IF WE DO SERVICE THE CLIENTS LOCATION, WE ENABLE THE BOOK NOW BUTTON
        if hasGroomingLocation == true {
            self.bookNowButton.isHidden = false
        } else {
        //IF WE DO NOT SERVICE THE CLIENTS LOCATION, WE CANNOT BOOK THEM AN APT
            self.bookNowButton.isHidden = true
        }
    }
    
    func addViews() {
        
        self.view.addSubview(self.profilePhoto)
        self.view.addSubview(self.profileLabel)
        self.view.addSubview(self.profileSubHeaderLabel)
        
        self.view.addSubview(self.bookNowButton)
        self.view.addSubview(self.addAnotherPupButton)
        self.view.addSubview(self.returnToDashboard)
        
        self.profilePhoto.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 180).isActive = true
        self.profilePhoto.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.profilePhoto.heightAnchor.constraint(equalToConstant: 130).isActive = true
        self.profilePhoto.widthAnchor.constraint(equalToConstant: 130).isActive = true
        self.profilePhoto.layer.cornerRadius = 130 / 2
        
        self.profileLabel.topAnchor.constraint(equalTo: self.profilePhoto.bottomAnchor, constant: 14).isActive = true
        self.profileLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.profileLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.profileLabel.sizeToFit()
        
        self.profileSubHeaderLabel.topAnchor.constraint(equalTo: self.profileLabel.bottomAnchor, constant: 14).isActive = true
        self.profileSubHeaderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.profileSubHeaderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.profileSubHeaderLabel.sizeToFit()
        
        self.bookNowButton.topAnchor.constraint(equalTo: self.profileSubHeaderLabel.bottomAnchor, constant: 50).isActive = true
        self.bookNowButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.bookNowButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.bookNowButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.addAnotherPupButton.topAnchor.constraint(equalTo: self.bookNowButton.bottomAnchor, constant: 20).isActive = true
        self.addAnotherPupButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.addAnotherPupButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.addAnotherPupButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.returnToDashboard.topAnchor.constraint(equalTo: self.addAnotherPupButton.bottomAnchor, constant: 20).isActive = true
        self.returnToDashboard.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.returnToDashboard.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.returnToDashboard.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
   
    //MARK: - RETURN OR GO TO DASHBOARD
    @objc func handleReturnToDashboard() {
        
        if groomLocationFollowOnRoute == .fromApplication {
        UIDevice.vibrateLight()
        self.navigationController?.dismiss(animated: true, completion: nil)
        } else if groomLocationFollowOnRoute == .fromRegistration {
            self.presentHomeController()
        }
    }
    
    //MARK: - HANDLE ADD NEW PUP
    @objc func handleAddNewPup() {
        
        if groomLocationFollowOnRoute == .fromApplication {

        self.navigationController?.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Statics.CALL_ADD_NEW_PUP), object: self)
        })
        
        } else if groomLocationFollowOnRoute == .fromRegistration {
            let homeVC = HomeViewController()
            let navVC = UINavigationController(rootViewController: homeVC)
            navVC.modalPresentationStyle = .fullScreen
            navigationController?.present(navVC, animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Statics.CALL_ADD_NEW_PUP), object: self)
            })
        }
    }
    
    //MARK: - HANDLE ADD NEW PUP
    @objc func handleBookNow() {
        
        if groomLocationFollowOnRoute == .fromApplication {

        self.navigationController?.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Statics.CALL_BOOK_NOW), object: self)
        })
        
        } else if groomLocationFollowOnRoute == .fromRegistration {
            let homeVC = HomeViewController()
            let navVC = UINavigationController(rootViewController: homeVC)
            navVC.modalPresentationStyle = .fullScreen
            navVC.navigationBar.isHidden = true
            self.navigationController?.present(navVC, animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Statics.CALL_BOOK_NOW), object: self)
            })
        }
    }
    
    func presentHomeController() {
        let homeVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: homeVC)
        navVC.modalPresentationStyle = .fullScreen
        navVC.navigationBar.isHidden = true
        self.navigationController?.present(navVC, animated: true)
        
    }
}
