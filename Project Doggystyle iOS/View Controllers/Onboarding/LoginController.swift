//
//  LoginController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/22/21.
//

import UIKit

final class LoginController: UIViewController {
    private let logo = LogoImageView(frame: .zero)
    private let welcomeLabel = DSBoldLabel(title: "Welcome back", size: 22)
    
    private let emailTextField: DSTextField = {
        let textField = DSTextField(placeholder: "Enter email")
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.tag = 0
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.clear.cgColor
        return textField
    }()
    
    private let emailErrorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .dsError
        label.font = UIFont.poppinsSemiBold(size: 14)
        return label
    }()
    
    private let passwordTextField: DSTextField = {
        let textField = DSTextField(placeholder: "Enter password")
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        textField.returnKeyType = .go
        textField.tag = 1
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.clear.cgColor
        return textField
    }()
    
    private let passwordErrorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .dsError
        label.font = UIFont.poppinsSemiBold(size: 14)
        return label
    }()
    
    private let loginButton: DSButton = {
        let button = DSButton(titleText: "Login", backgroundColor: .dsOrange, titleColor: .white)
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return button
    }()
    
    private let forgortPasswordButton: DSButton = {
        let button = DSButton(titleText: "Forgot password?", backgroundColor: .clear, titleColor: .dsTextColor)
        button.titleLabel?.font = UIFont.poppinsBold(size: 14)
        button.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        return button
    }()
    
    private let dividerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.poppinsSemiBold(size: 14)
        label.textColor = .dsGray
        label.text = "or"
        label.textAlignment = .center
        return label
    }()
    
    private let registerWithFacebookButton: UIButton = {
        let cbf = UIButton(type: .system)
        cbf.backgroundColor = .clear
        let image = UIImage(named: "Facebook Connect")?.withRenderingMode(.alwaysOriginal)
        cbf.setImage(image, for: .normal)
        cbf.imageView?.contentMode = .scaleAspectFit
        cbf.addTarget(self, action: #selector(didTapFacebook), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    private let registerWithGoogleButton: UIButton = {
        let cbf = UIButton(type: .system)
        cbf.backgroundColor = .clear
        let image = UIImage(named: "Google Connect")?.withRenderingMode(.alwaysOriginal)
        cbf.setImage(image, for: .normal)
        cbf.imageView?.contentMode = .scaleAspectFit
        cbf.addTarget(self, action: #selector(didTapGoogle), for: UIControl.Event.touchUpInside)
        return cbf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardTapGesture()
        configureVC()
        addViews()
    }
}

//MARK: - Configure View Controller
extension LoginController {
    private func configureVC() {
        view.backgroundColor = .dsViewBackground
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = logo
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
}

//MARK: - Configure Views
extension LoginController {
    private func addViews() {
        self.view.addSubview(welcomeLabel)
        welcomeLabel.topToSuperview(offset: 30, usingSafeArea: true)
        welcomeLabel.left(to: view, offset: 30)
        welcomeLabel.right(to: view, offset: -30)
        
        self.view.addSubview(emailTextField)
        emailTextField.topToBottom(of: welcomeLabel, offset: 20)
        emailTextField.left(to: welcomeLabel)
        emailTextField.right(to: welcomeLabel)
        
        self.view.addSubview(emailErrorLabel)
        emailErrorLabel.topToBottom(of: emailTextField, offset: 10)
        emailErrorLabel.left(to: welcomeLabel, offset: 15)
        emailErrorLabel.right(to: welcomeLabel)
        
        self.view.addSubview(passwordTextField)
        passwordTextField.enablePasswordToggle()
        passwordTextField.topToBottom(of: emailErrorLabel, offset: 20)
        passwordTextField.left(to: welcomeLabel)
        passwordTextField.right(to: welcomeLabel)
        
        self.view.addSubview(passwordErrorLabel)
        passwordErrorLabel.topToBottom(of: passwordTextField, offset: 10)
        passwordErrorLabel.left(to: welcomeLabel, offset: 15)
        passwordErrorLabel.right(to: welcomeLabel)
        
        self.view.addSubview(loginButton)
        loginButton.topToBottom(of: passwordErrorLabel, offset: 30)
        loginButton.left(to: welcomeLabel)
        loginButton.right(to: welcomeLabel)
        
        self.view.addSubview(forgortPasswordButton)
        forgortPasswordButton.topToBottom(of: loginButton, offset: 10)
        forgortPasswordButton.left(to: welcomeLabel)
        forgortPasswordButton.right(to: welcomeLabel)
        
        self.view.addSubview(dividerLabel)
        dividerLabel.topToBottom(of: forgortPasswordButton, offset: 20)
        dividerLabel.left(to: welcomeLabel)
        dividerLabel.right(to: welcomeLabel)
        
        self.view.addSubview(registerWithGoogleButton)
        registerWithGoogleButton.topToBottom(of: dividerLabel, offset: 20)
        registerWithGoogleButton.left(to: welcomeLabel)
        registerWithGoogleButton.right(to: welcomeLabel)
        registerWithGoogleButton.height(50)
        
        self.view.addSubview(registerWithFacebookButton)
        registerWithFacebookButton.topToBottom(of: registerWithGoogleButton, offset: 4)
        registerWithFacebookButton.left(to: welcomeLabel)
        registerWithFacebookButton.right(to: welcomeLabel)
        registerWithFacebookButton.height(50)
    }
}

//MARK: - @ojbc
extension LoginController {
    @objc private func didTapLogin() {
        resignFirstResponder()
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else { return }
        
        emailTextField.layer.borderColor = emailText.isValidEmail ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        passwordTextField.layer.borderColor = passwordText.isValidPassword ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        
        guard emailText.isValidEmail, passwordText.isValidPassword else {
            return
        }
        
        showLoadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            Service.shared.FirebaseLogin(usersEmailAddress: emailText, usersPassword: passwordText) { loginSuccess, response, responseCode in
                
                guard loginSuccess == true else {
                    self.dismissLoadingView()
                    self.presentAlertOnMainThread(title: "Something went wrong...", message: response, buttonTitle: "Ok")
                    return
                }
                self.dismissLoadingView()
                self.presentHomeController()
            }
        }
    }
    
    @objc private func didTapForgotPassword() {
        let instructionsVC = PasswordResetController()
        self.navigationController?.pushViewController(instructionsVC, animated: true)
    }
    
    @objc private func didTapGoogle() {
        print(#function)
    }
    
    @objc private func didTapFacebook() {
        print(#function)
    }
}

//MARK: - TextField Delegate
extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapLogin()
        }
        return false
    }
}

//MARK: - Helpers
extension LoginController {
    private func presentHomeController() {
        let homeVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: homeVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
}
