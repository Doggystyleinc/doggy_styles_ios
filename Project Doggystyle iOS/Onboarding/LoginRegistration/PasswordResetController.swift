//
//  InstructionsViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/12/21.
//

import UIKit

final class PasswordResetController: UIViewController, UITextFieldDelegate {
    
    private let logo = LogoImageView(frame: .zero)
    private let resetLabel = DSBoldLabel(title: "Reset Password", size: 24)
    private let instructionsLabel = DSRegularLabel(title: "An email with reset instructions will be sent to your registered email address.", size: 16)
    let mainLoadingScreen = MainLoadingScreen()
    
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
        tel.text = "Enter email"
        tel.font = UIFont(name: rubikRegular, size: 18)
        tel.textAlignment = .left
        tel.translatesAutoresizingMaskIntoConstraints = false
        tel.isHidden = false
        tel.textColor = dividerGrey
        
        return tel
    }()
    
    private let sendButton: DSButton = {
        let button = DSButton(titleText: "Send", backgroundColor: .dsOrange, titleColor: .white)
        button.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        return button
    }()
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        addViews()
        //        self.emailTextField.becomeFirstResponder()
    }
    
    @objc func handleBackButton() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
}

//MARK: - Configure View Controller
extension PasswordResetController {
    private func configureVC() {
        view.backgroundColor = .dsViewBackground
        navigationController?.navigationBar.isHidden = true
    }
}

//MARK: - Configure Views
extension PasswordResetController {
    private func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.dsCompanyLogoImage)
        self.view.addSubview(self.resetLabel)
        self.view.addSubview(self.instructionsLabel)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.sendButton)
        
        self.view.addSubview(self.typingEmailLabel)
        self.view.addSubview(self.placeHolderEmailLabel)
        
        self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 57).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 11).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.dsCompanyLogoImage.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        self.resetLabel.topToBottom(of: dsCompanyLogoImage, offset: 44)
        self.resetLabel.left(to: view, offset: 30)
        self.resetLabel.right(to: view, offset: -30)
        
        self.instructionsLabel.topToBottom(of: resetLabel, offset: 14)
        self.instructionsLabel.left(to: resetLabel)
        self.instructionsLabel.right(to: resetLabel)
        
        self.emailTextField.topAnchor.constraint(equalTo: self.instructionsLabel.bottomAnchor, constant: 15).isActive = true
        self.emailTextField.leftAnchor.constraint(equalTo: self.instructionsLabel.leftAnchor, constant: 0).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.typingEmailLabel.leftAnchor.constraint(equalTo: self.emailTextField.leftAnchor, constant: 25).isActive = true
        self.typingEmailLabel.topAnchor.constraint(equalTo: self.emailTextField.topAnchor, constant: 14).isActive = true
        self.typingEmailLabel.sizeToFit()
        
        self.placeHolderEmailLabel.leftAnchor.constraint(equalTo: self.emailTextField.leftAnchor, constant: 25).isActive = true
        self.placeHolderEmailLabel.centerYAnchor.constraint(equalTo: self.emailTextField.centerYAnchor, constant: 0).isActive = true
        self.placeHolderEmailLabel.sizeToFit()
        
        self.sendButton.topToBottom(of: emailTextField, offset: 32)
        self.sendButton.left(to: resetLabel)
        self.sendButton.right(to: resetLabel)
    }
    
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
    
    @objc private func didTapSend() {
        
        self.emailTextField.resignFirstResponder()
        
        guard let email = self.emailTextField.text, email.isValidEmail else {
            self.presentAlertOnMainThread(title: "Invalid Address", message: "Please check your email address", buttonTitle: "Ok")
            return
        }
        
        self.mainLoadingScreen.callMainLoadingScreen(lottiAnimationName: Statics.PAW_ANIMATION)
        
        Service.shared.firebaseForgotPassword(validatedEmail: email) { isComplete, message in
            
            if isComplete {
                
                self.mainLoadingScreen.cancelMainLoadingScreen()
                let resetSuccessVC = PasswordResetSuccessController()
                self.navigationController?.pushViewController(resetSuccessVC, animated: true)
                
            } else {
                
                self.mainLoadingScreen.cancelMainLoadingScreen()
                self.presentAlertOnMainThread(title: "Error", message: "This is on us. Please try again.", buttonTitle: "Ok")
            }
            
        }
    }
}
