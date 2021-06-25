//
//  RegistrationController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/22/21.
//

import UIKit
import PhoneNumberKit

final class RegistrationController: UIViewController {
    private let logo = LogoImageView(frame: .zero)
    private let signUpLabel = DSBoldLabel(title: "Simple sign up", size: 22)
    private let scrollView = UIScrollView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private let phoneNumberKit = PhoneNumberKit()
    private var errorCounter = 0
    
    private let firstNameTextField: DSTextField = {
        let textField = DSTextField(placeholder: "First name")
        textField.keyboardType = .default
        textField.returnKeyType = .next
        textField.tag = 0
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.clear.cgColor
        return textField
    }()
    
    private let lastNameTextField: DSTextField = {
        let textField = DSTextField(placeholder: "Last name")
        textField.keyboardType = .default
        textField.returnKeyType = .next
        textField.tag = 1
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.clear.cgColor
        return textField
    }()
    
    private let phoneNumberTextField: PhoneNumberTextField = {
        let textField = PhoneNumberTextField(frame: .zero)
        textField.placeholder = "Phone number"
        textField.keyboardType = .numbersAndPunctuation
        textField.returnKeyType = .next
        textField.tag = 2
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.font = UIFont.poppinsSemiBold(size: 16)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10.0
        textField.setLeftPaddingPoints(25)
        textField.backgroundColor = .white
        textField.clearButtonMode = .whileEditing
        textField.spellCheckingType = .no
        textField.height(60)
        return textField
    }()
    
    private let emailTextField: DSTextField = {
        let textField = DSTextField(placeholder: "Email")
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.tag = 3
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.clear.cgColor
        return textField
    }()
    
    private let passwordTextField: DSTextField = {
        let textField = DSTextField(placeholder: "Create password")
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode //remove for production
        textField.returnKeyType = .go
        textField.tag = 4
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.clear.cgColor
        return textField
    }()
    
    private let nextButton: DSButton = {
        let button = DSButton(titleText: "Next", backgroundColor: .dsOrange, titleColor: .white)
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        observeForKeyboard()
        dismissKeyboardTapGesture()
        configureVC()
        addScrollViews()
        addViews()
    }
}

//MARK: - Configure View Controller
extension RegistrationController {
    private func configureVC() {
        view.backgroundColor = .dsViewBackground
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = logo
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}

//MARK: - Configure Scroll Views
extension RegistrationController {
    private func addScrollViews() {
        self.view.addSubview(signUpLabel)
        signUpLabel.topToSuperview(offset: 30, usingSafeArea: true)
        signUpLabel.left(to: view, offset: 30)
        signUpLabel.right(to: view, offset: -30)
        
        self.view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.topToBottom(of: signUpLabel, offset: 10)
        scrollView.left(to: signUpLabel)
        scrollView.right(to: signUpLabel)
        scrollView.height(450)
        
        self.scrollView.addSubview(containerView)
        containerView.edgesToSuperview()
        containerView.width(to: scrollView)
        containerView.height(500)
    }
}

//MARK: - Configure Views
extension RegistrationController {
    private func addViews() {
        self.containerView.addSubview(firstNameTextField)
        firstNameTextField.top(to: containerView, offset: 10)
        firstNameTextField.left(to: signUpLabel)
        firstNameTextField.right(to: signUpLabel)
        
        self.containerView.addSubview(lastNameTextField)
        lastNameTextField.topToBottom(of: firstNameTextField, offset: 20)
        lastNameTextField.left(to: signUpLabel)
        lastNameTextField.right(to: signUpLabel)
        
        self.containerView.addSubview(phoneNumberTextField)
        phoneNumberTextField.topToBottom(of: lastNameTextField, offset: 20)
        phoneNumberTextField.left(to: signUpLabel)
        phoneNumberTextField.right(to: signUpLabel)
        
        self.containerView.addSubview(emailTextField)
        emailTextField.topToBottom(of: phoneNumberTextField, offset: 20)
        emailTextField.left(to: signUpLabel)
        emailTextField.right(to: signUpLabel)
        
        self.containerView.addSubview(passwordTextField)
        passwordTextField.topToBottom(of: emailTextField, offset: 20)
        passwordTextField.left(to: signUpLabel)
        passwordTextField.right(to: signUpLabel)
        
        self.view.addSubview(nextButton)
        nextButton.bottom(to: view, offset: -60)
        nextButton.left(to: signUpLabel)
        nextButton.right(to: signUpLabel)
    }
}

//MARK: - @objc
extension RegistrationController {
    @objc private func didTapNext() {
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let mobileNumber = phoneNumberTextField.text, let emailText = emailTextField.text, let passwordText = passwordTextField.text else {
            return
        }
        
        firstNameTextField.layer.borderColor = !firstName.isEmpty ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        lastNameTextField.layer.borderColor = !lastName.isEmpty ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        emailTextField.layer.borderColor = emailText.isValidEmail ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        phoneNumberTextField.layer.borderColor = phoneNumberKit.isValidPhoneNumber(mobileNumber) ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        passwordTextField.layer.borderColor = passwordText.isValidPassword ? UIColor.clear.cgColor : UIColor.dsError.cgColor
        
        let safeEmail = emailText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), safePassword = passwordText.trimmingCharacters(in: .whitespacesAndNewlines), safeMobile = mobileNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard safeEmail.isValidEmail, safePassword.isValidPassword, phoneNumberKit.isValidPhoneNumber(safeMobile) else {
            return
        }
        print("All Fields Correct!!!")
//        Service.shared.FirebaseRegistrationAndLogin(userFirstName: firstName, userLastName: lastName, usersEmailAddress: safeEmail, usersPassword: safePassword, mobileNumber: safeMobile, referralCode: "referralCode", signInMethod: Constants.email) { registrationSucces, response, responseCode in
//
//            if registrationSucces == true {
//                self.presentPinNumberVC()
//            } else  {
//                switch responseCode {
//                case 200:
//                    Service.shared.FirebaseLogin(usersEmailAddress: safeEmail, usersPassword: safePassword) { success, response, responseCode in
//                        if success == true {
//                            self.presentPinNumberVC()
//                        } else {
//                            //Firebase error. User is registered but unable to login.
//                            self.presentAlertOnMainThread(title: "Something went wrong...", message: "Unable to login. Please try again later.", buttonTitle: "Ok")
//                        }
//                    }
//                case 500:
//                    self.errorCounter += 1
//                    if self.errorCounter < 2 {
//                        self.didTapNext()
//                    } else {
//                        //Firebase error. Clear text fields. Prompt user to try again.
//                        self.presentAlertOnMainThread(title: "Something went wrong...", message: "Unable to register. Please try again.", buttonTitle: "Ok")
//                        self.emailTextField.text = nil
//                        self.passwordTextField.text = nil
//                        self.phoneNumberTextField.text = nil
//                    }
//                default:
//                    break
//                }
//            }
//        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}

//MARK: - Adjust Scrollview for Keyboard
extension RegistrationController {
    private func observeForKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}

//MARK: - TextField Delegate
extension RegistrationController: UITextFieldDelegate {
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
}

//MARK: - Helpers
extension RegistrationController {
    private func presentPinNumberVC() {
        let pinNumberVC = PinNumberVerificationEntryController()
        let navVC = UINavigationController(rootViewController: pinNumberVC)
        navigationController?.present(navVC, animated: true)
    }
}
