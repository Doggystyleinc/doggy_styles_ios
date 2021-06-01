//
//  EmailSignUpViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/4/21.
//

import UIKit
import PhoneNumberKit

final class EmailSignUpViewController: UIViewController {
    private var didAgreeToTerms = true
    private let verticalPadding: CGFloat = 30.0
    private var errorCounter = 0
    private let scrollView = UIScrollView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private let phoneNumberKit = PhoneNumberKit()
    
    private let signUpTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 24)
        label.text = "Email Sign up"
        label.textColor = .headerColor
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10.0
        textField.setLeftPaddingPoints(10)
        textField.backgroundColor = .textFieldBackground
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.tag = 0
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private let mobileTextField: PhoneNumberTextField = {
        let textField = PhoneNumberTextField(frame: .zero)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = .textFieldBackground
        textField.keyboardType = .numbersAndPunctuation
        textField.returnKeyType = .next
        textField.tag = 1
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10.0
        textField.setLeftPaddingPoints(10)
        textField.backgroundColor = .textFieldBackground
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        textField.tag = 2
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private let confirmPWTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10.0
        textField.setLeftPaddingPoints(10)
        textField.backgroundColor = .textFieldBackground
        textField.placeholder = "Confirm Password"
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        textField.tag = 3
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private let referralTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10.0
        textField.setLeftPaddingPoints(10)
        textField.backgroundColor = .textFieldBackground
        textField.placeholder = "Referral Code"
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.tag = 4
        return textField
    }()
    
    private let emailErrorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .errorColor
        label.font = UIFont.robotoRegular(size: 14)
        return label
    }()
    
    private let mobileErrorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .errorColor
        label.font = UIFont.robotoRegular(size: 14)
        return label
    }()
    
    private let passwordErrorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .errorColor
        label.numberOfLines = 0
        label.font = UIFont.robotoRegular(size: 14)
        return label
    }()
    
    private let confirmPWErrorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .errorColor
        label.font = UIFont.robotoRegular(size: 14)
        return label
    }()
    
    private let termsTitle: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setTitle("Agree with", for: .normal)
        button.setTitleColor(.textColor, for: .normal)
        button.titleLabel?.font = UIFont.robotoRegular(size: 16)
        return button
    }()
    
    private let termsLink: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Terms and Conditions", for: .normal)
        button.addTarget(self, action: #selector(didTapTerms(_:)), for: .touchUpInside)
        return button
    }()
    
    private let agreeToTermsButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        button.tintColor = .white
        button.isEnabled = false
        button.backgroundColor = .systemGreen
        button.setImage(UIImage(systemName: "checkmark", withConfiguration: imageConfig), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 3, bottom: 5, right: 4)
        button.addTarget(self, action: #selector(agreeToTerms(_:)), for: .touchUpInside)
        return button
    }()
    
    private let dividerView = DividerView()
    private let signUpButton: DSButton = {
       let button = DSButton(titleText: "sign up", backgroundColor: .dsGrey, titleColor: .white)
        button.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureVC()
        self.observeForKeyboard()
        self.dismissKeyboardTapGesture()
        self.addTitleViews()
        self.addScrollView()
        self.addTextFields()
        self.addTermsViews()
        self.addSignUpButton()
    }
}

//MARK: - Configure View Controller
extension EmailSignUpViewController {
    private func configureVC() {
        self.view.backgroundColor = .white
        self.emailTextField.delegate = self
        self.mobileTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPWTextField.delegate = self
        self.referralTextField.delegate = self
    }
}

//MARK: - Configure Title Message
extension EmailSignUpViewController {
    private func addTitleViews() {
        self.view.addSubview(signUpTitle)
        signUpTitle.top(to: self.view, offset: 100.0)
        signUpTitle.left(to: self.view, offset: verticalPadding)
        
        self.view.addSubview(dividerView)
        dividerView.height(0.5)
        dividerView.topToBottom(of: self.signUpTitle, offset: 20.0)
        dividerView.left(to: self.view, offset: verticalPadding)
        dividerView.right(to: self.view, offset: -verticalPadding)
    }
}

