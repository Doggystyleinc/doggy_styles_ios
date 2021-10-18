//
//  ReferralMonetaryController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/15/21.
//

import Foundation
import UIKit

class ReferralMonetaryController : UIViewController, CustomAlertCallBackProtocol {
    
    lazy var backButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = UIColor.dsOrange
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let earnLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Re-fur a Friend!"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let descriptionLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Re-fur a friend to the TLC and convenience of Doggystyle’s mobile grooming services. "
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    var bottomContainer : UIView = {
        
        let bc = UIView()
        bc.translatesAutoresizingMaskIntoConstraints = false
        bc.backgroundColor = coreWhiteColor
        bc.isUserInteractionEnabled = true
        bc.layer.masksToBounds = true
        bc.layer.cornerRadius = 15
        bc.clipsToBounds = false
        bc.layer.masksToBounds = false
        bc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        bc.layer.shadowOpacity = 0.05
        bc.layer.shadowOffset = CGSize(width: 2, height: 3)
        bc.layer.shadowRadius = 9
        bc.layer.shouldRasterize = false
        
       return bc
    }()
    
    var greyDividerLine : UIView = {
        
        let gdl = UIView()
        gdl.translatesAutoresizingMaskIntoConstraints = false
        gdl.backgroundColor = lightGrey
        return gdl
    }()
    
