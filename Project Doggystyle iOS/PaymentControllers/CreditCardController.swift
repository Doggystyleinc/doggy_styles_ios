//
//  CreditCardController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 9/3/21.
//


import Foundation
import UIKit

class CreditCardController : UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
  
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
   
    lazy var cardNumberTextField: CustomCardNumberTextField = {
        
        let etfc = CustomCardNumberTextField()
        let placeholder = NSAttributedString(string: "Card number", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
        etfc.attributedPlaceholder = placeholder
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikMedium, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .alphabet
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 8
        etfc.leftViewMode = .always
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isSecureTextEntry = false
        etfc.setRightPaddingPoints(50)

        return etfc
        
    }()
    
    lazy var cameraIcon : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .camera), for: .normal)
        cbf.setTitleColor(dsFlatBlack.withAlphaComponent(0.4), for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    lazy var dateTextField: UITextField = {
        
        let etfc = UITextField()
        let placeholder = NSAttributedString(string: "MM/YY", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
        etfc.attributedPlaceholder = placeholder
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikMedium, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .alphabet
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 8
        etfc.leftViewMode = .always
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isSecureTextEntry = false
        etfc.setRightPaddingPoints(50)

        return etfc
        
    }()
    
    lazy var cvvTextField: UITextField = {
        
        let etfc = UITextField()
        let placeholder = NSAttributedString(string: "CVV", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
        etfc.attributedPlaceholder = placeholder
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikMedium, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .alphabet
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 8
        etfc.leftViewMode = .always
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isSecureTextEntry = false
        etfc.setRightPaddingPoints(50)

        return etfc
        
    }()
    
    lazy var countryTextField: UITextField = {
        
        let etfc = UITextField()
        let placeholder = NSAttributedString(string: "Country", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
        etfc.attributedPlaceholder = placeholder
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikMedium, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .alphabet
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 8
        etfc.leftViewMode = .always
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isSecureTextEntry = false
        etfc.setRightPaddingPoints(50)

        return etfc
        
    }()
    
    lazy var countryDropDownButton : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronDown), for: .normal)
        cbf.setTitleColor(coreOrangeColor, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    lazy var zipCodeTextField: UITextField = {
        
        let etfc = UITextField()
        let placeholder = NSAttributedString(string: "Zip Code", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
        etfc.attributedPlaceholder = placeholder
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikMedium, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .alphabet
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 8
        etfc.leftViewMode = .always
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isSecureTextEntry = false
        etfc.setRightPaddingPoints(50)

        return etfc
        
    }()
    
    lazy var nextButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Next", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 12
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.isHidden = false
        cbf.addTarget(self, action: #selector(self.handleNextButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
    }
    
    func addViews() {
        
        self.view.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.headerBarOne)
        self.stackView.addArrangedSubview(self.headerBarTwo)
        self.stackView.addArrangedSubview(self.headerBarThree)
        self.stackView.addArrangedSubview(self.headerBarFour)
        
        self.view.addSubview(self.headerContainer)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.xButton)
        self.view.addSubview(self.basicDetailsLabel)

        self.view.addSubview(timeCover)
        
        self.view.addSubview(self.cardNumberTextField)
        self.cardNumberTextField.addSubview(self.cameraIcon)
        
        self.view.addSubview(self.dateTextField)
        self.view.addSubview(self.cvvTextField)
        
        self.view.addSubview(self.countryTextField)
        self.countryTextField.addSubview(self.countryDropDownButton)
        
        self.view.addSubview(self.zipCodeTextField)
        self.view.addSubview(self.nextButton)

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
        
        self.basicDetailsLabel.topAnchor.constraint(equalTo: self.cancelButton.bottomAnchor, constant: 25).isActive = true
        self.basicDetailsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.basicDetailsLabel.sizeToFit()
        
        self.xButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: -20).isActive = true
        self.xButton.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -11).isActive = true
        self.xButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.xButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.stackView.centerYAnchor.constraint(equalTo: self.basicDetailsLabel.centerYAnchor, constant: 0).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -30).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        self.stackView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.cardNumberTextField.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 20).isActive = true
        self.cardNumberTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.cardNumberTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.cardNumberTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.cameraIcon.centerYAnchor.constraint(equalTo: self.cardNumberTextField.centerYAnchor, constant: 0).isActive = true
        self.cameraIcon.rightAnchor.constraint(equalTo: self.cardNumberTextField.rightAnchor, constant: -30).isActive = true
        self.cameraIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.cameraIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.dateTextField.leftAnchor.constraint(equalTo: self.cardNumberTextField.leftAnchor, constant: 0).isActive = true
        self.dateTextField.topAnchor.constraint(equalTo: self.cardNumberTextField.bottomAnchor, constant: 20).isActive = true
        self.dateTextField.rightAnchor.constraint(equalTo: self.cardNumberTextField.centerXAnchor, constant: -5).isActive = true
        self.dateTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.cvvTextField.leftAnchor.constraint(equalTo: self.cardNumberTextField.centerXAnchor, constant: 5).isActive = true
        self.cvvTextField.topAnchor.constraint(equalTo: self.cardNumberTextField.bottomAnchor, constant: 20).isActive = true
        self.cvvTextField.rightAnchor.constraint(equalTo: self.cardNumberTextField.rightAnchor, constant: 0).isActive = true
        self.cvvTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.countryTextField.topAnchor.constraint(equalTo: self.dateTextField.bottomAnchor, constant: 20).isActive = true
        self.countryTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.countryTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.countryTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.countryDropDownButton.centerYAnchor.constraint(equalTo: self.countryTextField.centerYAnchor, constant: 0).isActive = true
        self.countryDropDownButton.rightAnchor.constraint(equalTo: self.countryTextField.rightAnchor, constant: -30).isActive = true
        self.countryDropDownButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.countryDropDownButton.widthAnchor.constraint(equalToConstant: 20).isActive = true

        self.zipCodeTextField.topAnchor.constraint(equalTo: self.countryTextField.bottomAnchor, constant: 20).isActive = true
        self.zipCodeTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.zipCodeTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.zipCodeTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    @objc func handleNextButton() {
        
        UIDevice.vibrateLight()

        let confirmBookingController = ConfirmBookingController()
        confirmBookingController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(confirmBookingController, animated: true)
        
    }
    
    @objc func handleCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

