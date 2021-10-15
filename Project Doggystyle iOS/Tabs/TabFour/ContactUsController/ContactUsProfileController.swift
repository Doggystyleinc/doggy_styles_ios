//
//  ContactUsProfileController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/13/21.
//

import Foundation
import UIKit

class ContactUsProfileController : UIViewController, CustomAlertCallBackProtocol {
    
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
    
    let myDoggiesLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Contact Us"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let descriptionLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Reach out to our help center for any questions, concerns, appointment support - anything you can think of!"
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreBlackColor
        return thl
        
    }()
    
    lazy var chatWithSupportButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.masksToBounds = true
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreWhiteColor
        
        let str = String.fontAwesomeIcon(name: .comment) + "   Chat"
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
        
        cbf.clipsToBounds = false
        cbf.layer.masksToBounds = false
        cbf.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cbf.layer.shadowOpacity = 0.05
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 9
        cbf.layer.shouldRasterize = false
        cbf.layer.cornerRadius = 15
        cbf.addTarget(self, action: #selector(self.handleChatController), for: .touchUpInside)

        return cbf
        
    }()
    
    lazy var callSupportButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.masksToBounds = true
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreWhiteColor
        
        let str = String.fontAwesomeIcon(name: .phone) + "   Call"
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
        
        cbf.clipsToBounds = false
        cbf.layer.masksToBounds = false
        cbf.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cbf.layer.shadowOpacity = 0.05
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 9
        cbf.layer.shouldRasterize = false
        cbf.layer.cornerRadius = 15
        cbf.addTarget(self, action: #selector(self.handlePhoneCall), for: .touchUpInside)
        
        return cbf
        
    }()
    
    let dogWithGlassesImage : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = false
        let image = UIImage(named: "dog_glasses_icon")?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.navigationController?.navigationBar.isHidden = true
        self.addViews()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.myDoggiesLabel)
        self.view.addSubview(self.descriptionLabel)
        
        self.view.addSubview(self.dogWithGlassesImage)
        self.view.addSubview(self.chatWithSupportButton)
        self.view.addSubview(self.callSupportButton)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 11).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.myDoggiesLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 43).isActive = true
        self.myDoggiesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.myDoggiesLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.myDoggiesLabel.sizeToFit()
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.myDoggiesLabel.bottomAnchor, constant: 13).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.descriptionLabel.sizeToFit()
        
        self.callSupportButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        self.callSupportButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.callSupportButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.callSupportButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.chatWithSupportButton.bottomAnchor.constraint(equalTo: self.callSupportButton.topAnchor, constant: -25).isActive = true
        self.chatWithSupportButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.chatWithSupportButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.chatWithSupportButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.dogWithGlassesImage.bottomAnchor.constraint(equalTo: self.callSupportButton.topAnchor, constant: 0).isActive = true
        self.dogWithGlassesImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.dogWithGlassesImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.dogWithGlassesImage.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 0).isActive = true


    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleChatController() {
        
        let chatController = SupportChatController()
        let nav = UINavigationController(rootViewController: chatController)
        nav.navigationBar.isHidden = true
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true, completion: nil)
        
    }
    
    @objc func handlePhoneCall() {
        
        UIDevice.vibrateLight()
        
        if let url = URL(string: "tel://\(Statics.SUPPORT_PHONE_NUMBER)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            self.handleCustomPopUpAlert(title: "Restriction", message: "This device is unable to make phone calls.", passedButtons: [Statics.OK])
        }
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
        
        case Statics.OK: print(Statics.OK)
            
        default: print("Should not hit")
            
        }
    }
}