    let doggyDollarsLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "Doggy Dollars"
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let doggyCurrencyLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "$0"
        thl.font = UIFont(name: rubikMedium, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let pendingLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "Pending"
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let pendingCurrencyLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "$0"
        thl.font = UIFont(name: rubikMedium, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    lazy var upArrowButton : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 17, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .paperPlane), for: .normal)
        cbf.setTitleColor(coreOrangeColor, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleUpArrow), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let referralsLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Referrals"
        thl.font = UIFont(name: rubikMedium, size: 20)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreOrangeColor
        return thl
        
    }()
    
    let shareContainer : UIView = {
        
        let sc = UIView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .clear
        sc.layer.cornerRadius = 15
        sc.layer.borderWidth = 1
        sc.layer.borderColor = coreOrangeColor.cgColor
        sc.clipsToBounds = true
        
       return sc
    }()
    
    lazy var shareButton : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = coreOrangeColor
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .share), for: .normal)
        cbf.setTitleColor(coreWhiteColor, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleShareCodeButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let shareCodeLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = ""
        thl.font = UIFont(name: rubikMedium, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let rewardsLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Share to earn rewards"
        thl.font = UIFont(name: rubikMedium, size: 20)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreOrangeColor
        return thl
        
    }()
    
    let dogImage : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = false
        let image = UIImage(named: "referral_dog_image")?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        self.fillValues()
    }
    
    func fillValues() {
        
        let referralCode = userProfileStruct.referral_code_grab ?? "nil"
        
        if referralCode == "nil" {
            self.handleCustomPopUpAlert(title: "Error", message: "Well this is weird – your custom referral code has vanished. We were just alerted, we’ll have a fix out shortly. Thank you.", passedButtons: [Statics.GOT_IT])
        } else {
            self.shareCodeLabel.text = "\(referralCode)"
        }
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.earnLabel)
        self.view.addSubview(self.descriptionLabel)
        self.view.addSubview(self.bottomContainer)
        
        self.bottomContainer.addSubview(self.greyDividerLine)
        self.bottomContainer.addSubview(self.doggyDollarsLabel)
        self.bottomContainer.addSubview(self.pendingLabel)
        self.bottomContainer.addSubview(self.doggyCurrencyLabel)
        self.bottomContainer.addSubview(self.pendingCurrencyLabel)
        self.bottomContainer.addSubview(self.upArrowButton)
        
        self.view.addSubview(self.referralsLabel)
        self.view.addSubview(self.shareContainer)
        
        self.shareContainer.addSubview(self.shareButton)
        self.shareContainer.addSubview(self.shareCodeLabel)
        
        self.view.addSubview(self.rewardsLabel)
        self.view.addSubview(self.dogImage)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.earnLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 23).isActive = true
        self.earnLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.earnLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.earnLabel.sizeToFit()
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.earnLabel.bottomAnchor, constant: 29).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.descriptionLabel.sizeToFit()
        
        self.bottomContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -47).isActive = true
        self.bottomContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.bottomContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.bottomContainer.heightAnchor.constraint(equalToConstant: 133).isActive = true
        
        self.greyDividerLine.centerXAnchor.constraint(equalTo: self.bottomContainer.centerXAnchor, constant: 0).isActive = true
        self.greyDividerLine.topAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: 17).isActive = true
        self.greyDividerLine.bottomAnchor.constraint(equalTo: self.bottomContainer.bottomAnchor, constant: -17).isActive = true
        self.greyDividerLine.widthAnchor.constraint(equalToConstant: 1.5).isActive = true

        self.doggyDollarsLabel.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 8).isActive = true
        self.doggyDollarsLabel.rightAnchor.constraint(equalTo: self.greyDividerLine.leftAnchor, constant: -8).isActive = true
        self.doggyDollarsLabel.topAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: 34).isActive = true
        self.doggyDollarsLabel.sizeToFit()
        
        self.pendingLabel.rightAnchor.constraint(equalTo: self.bottomContainer.rightAnchor, constant: -8).isActive = true
        self.pendingLabel.leftAnchor.constraint(equalTo: self.greyDividerLine.rightAnchor, constant: 8).isActive = true
        self.pendingLabel.topAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: 34).isActive = true
        self.pendingLabel.sizeToFit()
        
        self.doggyCurrencyLabel.topAnchor.constraint(equalTo: self.doggyDollarsLabel.bottomAnchor, constant: 14).isActive = true
        self.doggyCurrencyLabel.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 10).isActive = true
        self.doggyCurrencyLabel.rightAnchor.constraint(equalTo: self.greyDividerLine.leftAnchor, constant: -10).isActive = true
        self.doggyCurrencyLabel.sizeToFit()
        
        self.pendingCurrencyLabel.topAnchor.constraint(equalTo: self.pendingLabel.bottomAnchor, constant: 14).isActive = true
        self.pendingCurrencyLabel.rightAnchor.constraint(equalTo: self.bottomContainer.rightAnchor, constant: -10).isActive = true
        self.pendingCurrencyLabel.leftAnchor.constraint(equalTo: self.greyDividerLine.rightAnchor, constant: 10).isActive = true
        self.pendingCurrencyLabel.sizeToFit()
        
        self.upArrowButton.rightAnchor.constraint(equalTo: self.bottomContainer.rightAnchor, constant: -13).isActive = true
        self.upArrowButton.topAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: 13).isActive = true
        self.upArrowButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.upArrowButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.referralsLabel.bottomAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: -24).isActive = true
        self.referralsLabel.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 0).isActive = true
        self.referralsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        self.referralsLabel.sizeToFit()
        
        self.shareContainer.bottomAnchor.constraint(equalTo: self.referralsLabel.topAnchor, constant: -14).isActive = true
        self.shareContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.shareContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.shareContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.shareButton.rightAnchor.constraint(equalTo: self.shareContainer.rightAnchor, constant: 0).isActive = true
        self.shareButton.topAnchor.constraint(equalTo: self.shareContainer.topAnchor, constant: 0).isActive = true
        self.shareButton.bottomAnchor.constraint(equalTo: self.shareContainer.bottomAnchor, constant: 0).isActive = true
        self.shareButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        
        self.shareCodeLabel.centerYAnchor.constraint(equalTo: self.shareContainer.centerYAnchor, constant: 0).isActive = true
        self.shareCodeLabel.leftAnchor.constraint(equalTo: self.shareContainer.leftAnchor, constant: 20).isActive = true
        self.shareCodeLabel.rightAnchor.constraint(equalTo: self.shareButton.leftAnchor, constant: -20).isActive = true
        self.shareCodeLabel.sizeToFit()
        
        self.rewardsLabel.bottomAnchor.constraint(equalTo: self.shareContainer.topAnchor, constant: -14).isActive = true
        self.rewardsLabel.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 0).isActive = true
        self.rewardsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        self.rewardsLabel.sizeToFit()
        
        self.dogImage.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 10).isActive = true
        self.dogImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.dogImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        self.dogImage.bottomAnchor.constraint(equalTo: self.rewardsLabel.topAnchor, constant: -10).isActive = true
        
    }
    
    @objc func handleBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUpArrow() {
        print("here we go")
    }
    
    @objc func handleShareCodeButton() {
        print("share code button")
    }
    
    
    @objc func handleCustomPopUpAlert(title : String, message : String, passedButtons: [String]) {
        
        let alert = AlertController()
        alert.passedTitle = title
        alert.passedMmessage = message
        alert.passedButtonSelections = passedButtons
        alert.customAlertCallBackProtocol = self
        alert.passedIconName = .infoCircle
        alert.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    func onSelectionPassBack(buttonTitleForSwitchStatement type: String) {
        
        switch type {
        
        case Statics.GOT_IT: self.handleBackButton()
        case Statics.OK: print(Statics.OK)
            
        default: print("Should not hit")
            
        }
    }
}