//MARK: - Configure Scroll Views
extension EmailSignUpViewController {
    private func addScrollView() {
        self.view.addSubview(scrollView)
        scrollView.topToBottom(of: dividerView)
        scrollView.left(to: self.view, offset: verticalPadding)
        scrollView.right(to: self.view, offset: -verticalPadding)
        scrollView.height(350)
        
        self.scrollView.addSubview(containerView)
        containerView.edgesToSuperview()
        containerView.width(to: self.scrollView)
        containerView.height(400)
    }
}

//MARK: - Configure Text Fields
extension EmailSignUpViewController {
    private func addTextFields() {
        self.passwordTextField.enablePasswordToggle()
        self.confirmPWTextField.enablePasswordToggle()
        
        self.containerView.addSubview(emailTextField)
        emailTextField.top(to: self.containerView, offset: 30.0)
        emailTextField.height(44.0)
        emailTextField.left(to: self.containerView)
        emailTextField.right(to: self.containerView)
        
        self.containerView.addSubview(emailErrorLabel)
        emailErrorLabel.topToBottom(of: emailTextField, offset: 5)
        emailErrorLabel.left(to: self.containerView, offset: 5)
        
        self.containerView.addSubview(mobileTextField)
        mobileTextField.topToBottom(of: self.emailErrorLabel, offset: 20.0)
        mobileTextField.height(44.0)
        mobileTextField.left(to: self.containerView)
        mobileTextField.right(to: self.containerView)
        
        self.containerView.addSubview(mobileErrorLabel)
        mobileErrorLabel.topToBottom(of: mobileTextField, offset: 5)
        mobileErrorLabel.left(to: self.containerView, offset: 5)
        
        self.containerView.addSubview(passwordTextField)
        passwordTextField.topToBottom(of: self.mobileErrorLabel, offset: 20.0)
        passwordTextField.height(44.0)
        passwordTextField.left(to: self.containerView)
        passwordTextField.right(to: self.containerView)
        
        self.containerView.addSubview(passwordErrorLabel)
        passwordErrorLabel.topToBottom(of: passwordTextField, offset: 5)
        passwordErrorLabel.left(to: self.containerView, offset: 5)
        passwordErrorLabel.right(to: self.containerView, offset: -5)
        
        self.containerView.addSubview(confirmPWTextField)
        confirmPWTextField.topToBottom(of: self.passwordErrorLabel, offset: 20.0)
        confirmPWTextField.height(44.0)
        confirmPWTextField.left(to: self.containerView)
        confirmPWTextField.right(to: self.containerView)
        
        self.containerView.addSubview(confirmPWErrorLabel)
        confirmPWErrorLabel.topToBottom(of: confirmPWTextField, offset: 5)
        confirmPWErrorLabel.left(to: self.containerView, offset: 5)
        
        self.containerView.addSubview(referralTextField)
        referralTextField.topToBottom(of: self.confirmPWErrorLabel, offset: 20.0)
        referralTextField.height(44.0)
        referralTextField.left(to: self.containerView)
        referralTextField.right(to: self.containerView)
    }
}

//MARK: - Configure Terms and Conditions
extension EmailSignUpViewController {
    private func addTermsViews() {
        self.view.addSubview(termsTitle)
        termsTitle.topToBottom(of: self.scrollView, offset: 15.0)
        termsTitle.left(to: self.scrollView, offset: 11)
        
        self.view.addSubview(termsLink)
        termsLink.top(to: termsTitle)
        termsLink.leftToRight(of: termsTitle, offset: 5.0)
        
        self.view.addSubview(agreeToTermsButton)
        agreeToTermsButton.centerY(to: termsLink)
        agreeToTermsButton.right(to: self.scrollView, offset: -11)
        agreeToTermsButton.height(22)
        agreeToTermsButton.width(22)
    }
}

//MARK: - Configure Sign Up Button
extension EmailSignUpViewController {
    private func addSignUpButton() {
        self.view.addSubview(signUpButton)
        signUpButton.height(44)
        signUpButton.bottom(to: self.view, offset: -50)
        signUpButton.left(to: self.view, offset: verticalPadding)
        signUpButton.right(to: self.view, offset: -verticalPadding)
    }
}

//MARK: - Adjust Scrollview for Keyboard
extension EmailSignUpViewController {
    private func observeForKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}

