//
//  PaymentMethod.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 9/3/21.
//


import Foundation
import UIKit
import PassKit

class PaymentMethodSelection : UIViewController, UIScrollViewDelegate {
    
    lazy var stackView : UIStackView = {
        
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        
        return sv
    }()
    
    let headerBarOne : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
        hbo.layer.masksToBounds = true
        
        return hbo
    }()
    
    let headerBarTwo : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
        return hbo
    }()
    
    let headerBarThree : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
        return hbo
    }()
    
    let headerBarFour : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
        return hbo
    }()
    
    let timeCover : UIView = {
        
        let tc = UIView()
        tc.translatesAutoresizingMaskIntoConstraints = false
        tc.backgroundColor = coreBackgroundWhite
        
        return tc
    }()
    
    let basicDetailsLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Payment method"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var cancelButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = UIColor.dsOrange
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        cbf.addTarget(self, action: #selector(self.handleCancelButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    lazy var xButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
        cbf.setTitleColor(dsRedColor, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    var headerContainer : UIView = {
        
        let hc = UIView()
        hc.translatesAutoresizingMaskIntoConstraints = false
        hc.backgroundColor = .clear
        hc.isUserInteractionEnabled = false
        
        return hc
    }()
    
    let topDescriptionLevel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "You’ll only be charged after the groom. Referral codes can be entered on the confirmation page"
        nl.font = UIFont(name: rubikRegular, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        
        return nl
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
        nl.text = "Credit Card"
        nl.font = UIFont(name: rubikMedium, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.isUserInteractionEnabled = false
        
        return nl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.stackView)
        
        self.view.addSubview(self.headerBarOne)
        self.view.addSubview(self.headerBarTwo)
        self.view.addSubview(self.headerBarThree)
        self.view.addSubview(self.headerBarFour)
        
        self.view.addSubview(self.headerContainer)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.xButton)
        self.view.addSubview(self.basicDetailsLabel)
        self.view.addSubview(self.topDescriptionLevel)
        
        self.view.addSubview(timeCover)
        
        self.view.addSubview(self.applePayButton)
        self.applePayButton.addSubview(self.applePayIcon)
        self.applePayButton.addSubview(self.forwardArrowApplePay)
        self.applePayButton.addSubview(self.appleLabel)
        
        self.view.addSubview(self.creditCardButton)
        self.creditCardButton.addSubview(self.creditCardIcon)
        self.creditCardButton.addSubview(self.forwardArrowCreditCard)
        self.creditCardButton.addSubview(self.creditLabel)
        
        self.headerBarOne.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarOne.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarOne.layer.cornerRadius = 4.5
        
        self.headerBarTwo.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarTwo.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarTwo.layer.cornerRadius = 4.5
        
        self.headerBarThree.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarThree.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarThree.layer.cornerRadius = 4.5
        
        self.headerBarFour.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarFour.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarFour.layer.cornerRadius = 4.5
        
        self.headerContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        self.headerContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.headerContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.headerContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.cancelButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: -20).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.headerContainer.leftAnchor, constant: 11).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.cancelButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.xButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: -20).isActive = true
        self.xButton.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -11).isActive = true
        self.xButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.xButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.basicDetailsLabel.topAnchor.constraint(equalTo: self.cancelButton.bottomAnchor, constant: 25).isActive = true
        self.basicDetailsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.basicDetailsLabel.sizeToFit()
        
        self.stackView.centerYAnchor.constraint(equalTo: self.basicDetailsLabel.centerYAnchor, constant: 0).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -30).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        self.stackView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.topDescriptionLevel.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 30).isActive = true
        self.topDescriptionLevel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.topDescriptionLevel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.topDescriptionLevel.sizeToFit()
        
        self.applePayButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        self.applePayButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.applePayButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        self.applePayButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        
        self.creditCardButton.bottomAnchor.constraint(equalTo: self.applePayButton.topAnchor, constant: -20).isActive = true
        self.creditCardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.creditCardButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        self.creditCardButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        
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
        
    }
    
    @objc func handleCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCreditCardTap() {
        
        UIDevice.vibrateLight()
        let creditCardController = CreditCardController()
        creditCardController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(creditCardController, animated: true)
        
    }
    
    @objc func handleApplePayTap() {
        self.handleApplePayment()
    }
    
    private var applePayRequest : PKPaymentRequest = {
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.doggystyle.Project-Doggystyle-iOS"
        request.supportedNetworks = [.quicPay, .masterCard, .visa, .amex]
        request.supportedCountries = ["US", "CA"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Mobile Grooming Package", amount: 119)]
        return request
    }()
    
    func handleApplePayment() {
        
        let controller = PKPaymentAuthorizationViewController(paymentRequest: self.applePayRequest)
        
        if controller != nil {
            controller!.delegate = self
            self.navigationController?.present(controller!, animated: true, completion: {
                print("Apple pay controller has been presented")
            })
        }
    }
    
    func moveToBookingConfirmation() {
        
        UIDevice.vibrateLight()
        let confirmBookingController = ConfirmBookingController()
        confirmBookingController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(confirmBookingController, animated: true)
        
    }
}

extension PaymentMethodSelection : PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        self.moveToBookingConfirmation()
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}










