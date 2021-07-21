//
//  RegistrationController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/22/21.
//

import UIKit
import PhoneNumberKit

final class RegistrationController: UIViewController, UITextFieldDelegate {
    
    private let logo = LogoImageView(frame: .zero)
    private let scrollView = UIScrollView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private let phoneNumberKit = PhoneNumberKit()
    
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
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Simple sign up"
        hl.font = UIFont(name: dsHeaderFont, size: 24)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        
       return hl
    }()
    
    lazy var firstNameTextField: CustomTextField = {
        
        let etfc = CustomTextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikRegular, size: 18)
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
        etfc.layer.borderColor = coreRedColor.cgColor
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.addTarget(self, action: #selector(self.handleFirstNameTextFieldChange), for: .editingChanged)
        etfc.addTarget(self, action: #selector(self.handleFirstNameTextFieldBegin), for: .touchDown)

        return etfc
        
    }()
    
    let typingFirstNameLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = coreWhiteColor
        tel.text = "First name"
        tel.font = UIFont(name: rubikBold, size: 13)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = true
        tel.textColor = dividerGrey
        
       return tel
    }()
    
    let placeHolderFirstNameLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = coreWhiteColor
        tel.text = "First name"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dividerGrey

       return tel
    }()
    
    lazy var lastNameTextField: CustomTextField = {
        
        let etfc = CustomTextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikRegular, size: 18)
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
        etfc.layer.borderColor = coreRedColor.cgColor
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.addTarget(self, action: #selector(self.handleLastNameTextFieldChange), for: .editingChanged)
        etfc.addTarget(self, action: #selector(self.handleLastNameTextFieldBegin), for: .touchDown)

        return etfc
        
    }()
    
    let typingLastNameLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = coreWhiteColor
        tel.text = "Last name"
        tel.font = UIFont(name: rubikBold, size: 13)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = true
        tel.textColor = dividerGrey
        
       return tel
    }()
    
    let placeHolderLastNameLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = coreWhiteColor
        tel.text = "Last name"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dividerGrey

       return tel
    }()
    
    lazy var phoneNumberTextField: PhoneTextFieldWithPadding = {
        
        let etfc = PhoneTextFieldWithPadding()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikRegular, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.dark
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .numberPad
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 8
        etfc.isSecureTextEntry = false
        etfc.leftViewMode = .always
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 0))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.withFlag = false
        etfc.withPrefix = true
        etfc.withExamplePlaceholder = false
        etfc.addTarget(self, action: #selector(self.handlePhoneNumberTextFieldChange), for: .editingChanged)
        etfc.addTarget(self, action: #selector(self.handlePhoneNumberTextFieldBegin), for: .touchDown)
        return etfc
        
    }()
    
    let typingPhoneNumberLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = coreWhiteColor
        tel.text = "Phone number"
        tel.font = UIFont(name: rubikBold, size: 13)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = true
        tel.textColor = dividerGrey
        
       return tel
    }()
    
    let placeHolderPhoneNumberLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = coreWhiteColor
        tel.text = "Phone number"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dividerGrey

       return tel
    }()
    
    lazy var emailTextField: CustomTextField = {
        
        let etfc = CustomTextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikRegular, size: 18)
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
        etfc.layer.borderColor = coreRedColor.cgColor
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.addTarget(self, action: #selector(self.handleEmailTextFieldChange), for: .editingChanged)
        etfc.addTarget(self, action: #selector(self.handleEmailTextFieldBegin), for: .touchDown)

        return etfc
        
    }()
    
    let typingEmailLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = coreWhiteColor
        tel.text = "Email"
        tel.font = UIFont(name: rubikBold, size: 13)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = true
        tel.textColor = dividerGrey
        
       return tel
    }()
    
    let placeHolderEmailLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = coreWhiteColor
        tel.text = "Email"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dividerGrey

       return tel
    }()
    
    lazy var passwordTextField: CustomTextField = {
        
        let etfc = CustomTextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikRegular, size: 18)
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
        etfc.layer.borderColor = coreRedColor.cgColor
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.addTarget(self, action: #selector(self.handlePasswordTextFieldChange), for: .editingChanged)
        etfc.addTarget(self, action: #selector(self.handlePasswordTextFieldBegin), for: .touchDown)

        return etfc
        
    }()
    
    let typingPasswordLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = coreWhiteColor
        tel.text = "Password"
        tel.font = UIFont(name: rubikBold, size: 13)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = true
        tel.textColor = dividerGrey
        
       return tel
    }()
    
    let placeHolderPasswordLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = coreWhiteColor
        tel.text = "Password"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dividerGrey

       return tel
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
    
    lazy var confirmButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Confirm", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 18
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.addTarget(self, action: #selector(self.handleConfirmButton), for: .touchUpInside)
        
        return cbf
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .dsViewBackground
        self.navigationController?.navigationBar.isHidden = true
        self.observeForKeyboard()
        self.dismissKeyboardTapGesture()
        self.addViews()
    }
    
   func resignation() {
        
    self.firstNameTextField.resignFirstResponder()
    self.lastNameTextField.resignFirstResponder()
    self.phoneNumberTextField.resignFirstResponder()
    self.emailTextField.resignFirstResponder()
    self.passwordTextField.resignFirstResponder()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    private func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.dsCompanyLogoImage)
        self.view.addSubview(self.headerLabel)
        
        self.view.addSubview(self.firstNameTextField)
        self.view.addSubview(self.lastNameTextField)
        self.view.addSubview(self.phoneNumberTextField)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.passwordTextField)

        self.view.addSubview(self.placeHolderFirstNameLabel)
        self.view.addSubview(self.typingFirstNameLabel)

        self.view.addSubview(self.placeHolderLastNameLabel)
        self.view.addSubview(self.typingLastNameLabel)

        self.view.addSubview(self.placeHolderPhoneNumberLabel)
        self.view.addSubview(self.typingPhoneNumberLabel)

        self.view.addSubview(self.placeHolderEmailLabel)
        self.view.addSubview(self.typingEmailLabel)

        self.view.addSubview(self.placeHolderPasswordLabel)
        self.view.addSubview(self.typingPasswordLabel)
        
        self.view.addSubview(self.confirmButton)

        self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 57).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 11).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.dsCompanyLogoImage.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        self.headerLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 62).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerLabel.sizeToFit()
        
        self.firstNameTextField.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 15).isActive = true
        self.firstNameTextField.leftAnchor.constraint(equalTo: self.headerLabel.leftAnchor, constant: 0).isActive = true
        self.firstNameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.firstNameTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderFirstNameLabel.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 25).isActive = true
        self.placeHolderFirstNameLabel.centerYAnchor.constraint(equalTo: self.firstNameTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderFirstNameLabel.sizeToFit()
        
        self.typingFirstNameLabel.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 25).isActive = true
        self.typingFirstNameLabel.topAnchor.constraint(equalTo: self.firstNameTextField.topAnchor, constant: 14).isActive = true
        self.typingFirstNameLabel.sizeToFit()
        
        self.lastNameTextField.topAnchor.constraint(equalTo: self.firstNameTextField.bottomAnchor, constant: 20).isActive = true
        self.lastNameTextField.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 0).isActive = true
        self.lastNameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.lastNameTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderLastNameLabel.leftAnchor.constraint(equalTo: self.lastNameTextField.leftAnchor, constant: 25).isActive = true
        self.placeHolderLastNameLabel.centerYAnchor.constraint(equalTo: self.lastNameTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderLastNameLabel.sizeToFit()
        
        self.typingLastNameLabel.leftAnchor.constraint(equalTo: self.lastNameTextField.leftAnchor, constant: 25).isActive = true
        self.typingLastNameLabel.topAnchor.constraint(equalTo: self.lastNameTextField.topAnchor, constant: 14).isActive = true
        self.typingLastNameLabel.sizeToFit()
        
        self.phoneNumberTextField.topAnchor.constraint(equalTo: self.lastNameTextField.bottomAnchor, constant: 20).isActive = true
        self.phoneNumberTextField.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 0).isActive = true
        self.phoneNumberTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.phoneNumberTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderPhoneNumberLabel.leftAnchor.constraint(equalTo: self.phoneNumberTextField.leftAnchor, constant: 25).isActive = true
        self.placeHolderPhoneNumberLabel.centerYAnchor.constraint(equalTo: self.phoneNumberTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderPhoneNumberLabel.sizeToFit()
        
        self.typingPhoneNumberLabel.leftAnchor.constraint(equalTo: self.phoneNumberTextField.leftAnchor, constant: 25).isActive = true
        self.typingPhoneNumberLabel.topAnchor.constraint(equalTo: self.phoneNumberTextField.topAnchor, constant: 14).isActive = true
        self.typingPhoneNumberLabel.sizeToFit()
        
        self.emailTextField.topAnchor.constraint(equalTo: self.phoneNumberTextField.bottomAnchor, constant: 20).isActive = true
        self.emailTextField.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 0).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderEmailLabel.leftAnchor.constraint(equalTo: self.emailTextField.leftAnchor, constant: 25).isActive = true
        self.placeHolderEmailLabel.centerYAnchor.constraint(equalTo: self.emailTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderEmailLabel.sizeToFit()
        
        self.typingEmailLabel.leftAnchor.constraint(equalTo: self.emailTextField.leftAnchor, constant: 25).isActive = true
        self.typingEmailLabel.topAnchor.constraint(equalTo: self.emailTextField.topAnchor, constant: 14).isActive = true
        self.typingEmailLabel.sizeToFit()
        
        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 20).isActive = true
        self.passwordTextField.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 0).isActive = true
        self.passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderPasswordLabel.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor, constant: 25).isActive = true
        self.placeHolderPasswordLabel.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderPasswordLabel.sizeToFit()
        
        self.typingPasswordLabel.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor, constant: 25).isActive = true
        self.typingPasswordLabel.topAnchor.constraint(equalTo: self.passwordTextField.topAnchor, constant: 14).isActive = true
        self.typingPasswordLabel.sizeToFit()
        
        self.confirmButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 30).isActive = true
        self.confirmButton.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor, constant: 0).isActive = true
        self.confirmButton.rightAnchor.constraint(equalTo: self.passwordTextField.rightAnchor, constant: 0).isActive = true
        self.confirmButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
      
    }
    
    //MARK: - FIRST NAME TEXT FIELD
    @objc func handleFirstNameTextFieldChange() {
        
        if self.firstNameTextField.text != "" {
            typingFirstNameLabel.isHidden = false
            placeHolderFirstNameLabel.isHidden = true
        } else {
            typingFirstNameLabel.isHidden = true
            placeHolderFirstNameLabel.isHidden = false
        }
    }
    
    @objc func handleFirstNameTextFieldBegin() {
        self.typingFirstNameLabel.isHidden = false
        self.placeHolderFirstNameLabel.isHidden = true
    }
    
    //MARK: - LAST NAME TEXT FIELD
    @objc func handleLastNameTextFieldChange() {
        
        if self.lastNameTextField.text != "" {
            typingLastNameLabel.isHidden = false
            placeHolderLastNameLabel.isHidden = true
        } else {
            typingLastNameLabel.isHidden = true
            placeHolderLastNameLabel.isHidden = false
        }
    }
    
    @objc func handleLastNameTextFieldBegin() {
        self.typingLastNameLabel.isHidden = false
        self.placeHolderLastNameLabel.isHidden = true
    }
    
    
    //MARK: - PHONE NUMBER TEXT FIELD
    @objc func handlePhoneNumberTextFieldChange() {
        
        if self.phoneNumberTextField.text != "" {
            typingPhoneNumberLabel.isHidden = false
            placeHolderPhoneNumberLabel.isHidden = true
        } else {
            typingPhoneNumberLabel.isHidden = true
            placeHolderPhoneNumberLabel.isHidden = false
        }
    }
    
    @objc func handlePhoneNumberTextFieldBegin() {
        self.typingPhoneNumberLabel.isHidden = false
        self.placeHolderPhoneNumberLabel.isHidden = true
    }
    
    //MARK: - PHONE NUMBER TEXT FIELD
    @objc func handleEmailTextFieldChange() {
        
        guard let emailText = self.emailTextField.text else {return}
        self.emailTextField.text = emailText.lowercased()
        
        if self.emailTextField.text != "" {
            typingEmailLabel.isHidden = false
            placeHolderEmailLabel.isHidden = true
        } else {
            typingEmailLabel.isHidden = true
            placeHolderEmailLabel.isHidden = false
        }
    }
    
    @objc func handleEmailTextFieldBegin() {
        self.typingEmailLabel.isHidden = false
        self.placeHolderEmailLabel.isHidden = true
    }
    
    //MARK: - PHONE NUMBER TEXT FIELD
    @objc func handlePasswordTextFieldChange() {
        
        if self.passwordTextField.text != "" {
            typingPasswordLabel.isHidden = false
            placeHolderPasswordLabel.isHidden = true
        } else {
            typingPasswordLabel.isHidden = true
            placeHolderPasswordLabel.isHidden = false
        }
    }
    
    @objc func handlePasswordTextFieldBegin() {
        self.typingPasswordLabel.isHidden = false
        self.placeHolderPasswordLabel.isHidden = true
    }
    
    @objc func handleConfirmButton() {
        
        self.resignation()
        
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let mobileNumber = phoneNumberTextField.text, let emailText = emailTextField.text, let passwordText = passwordTextField.text else {
            return
        }

        self.firstNameTextField.layer.borderColor = !firstName.isEmpty ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        self.lastNameTextField.layer.borderColor = !lastName.isEmpty ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        self.emailTextField.layer.borderColor = emailText.isValidEmail ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        self.phoneNumberTextField.layer.borderColor = phoneNumberKit.isValidPhoneNumber(mobileNumber) ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        self.passwordTextField.layer.borderColor = passwordText.isValidPassword ? UIColor.clear.cgColor : UIColor.dsError.cgColor

        let safeEmail = emailText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), safePassword = passwordText.trimmingCharacters(in: .whitespacesAndNewlines), safeMobile = mobileNumber.trimmingCharacters(in: .whitespacesAndNewlines)

        guard safeEmail.isValidEmail, safePassword.isValidPassword, phoneNumberKit.isValidPhoneNumber(safeMobile) else {
            return
        }
        
        do {
            let phoneNumber = try phoneNumberKit.parse(safeMobile)
            let countryCode = "\(phoneNumber.countryCode)"
            let nationalNumber = "\(phoneNumber.nationalNumber)"
            
            showLoadingView()
            
            ServiceHTTP.shared.twilioGetRequest(function_call: "request_for_pin", users_country_code: countryCode, users_phone_number: nationalNumber, delivery_method: "sms", entered_code: "nil") { object, error in
                if error == nil {
                    DispatchQueue.main.async {
                        let pinNumberVC = PinNumberVerificationEntryController()
                        pinNumberVC.phoneNumber = nationalNumber
                        pinNumberVC.countryCode = countryCode
                        pinNumberVC.firstName = firstName
                        pinNumberVC.lastName = lastName
                        pinNumberVC.email = safeEmail
                        pinNumberVC.password = safePassword

                        self.dismissLoadingView()
                        let navVC = UINavigationController(rootViewController: pinNumberVC)
                        self.navigationController?.present(navVC, animated: true)
                    }
                } else {
                    self.dismissLoadingView()
                    self.presentAlertOnMainThread(title: "Something went wrong...", message: error!.localizedDescription, buttonTitle: "Ok")
                }
            }
            
        } catch {
            print("Error")
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    private func observeForKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            //Auto scroll to the top
            self.scrollView.setContentOffset(.zero, animated: true)
            self.handleConfirmButton()
        }
        return false
    }
    
    private func presentPinNumberVC() {
        let pinNumberVC = PinNumberVerificationEntryController()
        let navVC = UINavigationController(rootViewController: pinNumberVC)
        navigationController?.present(navVC, animated: true)
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
