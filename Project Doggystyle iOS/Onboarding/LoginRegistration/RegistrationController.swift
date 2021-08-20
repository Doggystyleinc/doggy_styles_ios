//
//  RegistrationController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/22/21.
//

import UIKit
import PhoneNumberKit

extension UIScrollView {
    
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: true)
    }
}

final class RegistrationController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate {
    
    private let logo = LogoImageView(frame: .zero),
                containerView = UIView(frame: .zero),
                phoneNumberKit = PhoneNumberKit()
    
    let mainLoadingScreen = MainLoadingScreen()
    
    var screenHeight = UIScreen.main.bounds.height,
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
        tel.textColor = dividerGrey
        
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
        tel.textColor = dividerGrey
        
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
        etfc.addTarget(self, action: #selector(self.handleManualScrolling), for: .touchDown)
        
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
        tel.backgroundColor = .clear
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
        etfc.addTarget(self, action: #selector(self.handleManualScrolling), for: .touchDown)
        
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
        tel.backgroundColor = .clear
        tel.text = "Email"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dividerGrey
        
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
        etfc.addTarget(self, action: #selector(self.handleManualScrolling), for: .touchDown)
        
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
        tel.backgroundColor = .clear
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
    
    lazy var scrollView : UIScrollView = {
        
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = coreBackgroundWhite
        sv.isScrollEnabled = false
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
    
    lazy var toolBar : UIToolbar = {
        
        let bar = UIToolbar()
        
        let upImage = UIImage(named : "toolbarUpArrow")?.withRenderingMode(.alwaysOriginal)
        let downImage = UIImage(named : "toolBarDownArrow")?.withRenderingMode(.alwaysOriginal)
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.handleNextButton))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        bar.items = [flexButton,next]
        bar.backgroundColor = coreWhiteColor
        bar.sizeToFit()
        
        return bar
        
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
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: dividerGrey, range: NSRange(location:0,length:partOne.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: rubikRegular, size: fontSize)!, range: NSRange(location: 0,length:partOne.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: dividerGrey, range: NSRange(location:partOne.count,length:partTwo.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: rubikRegular, size: fontSize)!, range: NSRange(location: partOne.count,length:partTwo.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: partOne.count,length:partTwo.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: dividerGrey, range: NSRange(location:partOne.count + partTwo.count,length:partThree.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: rubikRegular, size: fontSize)!, range: NSRange(location: partOne.count + partTwo.count,length:partThree.count))
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: dividerGrey, range: NSRange(location:partOne.count + partTwo.count + partThree.count,length:partFour.count))
        
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
        
        self.dismissKeyboardTapGesture()
        self.addViews()
        self.setupObserversAndContentTypes()
        
    }
    
    func setupObserversAndContentTypes() {
        
        //SET TEXTFIELD CONTENT TYPES
        self.firstNameTextField.textContentType = UITextContentType(rawValue: "")
        self.lastNameTextField.textContentType = UITextContentType(rawValue: "")
        self.phoneNumberTextField.textContentType = UITextContentType(rawValue: "")
        self.emailTextField.textContentType = UITextContentType(rawValue: "")
        self.passwordTextField.textContentType = UITextContentType(rawValue: "")
        
        self.firstNameTextField.inputAccessoryView = toolBar
        self.lastNameTextField.inputAccessoryView = toolBar
        self.phoneNumberTextField.inputAccessoryView = toolBar
        self.emailTextField.inputAccessoryView = toolBar
        self.passwordTextField.inputAccessoryView = toolBar
        
        self.scrollView.keyboardDismissMode = .interactive
        
        let screenHeight = UIScreen.main.bounds.height
        
        switch screenHeight {
        
        case 926:
            self.scrollView.isScrollEnabled = false
            self.notificationObservers()
        case 896:
            self.scrollView.isScrollEnabled = false
            self.notificationObservers()
        case 844: //done
            self.scrollView.isScrollEnabled = false
            self.notificationObservers()
        case 812:
            self.scrollView.isScrollEnabled = false
            self.notificationObservers()
        case 736:
            self.scrollView.isScrollEnabled = false
            self.notificationObservers()
        case 667:
            self.scrollView.isScrollEnabled = false
            self.notificationObservers()
        default:
            self.scrollView.isScrollEnabled = true
        }
    }
    
    @objc func notificationObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow() {
        self.scrollView.isScrollEnabled = true
        self.isKeyboardPresented = true
    }
    
    @objc func keyboardWillHide() {
        self.scrollView.isScrollEnabled = false
        self.scrollView.scrollToTop()
        self.isKeyboardPresented = false

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
    
    @objc func handleNextButton() {
        
        //FIRST NAME
        if self.firstNameTextField.isFirstResponder {
            self.firstNameTextField.resignFirstResponder()
            self.lastNameTextField.becomeFirstResponder()
            
            //LAST NAME
        } else if lastNameTextField.isFirstResponder {
            self.lastNameTextField.resignFirstResponder()
            self.phoneNumberTextField.becomeFirstResponder()
            
            //EMAIL
        } else if phoneNumberTextField.isFirstResponder {
            self.phoneNumberTextField.resignFirstResponder()
            self.emailTextField.becomeFirstResponder()
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            //WHEN AT THE TOP PUSH TO THE BOTTOM
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
            //INITIAL PASSWORD
        } else if emailTextField.isFirstResponder {
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            //WHEN AT THE TOP PUSH TO THE BOTTOM
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
            //REPEAT PASSWORD
        } else if passwordTextField.isFirstResponder {
            self.passwordTextField.resignFirstResponder()
            self.firstNameTextField.becomeFirstResponder()
            //WHEN AT THE BOTTOM PUSH TO THE TOP
            self.scrollView.scrollToTop()
            
            
        }
        
    }
    
    private func addViews() {
        
        self.view.addSubview(scrollView)
        self.view.addSubview(timeCover)
        
        self.scrollView.addSubview(self.backButton)
        self.scrollView.addSubview(self.dsCompanyLogoImage)
        self.scrollView.addSubview(self.headerLabel)
        
        self.scrollView.addSubview(self.firstNameTextField)
        self.scrollView.addSubview(self.lastNameTextField)
        self.scrollView.addSubview(self.phoneNumberTextField)
        self.scrollView.addSubview(self.emailTextField)
        self.scrollView.addSubview(self.passwordTextField)
        self.scrollView.addSubview(self.showHideEyeButton)
        
        self.scrollView.addSubview(self.placeHolderFirstNameLabel)
        self.scrollView.addSubview(self.typingFirstNameLabel)
        
        self.scrollView.addSubview(self.placeHolderLastNameLabel)
        self.scrollView.addSubview(self.typingLastNameLabel)
        
        self.scrollView.addSubview(self.placeHolderPhoneNumberLabel)
        self.scrollView.addSubview(self.typingPhoneNumberLabel)
        
        self.scrollView.addSubview(self.placeHolderEmailLabel)
        self.scrollView.addSubview(self.typingEmailLabel)
        
        self.scrollView.addSubview(self.placeHolderPasswordLabel)
        self.scrollView.addSubview(self.typingPasswordLabel)
        
        self.scrollView.addSubview(self.confirmButton)
        
        self.scrollView.addSubview(self.termsTextView)
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        print("Screen height is: \(screenHeight)")
        
        /*
         926: iPhone 12 Pro Max
         896: iPhone 11 : iPhone 11 Pro Max
         844: iPhone 12 : iPhone 12 Pro
         812: 12 mini : iPhone 11 Pro : iPhone 12 Mini
         736: iPhone 8 Plus
         667: iPhone 8
         */
        
        switch screenHeight {
        
        //MANUAL CONFIGURATION - REFACTOR FOR UNNIVERSAL FITMENT
        case 926 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.13)
        case 896 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.14)
        case 844 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.22)
        case 812 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.27)
        case 736 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.34)
        case 667 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.47)
        case 568 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.47)
        case 480 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.47)
            
        default : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.5)
            
        }
        
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
        
        self.lastNameTextField.topAnchor.constraint(equalTo: self.firstNameTextField.bottomAnchor, constant: 20).isActive = true
        self.lastNameTextField.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 0).isActive = true
        self.lastNameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.lastNameTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderLastNameLabel.leftAnchor.constraint(equalTo: self.lastNameTextField.leftAnchor, constant: 30).isActive = true
        self.placeHolderLastNameLabel.centerYAnchor.constraint(equalTo: self.lastNameTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderLastNameLabel.sizeToFit()
        
        self.typingLastNameLabel.leftAnchor.constraint(equalTo: self.lastNameTextField.leftAnchor, constant: 25).isActive = true
        self.typingLastNameLabel.topAnchor.constraint(equalTo: self.lastNameTextField.topAnchor, constant: 14).isActive = true
        self.typingLastNameLabel.sizeToFit()
        
        self.phoneNumberTextField.topAnchor.constraint(equalTo: self.lastNameTextField.bottomAnchor, constant: 20).isActive = true
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
        
        self.emailTextField.topAnchor.constraint(equalTo: self.phoneNumberTextField.bottomAnchor, constant: 20).isActive = true
        self.emailTextField.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 0).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderEmailLabel.leftAnchor.constraint(equalTo: self.emailTextField.leftAnchor, constant: 30).isActive = true
        self.placeHolderEmailLabel.centerYAnchor.constraint(equalTo: self.emailTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderEmailLabel.sizeToFit()
        
        self.typingEmailLabel.leftAnchor.constraint(equalTo: self.emailTextField.leftAnchor, constant: 25).isActive = true
        self.typingEmailLabel.topAnchor.constraint(equalTo: self.emailTextField.topAnchor, constant: 14).isActive = true
        self.typingEmailLabel.sizeToFit()
        
        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 20).isActive = true
        self.passwordTextField.leftAnchor.constraint(equalTo: self.firstNameTextField.leftAnchor, constant: 0).isActive = true
        self.passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderPasswordLabel.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor, constant: 30).isActive = true
        self.placeHolderPasswordLabel.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderPasswordLabel.sizeToFit()
        
        self.typingPasswordLabel.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor, constant: 25).isActive = true
        self.typingPasswordLabel.topAnchor.constraint(equalTo: self.passwordTextField.topAnchor, constant: 14).isActive = true
        self.typingPasswordLabel.sizeToFit()
        
        self.confirmButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 30).isActive = true
        self.confirmButton.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor, constant: 0).isActive = true
        self.confirmButton.rightAnchor.constraint(equalTo: self.passwordTextField.rightAnchor, constant: 0).isActive = true
        self.confirmButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.termsTextView.topAnchor.constraint(equalTo: self.confirmButton.bottomAnchor, constant: 5).isActive = true
        self.termsTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        self.termsTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        self.termsTextView.heightAnchor.constraint(equalToConstant: 61).isActive = true
    }
    
    
    @objc func handleManualScrolling(sender : UITextField) {
        
        if self.isKeyboardPresented == false {return}
        
        if sender == self.phoneNumberTextField {
            
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
        } else if sender == self.emailTextField {
            
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
        } else if sender == self.passwordTextField {
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
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
        
        do {
            let phoneNumber = try phoneNumberKit.parse(safeMobile)
            let countryCode = "\(phoneNumber.countryCode)"
            let nationalNumber = "\(phoneNumber.nationalNumber)"
            
            self.mainLoadingScreen.callMainLoadingScreen(lottiAnimationName: Statics.PAW_ANIMATION)
            
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
                        
                        self.mainLoadingScreen.cancelMainLoadingScreen()
                        let navVC = UINavigationController(rootViewController: pinNumberVC)
                        self.navigationController?.present(navVC, animated: true)
                    }
                } else {
                    self.mainLoadingScreen.cancelMainLoadingScreen()
                    self.presentAlertOnMainThread(title: "This is on us, please try again.", message: error!.localizedDescription, buttonTitle: "Ok")
                }
            }
            
        } catch {
            print("Error")
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
