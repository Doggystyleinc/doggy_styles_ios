//
//  EditProfileController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/1/21.
//

import UIKit
import PhoneNumberKit
import Firebase

class EditProfileController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate, CustomAlertCallBackProtocol {
    
    let logo = LogoImageView(frame: .zero),
        containerView = UIView(frame: .zero),
        phoneNumberKit = PhoneNumberKit(),
        mainLoadingScreen = MainLoadingScreen()
    
    var lastKeyboardHeight : CGFloat = 0.0,
        contentOffSet : CGFloat = 0.0,
        contentHeight : CGFloat = 675.0,
        isKeyboardShowing : Bool = false,
        screenHeight = UIScreen.main.bounds.height,
        isKeyboardPresented : Bool = false
    
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
        hl.text = "Edit profile"
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
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
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
        tel.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
        return tel
    }()
    
    let placeHolderFirstNameLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = .clear
        tel.text = "First name"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
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
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
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
        tel.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
        return tel
    }()
    
    let placeHolderLastNameLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = .clear
        tel.text = "Last name"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
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
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.keyboardAppearance = UIKeyboardAppearance.light
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
        tel.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
        return tel
    }()
    
    let placeHolderPhoneNumberLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = .clear
        tel.text = "Phone number"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
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
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
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
        tel.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
        return tel
    }()
    
    let placeHolderEmailLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = .clear
        tel.text = "Email"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
        return tel
    }()
    
    lazy var passwordTextField: CustomPasswordTextField = {
        
        let etfc = CustomPasswordTextField()
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
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isSecureTextEntry = true
        etfc.setRightPaddingPoints(50)
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
        tel.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
        return tel
    }()
    
    let placeHolderPasswordLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = .clear
        tel.text = "Password"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
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
        cbf.setTitle("Save Changes", for: UIControl.State.normal)
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
    
    lazy var scrollView : UIScrollView = {
        
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = coreBackgroundWhite
        sv.isScrollEnabled = true
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 1.0
        sv.bounces = true
        sv.bouncesZoom = true
        sv.isHidden = false
        sv.delegate = self
        sv.contentMode = .scaleAspectFit
        sv.isUserInteractionEnabled = true
        sv.delaysContentTouches = false
        
        return sv
        
    }()
    
    let contentView : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.isUserInteractionEnabled = true
        return cv
        
    }()
    
    let timeCover : UIView = {
        
        let tc = UIView()
        tc.translatesAutoresizingMaskIntoConstraints = false
        tc.isUserInteractionEnabled = false
        tc.backgroundColor = coreBackgroundWhite
        
        return tc
    }()

    lazy var showHideEyeButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = UIColor.dsOrange
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 18, style: .light)
        cbf.setTitle(String.fontAwesomeIcon(name: .eyeSlash), for: .normal)
        cbf.tintColor = coreOrangeColor
        cbf.addTarget(self, action: #selector(self.showHidePassWord), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .dsViewBackground
        self.navigationController?.navigationBar.isHidden = true
        
        self.addViews()
        self.fillValues()
        self.setupObserversAndContentTypes()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addViews() {
        
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.timeCover)
        
        self.scrollView.addSubview(self.contentView)
        
        self.contentView.addSubview(self.backButton)
        self.contentView.addSubview(self.dsCompanyLogoImage)
        self.contentView.addSubview(self.headerLabel)
        
        self.contentView.addSubview(self.firstNameTextField)
        self.contentView.addSubview(self.lastNameTextField)
        self.contentView.addSubview(self.phoneNumberTextField)
        self.contentView.addSubview(self.emailTextField)
        self.contentView.addSubview(self.passwordTextField)
        self.contentView.addSubview(self.showHideEyeButton)
        
        self.contentView.addSubview(self.placeHolderFirstNameLabel)
        self.contentView.addSubview(self.typingFirstNameLabel)
        
        self.contentView.addSubview(self.placeHolderLastNameLabel)
        self.contentView.addSubview(self.typingLastNameLabel)
        
        self.contentView.addSubview(self.placeHolderPhoneNumberLabel)
        self.contentView.addSubview(self.typingPhoneNumberLabel)
        
        self.contentView.addSubview(self.placeHolderEmailLabel)
        self.contentView.addSubview(self.typingEmailLabel)
        
        self.contentView.addSubview(self.placeHolderPasswordLabel)
        self.contentView.addSubview(self.typingPasswordLabel)
        
        self.contentView.addSubview(self.confirmButton)
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.contentHeight + self.lastKeyboardHeight)
        
        self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 0).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor, constant: 0).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.contentView.heightAnchor.constraint(equalToConstant: 665).isActive = true
        
        self.timeCover.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.timeCover.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.timeCover.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.timeCover.heightAnchor.constraint(equalToConstant: globalStatusBarHeight).isActive = true
        
        self.backButton.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 17).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 11).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.dsCompanyLogoImage.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        self.headerLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 42).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerLabel.sizeToFit()
        
        self.firstNameTextField.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 15).isActive = true
        self.firstNameTextField.leftAnchor.constraint(equalTo: self.headerLabel.leftAnchor, constant: 0).isActive = true
        self.firstNameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.firstNameTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderFirstNameLabel.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 30).isActive = true
        self.placeHolderFirstNameLabel.centerYAnchor.constraint(equalTo: self.firstNameTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderFirstNameLabel.sizeToFit()
        
        self.typingFirstNameLabel.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 25).isActive = true
        self.typingFirstNameLabel.topAnchor.constraint(equalTo: self.firstNameTextField.topAnchor, constant: 14).isActive = true
        self.typingFirstNameLabel.sizeToFit()
        
        self.lastNameTextField.topAnchor.constraint(equalTo: self.firstNameTextField.bottomAnchor, constant: 16).isActive = true
        self.lastNameTextField.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 0).isActive = true
        self.lastNameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.lastNameTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderLastNameLabel.leftAnchor.constraint(equalTo: self.lastNameTextField.leftAnchor, constant: 30).isActive = true
        self.placeHolderLastNameLabel.centerYAnchor.constraint(equalTo: self.lastNameTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderLastNameLabel.sizeToFit()
        
        self.typingLastNameLabel.leftAnchor.constraint(equalTo: self.lastNameTextField.leftAnchor, constant: 25).isActive = true
        self.typingLastNameLabel.topAnchor.constraint(equalTo: self.lastNameTextField.topAnchor, constant: 14).isActive = true
        self.typingLastNameLabel.sizeToFit()
        
        self.phoneNumberTextField.topAnchor.constraint(equalTo: self.lastNameTextField.bottomAnchor, constant: 16).isActive = true
        self.phoneNumberTextField.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 0).isActive = true
        self.phoneNumberTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.phoneNumberTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.showHideEyeButton.rightAnchor.constraint(equalTo: self.passwordTextField.rightAnchor, constant: -10).isActive = true
        self.showHideEyeButton.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor, constant: 0).isActive = true
        self.showHideEyeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.showHideEyeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.placeHolderPhoneNumberLabel.leftAnchor.constraint(equalTo: self.phoneNumberTextField.leftAnchor, constant: 30).isActive = true
        self.placeHolderPhoneNumberLabel.centerYAnchor.constraint(equalTo: self.phoneNumberTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderPhoneNumberLabel.sizeToFit()
        
        self.typingPhoneNumberLabel.leftAnchor.constraint(equalTo: self.phoneNumberTextField.leftAnchor, constant: 25).isActive = true
        self.typingPhoneNumberLabel.topAnchor.constraint(equalTo: self.phoneNumberTextField.topAnchor, constant: 14).isActive = true
        self.typingPhoneNumberLabel.sizeToFit()
        
        self.emailTextField.topAnchor.constraint(equalTo: self.phoneNumberTextField.bottomAnchor, constant: 16).isActive = true
        self.emailTextField.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 0).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderEmailLabel.leftAnchor.constraint(equalTo: self.emailTextField.leftAnchor, constant: 30).isActive = true
        self.placeHolderEmailLabel.centerYAnchor.constraint(equalTo: self.emailTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderEmailLabel.sizeToFit()
        
        self.typingEmailLabel.leftAnchor.constraint(equalTo: self.emailTextField.leftAnchor, constant: 25).isActive = true
        self.typingEmailLabel.topAnchor.constraint(equalTo: self.emailTextField.topAnchor, constant: 14).isActive = true
        self.typingEmailLabel.sizeToFit()
        
        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 16).isActive = true
        self.passwordTextField.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 0).isActive = true
        self.passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderPasswordLabel.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor, constant: 30).isActive = true
        self.placeHolderPasswordLabel.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderPasswordLabel.sizeToFit()
        
        self.typingPasswordLabel.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor, constant: 25).isActive = true
        self.typingPasswordLabel.topAnchor.constraint(equalTo: self.passwordTextField.topAnchor, constant: 14).isActive = true
        self.typingPasswordLabel.sizeToFit()
        
        self.confirmButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        self.confirmButton.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor, constant: 0).isActive = true
        self.confirmButton.rightAnchor.constraint(equalTo: self.passwordTextField.rightAnchor, constant: 0).isActive = true
        self.confirmButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
       
    }
    
    @objc func fillValues() {
        
        let firstName = userProfileStruct.user_first_name ?? "?"
        let lastName = userProfileStruct.user_last_name ?? "?"
        let phoneNumber = userProfileStruct.users_phone_number ?? "?"
        let email = userProfileStruct.users_email ?? "?"
        
        self.handleFirstNameTextFieldBegin()
        self.handleLastNameTextFieldBegin()
        self.handlePhoneNumberTextFieldBegin()
        self.handleEmailTextFieldBegin()
        
        self.firstNameTextField.text = firstName
        self.lastNameTextField.text = lastName
        self.phoneNumberTextField.text = phoneNumber
        self.emailTextField.text = email
        
    }
    
    func setupObserversAndContentTypes() {
        
        //MARK: - SET TEXTFIELD CONTENT TYPES
        self.firstNameTextField.textContentType = UITextContentType(rawValue: "")
        self.lastNameTextField.textContentType = UITextContentType(rawValue: "")
        self.phoneNumberTextField.textContentType = UITextContentType(rawValue: "")
        self.emailTextField.textContentType = UITextContentType(rawValue: "")
        self.passwordTextField.textContentType = UITextContentType(rawValue: "")
        
        self.scrollView.keyboardDismissMode = .interactive
    }
    
    @objc func handleKeyboardShow(notification : Notification) {
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        if keyboardRectangle.height > 200 {
            
            if self.isKeyboardShowing == true {return}
            self.isKeyboardShowing = true
            
            self.lastKeyboardHeight = keyboardRectangle.height
            self.perform(#selector(self.handleKeyboardMove), with: nil, afterDelay: 0.1)
            
        }
    }
    
    @objc func handleKeyboardHide(notification : Notification) {
        
        self.isKeyboardShowing = false
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        self.lastKeyboardHeight = keyboardRectangle.height
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.contentHeight)
    }
    
    @objc func handleKeyboardMove() {
        self.adjustContentSize()
    }
    
    @objc func adjustContentSize() {
        
        if self.firstNameTextField.isFirstResponder {return}
        
        self.scrollView.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.contentHeight + self.lastKeyboardHeight)
        self.scrollView.scrollToBottom()
        
    }
    
    @objc func showHidePassWord() {
        
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
        
        if self.passwordTextField.isSecureTextEntry {
            
            self.showHideEyeButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 18, style: .light)
            self.showHideEyeButton.setTitle(String.fontAwesomeIcon(name: .eyeSlash), for: .normal)
            
        } else {
            
            self.showHideEyeButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 18, style: .solid)
            self.showHideEyeButton.setTitle(String.fontAwesomeIcon(name: .eye), for: .normal)
        }
    }
    
    @objc func resignation() {
        
        self.firstNameTextField.resignFirstResponder()
        self.lastNameTextField.resignFirstResponder()
        self.phoneNumberTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    //MARK: - FIRST NAME TEXT FIELD
    @objc func handleFirstNameTextFieldChange() {
        if self.firstNameTextField.text != "" {
            typingFirstNameLabel.isHidden = false
            placeHolderFirstNameLabel.isHidden = true
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
        }
    }
    
    @objc func handleLastNameTextFieldBegin() {
        self.typingLastNameLabel.isHidden = false
        self.placeHolderLastNameLabel.isHidden = true
        self.adjustContentSize()
    }
    
    //MARK: - PHONE NUMBER TEXT FIELD
    @objc func handlePhoneNumberTextFieldChange() {
        if self.phoneNumberTextField.text != "" {
            typingPhoneNumberLabel.isHidden = false
            placeHolderPhoneNumberLabel.isHidden = true
        }
    }
    
    @objc func handlePhoneNumberTextFieldBegin() {
        self.typingPhoneNumberLabel.isHidden = false
        self.placeHolderPhoneNumberLabel.isHidden = true
        self.adjustContentSize()
    }
    
    @objc func handleEmailTextFieldChange() {
        
        guard let emailText = self.emailTextField.text else {return}
        self.emailTextField.text = emailText.lowercased()
        
        if self.emailTextField.text != "" {
            typingEmailLabel.isHidden = false
            placeHolderEmailLabel.isHidden = true
        }
    }
    
    @objc func handleEmailTextFieldBegin() {
        self.typingEmailLabel.isHidden = false
        self.placeHolderEmailLabel.isHidden = true
        self.adjustContentSize()
        
    }
    
    @objc func handlePasswordTextFieldChange() {
        
        if self.passwordTextField.text != "" {
            typingPasswordLabel.isHidden = false
            placeHolderPasswordLabel.isHidden = true
        }
    }
    
    @objc func handlePasswordTextFieldBegin() {
        self.typingPasswordLabel.isHidden = false
        self.placeHolderPasswordLabel.isHidden = true
        self.adjustContentSize()
        
    }
    
    //MARK: - HACKY WAY TO CHECK IF EMAIL EXISTS BEFORE WALKING THE USER THROUGH 5 SCRENS AND THEN LETTING THEM KNOW
    func checkForEmailValidation(emailAddress : String, completion : @escaping (_ doesUserExist : Bool)->()) {
        
        Auth.auth().fetchSignInMethods(forEmail: emailAddress) { providers, error in
            
            if providers != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    @objc func handleConfirmButton() {
        
        self.handleCustomPopUpAlert(title: "PROFILE", message: "Updating your profile is currently in BETA.", passedButtons: [Statics.OK])
        
        self.resignation()
        UIDevice.vibrateLight()
        
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let mobileNumber = phoneNumberTextField.text, let emailText = emailTextField.text, let passwordText = passwordTextField.text else {
            return
        }
        
        self.scrollView.scrollToTop()
        
        self.firstNameTextField.layer.borderColor = !firstName.isEmpty ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        self.lastNameTextField.layer.borderColor = !lastName.isEmpty ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        self.emailTextField.layer.borderColor = emailText.isValidEmail ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        self.phoneNumberTextField.layer.borderColor = phoneNumberKit.isValidPhoneNumber(mobileNumber) ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        self.passwordTextField.layer.borderColor = passwordText.isValidPassword ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        
        let safeEmail = emailText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), safePassword = passwordText.trimmingCharacters(in: .whitespacesAndNewlines), safeMobile = mobileNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard safeEmail.isValidEmail, safePassword.isValidPassword, phoneNumberKit.isValidPhoneNumber(safeMobile) else {
            return
        }
        
        self.checkForEmailValidation(emailAddress: safeEmail) { doesUserAlreadyExist in
            
            if doesUserAlreadyExist == true {
                self.handleCustomPopUpAlert(title: "EMAIL EXISTS", message: "Doggystyle already has a registered email address under \(safeEmail).", passedButtons: [Statics.OK])
            } else {
                self.handleCustomPopUpAlert(title: "CHECK", message: "Email cannot be saved without verification", passedButtons: [Statics.OK])
            }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            
            self.scrollView.scrollToTop()
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
        self.dismiss(animated: true, completion: nil)
    }
}
