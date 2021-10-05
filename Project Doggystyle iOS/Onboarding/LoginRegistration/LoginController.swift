//
//  LoginController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/22/21.
//

import UIKit
import Firebase
import FontAwesome_swift
import GoogleSignIn
import Firebase
import FBSDKLoginKit

final class LoginController: UIViewController, UITextFieldDelegate, CustomAlertCallBackProtocol {
    
    let mainLoadingScreen = MainLoadingScreen(),
        databaseRef = Database.database().reference()
    
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
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Welcome back"
        hl.font = UIFont(name: dsHeaderFont, size: 24)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        
        return hl
    }()
    
    let placeHolderEmailLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = .clear
        tel.text = "Enter email"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
        return tel
    }()
    
    let placeHolderPasswordLabel : UILabel = {
        
        let tel = UILabel()
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.backgroundColor = .clear
        tel.text = "Enter password"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
        return tel
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
        etfc.layer.masksToBounds = true
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.addTarget(self, action: #selector(self.handleEmailTextFieldChange), for: .editingChanged)
        etfc.addTarget(self, action: #selector(self.handleEmailTextFieldBegin), for: .touchDown)
        
        return etfc
        
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
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = true
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isSecureTextEntry = true
        etfc.addTarget(self, action: #selector(self.handlePasswordTextFieldChange), for: .editingChanged)
        etfc.addTarget(self, action: #selector(self.handlePasswordTextFieldBegin), for: .touchDown)
        
        return etfc
        
    }()
    
    lazy var loginButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Login", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 12
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.addTarget(self, action: #selector(self.didTapLogin), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var forgortPasswordButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Forgot Password?", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 16)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreBlackColor
        cbf.backgroundColor = .clear
        cbf.addTarget(self, action: #selector(self.didTapForgotPassword), for: .touchUpInside)
        
        return cbf
        
    }()
    
    private let dividerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.poppinsSemiBold(size: 14)
        label.textColor = .dsGray
        label.text = "or"
        label.textAlignment = .center
        return label
    }()
    
    lazy var registerWithfacebookButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = coreWhiteColor
        cbf.layer.masksToBounds = true
        cbf.layer.borderWidth = 1
        cbf.layer.borderColor = coreBlackColor.withAlphaComponent(0.1).cgColor
        cbf.layer.masksToBounds = true
        cbf.layer.cornerRadius = 20
        let image = UIImage(named: "Facebook Connect")?.withRenderingMode(.alwaysOriginal)
        cbf.setImage(image, for: .normal)
        cbf.imageView?.contentMode = .scaleAspectFit
        cbf.addTarget(self, action: #selector(self.handleFacebookRegistration), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    lazy var registerWithGoogleButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = coreWhiteColor
        cbf.layer.masksToBounds = true
        cbf.layer.borderWidth = 1
        cbf.layer.borderColor = coreBlackColor.withAlphaComponent(0.1).cgColor
        cbf.layer.masksToBounds = true
        cbf.layer.cornerRadius = 20
        let image = UIImage(named: "Google Connect")?.withRenderingMode(.alwaysOriginal)
        cbf.setImage(image, for: .normal)
        cbf.imageView?.contentMode = .scaleAspectFit
        cbf.addTarget(self, action: #selector(self.handleGoogleRegistration), for: UIControl.Event.touchUpInside)
        return cbf
        
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
        navigationController?.navigationBar.isHidden = true
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.addViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.initializeGoogleAuthentication()
    }
    
    private func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.dsCompanyLogoImage)
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.typingEmailLabel)
        
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.typingPasswordLabel)
        self.view.addSubview(self.showHideEyeButton)
        
        self.view.addSubview(self.placeHolderEmailLabel)
        self.view.addSubview(self.placeHolderPasswordLabel)
        
        self.view.addSubview(self.loginButton)
        self.view.addSubview(self.forgortPasswordButton)
        self.view.addSubview(self.registerWithGoogleButton)
        self.view.addSubview(self.registerWithfacebookButton)
        
        self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 57).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 11).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.dsCompanyLogoImage.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        self.headerLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 32).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerLabel.sizeToFit()
        
        self.emailTextField.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 15).isActive = true
        self.emailTextField.leftAnchor.constraint(equalTo: self.headerLabel.leftAnchor, constant: 0).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderEmailLabel.leftAnchor.constraint(equalTo: self.emailTextField.leftAnchor, constant: 30).isActive = true
        self.placeHolderEmailLabel.centerYAnchor.constraint(equalTo: self.emailTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderEmailLabel.sizeToFit()
        
        self.typingEmailLabel.leftAnchor.constraint(equalTo: self.emailTextField.leftAnchor, constant: 25).isActive = true
        self.typingEmailLabel.topAnchor.constraint(equalTo: self.emailTextField.topAnchor, constant: 14).isActive = true
        self.typingEmailLabel.sizeToFit()
        
        self.typingPasswordLabel.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor, constant: 25).isActive = true
        self.typingPasswordLabel.topAnchor.constraint(equalTo: self.passwordTextField.topAnchor, constant: 14).isActive = true
        self.typingPasswordLabel.sizeToFit()
        
        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 25).isActive = true
        self.passwordTextField.leftAnchor.constraint(equalTo: self.headerLabel.leftAnchor, constant: 0).isActive = true
        self.passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.placeHolderPasswordLabel.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor, constant: 30).isActive = true
        self.placeHolderPasswordLabel.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderPasswordLabel.sizeToFit()
        
        self.showHideEyeButton.rightAnchor.constraint(equalTo: self.passwordTextField.rightAnchor, constant: -10).isActive = true
        self.showHideEyeButton.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor, constant: 0).isActive = true
        self.showHideEyeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.showHideEyeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 30).isActive = true
        self.loginButton.leftAnchor.constraint(equalTo: self.headerLabel.leftAnchor, constant: 0).isActive = true
        self.loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.forgortPasswordButton.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: 8).isActive = true
        self.forgortPasswordButton.leftAnchor.constraint(equalTo: self.headerLabel.leftAnchor, constant: 0).isActive = true
        self.forgortPasswordButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.forgortPasswordButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.registerWithfacebookButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        self.registerWithfacebookButton.leftAnchor.constraint(equalTo: self.loginButton.leftAnchor, constant: 0).isActive = true
        self.registerWithfacebookButton.rightAnchor.constraint(equalTo: self.loginButton.rightAnchor, constant: 0).isActive = true
        self.registerWithfacebookButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        self.registerWithGoogleButton.bottomAnchor.constraint(equalTo: self.registerWithfacebookButton.topAnchor, constant: -16).isActive = true
        self.registerWithGoogleButton.leftAnchor.constraint(equalTo: self.loginButton.leftAnchor, constant: 0).isActive = true
        self.registerWithGoogleButton.rightAnchor.constraint(equalTo: self.loginButton.rightAnchor, constant: 0).isActive = true
        self.registerWithGoogleButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
    }
    
    func resignation() {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapLogin()
        }
        return false
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
    
    @objc func handlePasswordTextFieldBegin() {
        self.typingPasswordLabel.isHidden = false
        self.placeHolderPasswordLabel.isHidden = true
    }
    
    @objc func handlePasswordTextFieldChange() {
        
        if self.passwordTextField.text != "" {
            typingPasswordLabel.isHidden = false
            placeHolderPasswordLabel.isHidden = true
            
        }
    }
    
    @objc private func didTapLogin() {
        
        UIDevice.vibrateLight()
        
        self.resignation()
        
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else { return }
        
        emailTextField.layer.borderColor = emailText.isValidEmail ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        passwordTextField.layer.borderColor = passwordText.isValidPassword ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        
        guard emailText.isValidEmail, passwordText.isValidPassword else {
            return
        }
        
        self.mainLoadingScreen.callMainLoadingScreen(lottiAnimationName: Statics.PAW_ANIMATION)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            Service.shared.FirebaseLogin(usersEmailAddress: emailText, usersPassword: passwordText) { loginSuccess, response, responseCode in
                
                guard loginSuccess == true else {
                    self.mainLoadingScreen.cancelMainLoadingScreen()
                    self.handleCustomPopUpAlert(title: "Credential Mismatch", message: response, passedButtons: [Statics.OK])
                    return
                }
                self.mainLoadingScreen.cancelMainLoadingScreen()
                self.presentHomeController()
            }
        }
    }
    
    @objc func handleCustomPopUpAlert(title : String, message : String, passedButtons: [String]) {
        
        let alert = AlertController()
        alert.passedTitle = title
        alert.passedMmessage = message
        alert.passedButtonSelections = passedButtons
        alert.customAlertCallBackProtocol = self
        
        alert.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    func onSelectionPassBack(buttonTitleForSwitchStatement type: String) {
        
        switch type {
        
        case Statics.OK: print(Statics.OK)
            
        default: print("Should not hit")
            
        }
    }
    
    @objc private func didTapForgotPassword() {
        let instructionsVC = PasswordResetController()
        instructionsVC.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(instructionsVC, animated: true)
    }
    
    private func presentHomeController() {
        let homeVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: homeVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//GOOGLE SIGN IN AND AUTHENTICATION
extension LoginController : GIDSignInDelegate {
    
    @objc func handleGoogleRegistration() {
        
        self.mainLoadingScreen.callMainLoadingScreen(lottiAnimationName: Statics.PAW_ANIMATION)
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func initializeGoogleAuthentication() {
        
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            print(error.localizedDescription as Any)
            self.mainLoadingScreen.cancelMainLoadingScreen()
            return
        }
        
        guard let authentication = user.authentication else {
            self.mainLoadingScreen.cancelMainLoadingScreen()
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Service.shared.firebaseGoogleSignIn(credentials: credential, referralCode: "nil") { (hasSuccess, response) in
            
            if hasSuccess {
                self.mainLoadingScreen.cancelMainLoadingScreen()
                self.presentHomeController()
            } else {
                self.mainLoadingScreen.cancelMainLoadingScreen()
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.mainLoadingScreen.cancelMainLoadingScreen()
    }
}

//FACEBOOK AUTHENTICATION FLOW
extension LoginController {
    
    @objc func handleFacebookRegistration() {
        
        self.mainLoadingScreen.callMainLoadingScreen(lottiAnimationName: Statics.PAW_ANIMATION)
        
        let fbLoginManager : LoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self) { result, error in
            
            if error != nil {
                print(error?.localizedDescription as Any)
                self.mainLoadingScreen.cancelMainLoadingScreen()
                return
            }
            
            if let token = AccessToken.current {
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                
                Service.shared.firebaseGoogleSignIn(credentials: credential, referralCode: "nil") { (hasSuccess, response) in
                    
                    if hasSuccess {
                        self.mainLoadingScreen.cancelMainLoadingScreen()
                        self.presentHomeController()
                    } else {
                        self.mainLoadingScreen.cancelMainLoadingScreen()
                    }
                }
                
            } else {
                self.mainLoadingScreen.cancelMainLoadingScreen()
            }
        }
    }
}