//MARK: - @objc Functions
extension EmailSignUpViewController {
    @objc private func dismissVC(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func agreeToTerms(_ sender: UIButton) {
        print(#function)
        
        UIView.animate(withDuration: 0.85) {
            if self.didAgreeToTerms == false {
                sender.backgroundColor = .systemGreen
                self.didAgreeToTerms = true
            } else {
                sender.backgroundColor = .textFieldBackground
                self.didAgreeToTerms = false
            }
        }
    }
    
    @objc private func didTapTerms(_ sender: UIButton) {
        print(#function)
    }
    
    @objc private func didTapSignUp() {
        guard let emailText = self.emailTextField.text, let passwordText = self.passwordTextField.text, let mobileNumber = self.mobileTextField.text, let referralCode = self.referralTextField.text else {
            return
        }
        
        let safeEmail = emailText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), safePassword = passwordText.trimmingCharacters(in: .whitespacesAndNewlines), safeMobile = mobileNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard safeEmail.isValidEmail, safePassword.isValidPassword, phoneNumberKit.isValidPhoneNumber(safeMobile) else {
            return
        }
        
        Service.shared.FirebaseRegistrationAndLogin(usersEmailAddress: safeEmail, usersPassword: safePassword, mobileNumber: safeMobile, referralCode: referralCode, signInMethod: Constants.email) { registrationSucces, response, responseCode in
            
            if registrationSucces == true {
                self.presentRequestVC()
            } else  {
                switch responseCode {
                case 200:
                    Service.shared.FirebaseLogin(usersEmailAddress: safeEmail, usersPassword: safePassword) { success, response, responseCode in
                        if success == true {
                            self.presentRequestVC()
                        } else {
                            //Firebase error. User is registered but unable to login.
                            self.presentAlertOnMainThread(title: "Something went wrong...", message: "Unable to login. Please try again later.", buttonTitle: "Ok")
                        }
                    }
                case 500:
                    self.errorCounter += 1
                    if self.errorCounter < 2 {
                        self.didTapSignUp()
                    } else {
                        //Firebase error. Clear text fields. Prompt user to try again.
                        self.presentAlertOnMainThread(title: "Something went wrong...", message: "Unable to register. Please try again.", buttonTitle: "Ok")
                        self.emailTextField.text = nil
                        self.passwordTextField.text = nil
                        self.confirmPWTextField.text = nil
                        self.mobileTextField.text = nil
                        self.referralTextField.text = nil
                    }
                default:
                    break
                }
            }
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}

//MARK: - TextField Delegate
extension EmailSignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            //Auto scroll to the top
            scrollView.setContentOffset(.zero, animated: true)
        }
        return false
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        
        guard let emailText = emailTextField.text else { return }
        emailErrorLabel.text = emailText.isValidEmail ? "" : "Invalid Email"
        emailErrorLabel.isHidden = emailText.isValidEmail ? true : false
        
        guard let mobileNumber = mobileTextField.text else { return }
        
        let isValid = phoneNumberKit.isValidPhoneNumber(mobileNumber)
        
        mobileErrorLabel.text = isValid ? "" : "Required Field"
        mobileErrorLabel.isHidden = isValid ? true : false
        
        guard let passwordText = passwordTextField.text else { return }
        passwordErrorLabel.text = passwordText.isValidPassword ? "" : "Password must be 8 characters"
        passwordErrorLabel.isHidden = passwordText.isValidPassword ? true : false
        
        if passwordText != confirmPWTextField.text {
            confirmPWErrorLabel.text = "Passwords Do Not Match"
            confirmPWErrorLabel.isHidden = false
        } else {
            confirmPWErrorLabel.isHidden = true
            confirmPWErrorLabel.text = ""
        }
        //Sign Up Button disabled until validation is correct
        guard emailText.isValidEmail, passwordText.isValidPassword, isValid, passwordText == confirmPWTextField.text else {
            self.signUpButton.enable(false)
            return
        }
        self.signUpButton.enable(true)
    }
}

//MARK: - Helpers
extension EmailSignUpViewController {
    private func presentRequestVC() {
        self.showLoadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let requestVC = RequestUserLocationViewController()
            let navVC = UINavigationController(rootViewController: requestVC)
            navVC.modalTransitionStyle = .crossDissolve
            navVC.modalPresentationStyle = .fullScreen
            
            self.dismissLoadingView()
            self.navigationController?.present(navVC, animated: true)
        }
    }
}
