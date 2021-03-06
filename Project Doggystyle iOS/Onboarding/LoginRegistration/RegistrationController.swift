//
//  RegistrationController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/22/21.
//

import UIKit
import PhoneNumberKit
import Firebase

class RegistrationController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate, CustomAlertCallBackProtocol {
    
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
    
    lazy var termsTextView : UITextView = {
        
        let tv = UITextView()
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor .clear
        
        var myMutableString = NSMutableAttributedString()
        
        let partOne = "By tapping, you agree to Doggystyle's\n"
        let partTwo = "Terms of Service"
        let partThree = " and "
        let partFour = "Privacy Policy"
        
        let screenHeight = UIScreen.main.bounds.height
        var fontSize : CGFloat = 12
        
        myMutableString = NSMutableAttributedString(string: partOne + partTwo + partThree + partFour as String, attributes: [NSAttributedString.Key.font:UIFont(name: rubikRegular, size: 14)!])
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: dsFlatBlack.withAlphaComponent(0.4), range: NSRange(location:0,length:partOne.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: rubikRegular, size: fontSize)!, range: NSRange(location: 0,length:partOne.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: dsFlatBlack.withAlphaComponent(0.4), range: NSRange(location:partOne.count,length:partTwo.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: rubikRegular, size: fontSize)!, range: NSRange(location: partOne.count,length:partTwo.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: partOne.count,length:partTwo.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: dsFlatBlack.withAlphaComponent(0.4), range: NSRange(location:partOne.count + partTwo.count,length:partThree.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: rubikRegular, size: fontSize)!, range: NSRange(location: partOne.count + partTwo.count,length:partThree.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: dsFlatBlack.withAlphaComponent(0.4), range: NSRange(location:partOne.count + partTwo.count + partThree.count,length:partFour.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: rubikRegular, size: fontSize)!, range: NSRange(location: partOne.count + partTwo.count + partThree.count,length:partFour.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: partOne.count + partTwo.count + partThree.count,length:partFour.count))
        
        _ = myMutableString.setAsLink(textToFind: "Terms of Service", linkURL: Statics.TERMS_OF_SERVICE)
        
        _ = myMutableString.setAsLink(textToFind: "Privacy Policy", linkURL: Statics.PRIVACY_POLICY)
        
        tv.linkTextAttributes = [
            .foregroundColor: coreOrangeColor,
            .underlineColor: coreOrangeColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font : dsHeaderFont
        ]
        
        tv.attributedText = myMutableString
        tv.layer.masksToBounds = true
        tv.textAlignment = .center
        tv.delegate = self
        tv.isUserInteractionEnabled = true
        tv.isScrollEnabled = true
        tv.isEditable = false
        tv.isSelectable = true
        
        return tv
        
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
        self.setupObserversAndContentTypes()
        
        //MARK: - RESET THE ONBOARDING STRUCT IF THEY HIT CONTINUE-ONBOARDING
        userOnboardingStruct = UserOnboardingStruct()
        groomLocationFollowOnRoute = .fromRegistration
        
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
        
        self.view.addSubview(self.termsTextView)
        
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
        
        self.termsTextView.topAnchor.constraint(equalTo: self.confirmButton.bottomAnchor, constant: 15).isActive = true
        self.termsTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        self.termsTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        self.termsTextView.heightAnchor.constraint(equalToConstant: 61).isActive = true
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
                
                self.handleCustomPopUpAlert(title: "EMAIL EXISTS", message: "Doggystyle already has a registered email address under \(safeEmail). If this belongs to you, go back and login. ", passedButtons: [Statics.OK])
                
            } else {
                
                do {
                    let phoneNumber = try self.phoneNumberKit.parse(safeMobile)
                    let countryCode = "\(phoneNumber.countryCode)"
                    let nationalNumber = "\(phoneNumber.nationalNumber)"
                    
                    self.mainLoadingScreen.callMainLoadingScreen(lottiAnimationName: Statics.PAW_ANIMATION)
                    
                    ServiceHTTP.shared.twilioGetRequest(function_call: "request_for_pin", users_country_code: countryCode, users_phone_number: nationalNumber, delivery_method: "sms", entered_code: "nil") { object, error in
                        //MARK: GET REQUEST THROGUH TWILIO WHICH ACCEPTS MULTIPLE PARAMETS, PLEASE CHECK THE SHARED EXTENSION
                        if error == nil {
                            DispatchQueue.main.async {
                                
                                //MARK: - THIS INFO IS NO LONGER NEEDED TO PASS - TODO: REMOVE
                                let pinNumberVC = PinNumberVerificationEntryController()
                                pinNumberVC.phoneNumber = nationalNumber
                                pinNumberVC.countryCode = countryCode
                                pinNumberVC.firstName = firstName
                                pinNumberVC.lastName = lastName
                                pinNumberVC.email = safeEmail
                                pinNumberVC.password = safePassword
                                
                                //MARK: - ONLY FILL THE USERONBOARDING STRUCT HERE
                                userOnboardingStruct.user_first_name = firstName
                                userOnboardingStruct.user_last_name = lastName
                                userOnboardingStruct.users_full_name = "\(firstName) \(lastName)"
                                userOnboardingStruct.users_email = safeEmail
                                userOnboardingStruct.users_phone_number = nationalNumber
                                userOnboardingStruct.users_country_code = countryCode
                                userOnboardingStruct.users_full_phone_number = "\(countryCode) \(nationalNumber)"
                                userOnboardingStruct.is_groomer = false
                                userOnboardingStruct.users_password = safePassword
                                
                                self.mainLoadingScreen.cancelMainLoadingScreen()
                                
                                print("users first name: \(firstName)")
                                
                                let navVC = UINavigationController(rootViewController: pinNumberVC)
                                navVC.modalPresentationStyle = .fullScreen
                                self.navigationController?.present(navVC, animated: true)
                            }
                        } else {
                            self.mainLoadingScreen.cancelMainLoadingScreen()
                            let error = error?.localizedDescription as Any
                            self.handleCustomPopUpAlert(title: "This is on us, please try again.", message: "\(error)", passedButtons: [Statics.OK])
                        }
                    }
                    
                } catch {
                    print("Error")
                }
            }
        }
    }
    
    @objc func handleCustomPopUpAlert(title : String, message : String, passedButtons: [String]) {
        
        DispatchQueue.main.async {
        
        let alert = AlertController()
        alert.passedTitle = title
        alert.passedMmessage = message
        alert.passedButtonSelections = passedButtons
        alert.customAlertCallBackProtocol = self
        alert.passedIconName = .infoCircle
        
        alert.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(alert, animated: true, completion: nil)
        
        }
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
        self.navigationController?.popViewController(animated: true)
    }
}
