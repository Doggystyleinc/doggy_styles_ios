//
//  YourReferralPopup.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/11/21.
//

import Foundation
import UIKit

class YourReferralPopup : UIView, CustomAlertCallBackProtocol {
    
    var referralMonetaryController : ReferralMonetaryController?
    
    lazy var appLogoIcon : UIButton = {
        
        let dcl = UIButton(type : .system)
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = true
        let image = UIImage(named: "mini_app_logo")?.withRenderingMode(.alwaysOriginal)
        dcl.setBackgroundImage(image, for: .normal)
        dcl.layer.masksToBounds = true
        dcl.layer.cornerRadius = 8
        dcl.isHidden = false
        return dcl
    }()
   
    let headerLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Invite 10 neighbors in the next 4 weeks to earn a $20 bonus towards your first groom!"
        thl.font = UIFont(name: dsHeaderFont, size: 22)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let subHeaderLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Give a neighbor grooming credit and earn grooming credits in return when they sign up for grooming - then you can all enjoy Doggystyle sooner!"
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreBlackColor
        return thl
        
    }()
    
    lazy var refurButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Re-fur a neighbor", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.addTarget(self, action: #selector(self.handleRefurButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var noThanksButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("No Thanks", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreOrangeColor.withAlphaComponent(0.2)
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreOrangeColor
        cbf.addTarget(self, action: #selector(self.handleCancelButton), for: .touchUpInside)
        
        return cbf
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreWhiteColor
        self.translatesAutoresizingMaskIntoConstraints = true
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
        self.layer.cornerRadius = 20
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.appLogoIcon)
        self.addSubview(self.headerLabel)
        self.addSubview(self.subHeaderLabel)
        self.addSubview(self.refurButton)
        self.addSubview(self.noThanksButton)

        self.appLogoIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 45).isActive = true
        self.appLogoIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.appLogoIcon.heightAnchor.constraint(equalToConstant: 63).isActive = true
        self.appLogoIcon.widthAnchor.constraint(equalToConstant: 63).isActive = true

        self.headerLabel.topAnchor.constraint(equalTo: self.appLogoIcon.bottomAnchor, constant: 22).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.appLogoIcon.leftAnchor, constant: 0).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.headerLabel.sizeToFit()
        
        self.subHeaderLabel.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 18).isActive = true
        self.subHeaderLabel.leftAnchor.constraint(equalTo: self.appLogoIcon.leftAnchor, constant: 0).isActive = true
        self.subHeaderLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.subHeaderLabel.sizeToFit()
        
        self.refurButton.topAnchor.constraint(equalTo: self.subHeaderLabel.bottomAnchor, constant: 31).isActive = true
        self.refurButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.refurButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.refurButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.noThanksButton.topAnchor.constraint(equalTo: self.refurButton.bottomAnchor, constant: 20).isActive = true
        self.noThanksButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.noThanksButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.noThanksButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

    }
    
    @objc func handleCustomPopUpAlert(title : String, message : String, passedButtons: [String]) {
        
        let alert = AlertController()
        alert.passedTitle = title
        alert.passedMmessage = message
        alert.passedButtonSelections = passedButtons
        alert.customAlertCallBackProtocol = self
        alert.passedIconName = .infoCircle
        alert.modalPresentationStyle = .overCurrentContext
        self.referralMonetaryController?.present(alert, animated: true, completion: nil)
        
    }
    
    func onSelectionPassBack(buttonTitleForSwitchStatement type: String) {
        
        switch type {
        case Statics.GOT_IT: print("Tapped Got it")
        default: print("Should not hit")
            
        }
    }
    
    @objc func handleCancelButton() {
        self.referralMonetaryController?.handleReferralPopup()
    }
    
    @objc func handleRefurButton() {
        
        self.referralMonetaryController?.handleReferralPopup()
        self.perform(#selector(self.presentContactsController), with: nil, afterDelay: 0.5)

    }
    
    @objc func presentContactsController() {
        self.referralMonetaryController?.handleShareCodeButton()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
