//
//  PaymentMethodsController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/18/21.
//

import Foundation
import UIKit


class PaymentMethodsController : UIViewController {
    
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
        thl.text = "Payment Methods"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    lazy var creditCardButton : UIButton = {
        
        let ccb = UIButton(type: .system)
        ccb.translatesAutoresizingMaskIntoConstraints = false
        ccb.backgroundColor = coreWhiteColor
        ccb.layer.shadowColor = dividerGrey.cgColor
        ccb.layer.shadowOpacity = 0.35
        ccb.layer.shadowOffset = CGSize(width: 0, height: 0)
        ccb.layer.shadowRadius = 4
        ccb.layer.shouldRasterize = false
        ccb.layer.cornerRadius = 15
        ccb.addTarget(self, action: #selector(self.handleCreditCardTap), for: .touchUpInside)
        
        return ccb
    }()
   
    lazy var  applePayButton : UIButton = {
        
        let ccb = UIButton(type: .system)
        ccb.translatesAutoresizingMaskIntoConstraints = false
        ccb.backgroundColor = coreWhiteColor
        ccb.layer.shadowColor = dividerGrey.cgColor
        ccb.layer.shadowOpacity = 0.35
        ccb.layer.shadowOffset = CGSize(width: 0, height: 0)
        ccb.layer.shadowRadius = 4
        ccb.layer.shouldRasterize = false
        ccb.layer.cornerRadius = 15
        ccb.addTarget(self, action: #selector(self.handleApplePayTap), for: .touchUpInside)
        
        return ccb
    }()
    
    let creditCardIcon : UIButton = {
        
        let cci  = UIButton(type: .system)
        cci.translatesAutoresizingMaskIntoConstraints = false
        cci.backgroundColor = coreWhiteColor
        cci.isUserInteractionEnabled = false
        cci.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .regular)
        cci.setTitle(String.fontAwesomeIcon(name: .creditCard), for: .normal)
        cci.tintColor = coreBlackColor
        cci.isUserInteractionEnabled = false
        
        return cci
    }()
    
    let applePayIcon : UIButton = {
        
        let cci  = UIButton(type: .system)
        cci.translatesAutoresizingMaskIntoConstraints = false
        cci.backgroundColor = coreWhiteColor
        cci.isUserInteractionEnabled = false
        cci.tintColor = coreBlackColor
        let image = UIImage(named: "apple_pay_cc_icon")?.withRenderingMode(.alwaysOriginal)
        cci.setBackgroundImage(image, for: .normal)
        cci.contentMode = .scaleAspectFit
        cci.imageView?.contentMode = .scaleAspectFit
        cci.isUserInteractionEnabled = false
        
        return cci
    }()
    
    let forwardArrowCreditCard : UIButton = {
        
        let cci  = UIButton(type: .system)
        cci.translatesAutoresizingMaskIntoConstraints = false
        cci.backgroundColor = coreWhiteColor
        cci.isUserInteractionEnabled = false
        cci.titleLabel?.font = UIFont.fontAwesome(ofSize: 15, style: .solid)
        cci.setTitle(String.fontAwesomeIcon(name: .chevronRight), for: .normal)
        cci.tintColor = coreOrangeColor
        cci.isUserInteractionEnabled = false
        
        return cci
    }()
    
    let forwardArrowApplePay : UIButton = {
        
        let cci  = UIButton(type: .system)
        cci.translatesAutoresizingMaskIntoConstraints = false
        cci.backgroundColor = coreWhiteColor
        cci.isUserInteractionEnabled = false
        cci.titleLabel?.font = UIFont.fontAwesome(ofSize: 15, style: .solid)
        cci.setTitle(String.fontAwesomeIcon(name: .chevronRight), for: .normal)
        cci.tintColor = coreOrangeColor
        cci.isUserInteractionEnabled = false
        
        return cci
    }()
    
    let appleLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Apple Pay"
        nl.font = UIFont(name: rubikMedium, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.isUserInteractionEnabled = false
        
        return nl
    }()
    
    let creditLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "****-****-****-9570"
        nl.font = UIFont(name: rubikMedium, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.isUserInteractionEnabled = false
        
        return nl
    }()
    
    lazy var addPaymentButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("+ Add Payment Method", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: rubikBold, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreOrangeColor
        cbf.backgroundColor = .clear
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreOrangeColor
        cbf.addTarget(self, action: #selector(self.handleAddPaymentButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()

    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.earnLabel)
        self.view.addSubview(self.addPaymentButton)

        self.view.addSubview(self.applePayButton)
        self.applePayButton.addSubview(self.applePayIcon)
        self.applePayButton.addSubview(self.forwardArrowApplePay)
        self.applePayButton.addSubview(self.appleLabel)
        
        self.view.addSubview(self.creditCardButton)
        self.creditCardButton.addSubview(self.creditCardIcon)
        self.creditCardButton.addSubview(self.forwardArrowCreditCard)
        self.creditCardButton.addSubview(self.creditLabel)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.earnLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 23).isActive = true
        self.earnLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.earnLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.earnLabel.sizeToFit()
       
        self.creditCardButton.topAnchor.constraint(equalTo: self.earnLabel.bottomAnchor, constant: 30).isActive = true
        self.creditCardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.creditCardButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        self.creditCardButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        
        self.applePayButton.topAnchor.constraint(equalTo: self.creditCardButton.bottomAnchor, constant: 20).isActive = true
        self.applePayButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.applePayButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        self.applePayButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        
        self.applePayIcon.leftAnchor.constraint(equalTo: self.applePayButton.leftAnchor, constant: 30).isActive = true
        self.applePayIcon.centerYAnchor.constraint(equalTo: self.applePayButton.centerYAnchor, constant: 0).isActive = true
        self.applePayIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true
        self.applePayIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.creditCardIcon.leftAnchor.constraint(equalTo: self.creditCardButton.leftAnchor, constant: 30).isActive = true
        self.creditCardIcon.centerYAnchor.constraint(equalTo: self.creditCardButton.centerYAnchor, constant: 0).isActive = true
        self.creditCardIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.creditCardIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.forwardArrowApplePay.rightAnchor.constraint(equalTo: self.applePayButton.rightAnchor, constant: -30).isActive = true
        self.forwardArrowApplePay.centerYAnchor.constraint(equalTo: self.applePayButton.centerYAnchor, constant: 0).isActive = true
        self.forwardArrowApplePay.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.forwardArrowApplePay.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        self.forwardArrowCreditCard.rightAnchor.constraint(equalTo: self.creditCardButton.rightAnchor, constant: -30).isActive = true
        self.forwardArrowCreditCard.centerYAnchor.constraint(equalTo: self.creditCardButton.centerYAnchor, constant: 0).isActive = true
        self.forwardArrowCreditCard.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.forwardArrowCreditCard.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        self.appleLabel.leftAnchor.constraint(equalTo: self.applePayIcon.rightAnchor, constant: 20).isActive = true
        self.appleLabel.rightAnchor.constraint(equalTo: self.forwardArrowApplePay.leftAnchor, constant: -20).isActive = true
        self.appleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.appleLabel.centerYAnchor.constraint(equalTo: self.applePayButton.centerYAnchor, constant: 0).isActive = true
        self.appleLabel.sizeToFit()
        
        self.creditLabel.leftAnchor.constraint(equalTo: self.creditCardIcon.rightAnchor, constant: 20).isActive = true
        self.creditLabel.rightAnchor.constraint(equalTo: self.forwardArrowCreditCard.leftAnchor, constant: -20).isActive = true
        self.creditLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.creditLabel.centerYAnchor.constraint(equalTo: self.creditCardButton.centerYAnchor, constant: 0).isActive = true
        self.creditLabel.sizeToFit()
        
        self.addPaymentButton.topAnchor.constraint(equalTo: self.applePayButton.bottomAnchor, constant: 20).isActive = true
        self.addPaymentButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.addPaymentButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.addPaymentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    @objc func handleBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCreditCardTap() {
        
    }
    
    @objc func handleApplePayTap() {
        
    }
    
    @objc func handleAddPaymentButton() {
        
    }
}
