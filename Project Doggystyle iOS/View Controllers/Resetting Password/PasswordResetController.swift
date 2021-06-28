//
//  InstructionsViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/12/21.
//

import UIKit

final class PasswordResetController: UIViewController {
    private let logo = LogoImageView(frame: .zero)
    private let resetLabel = DSBoldLabel(title: "Reset Password", size: 22)
    private let instructionsLabel = DSRegularLabel(title: "An email with reset instructions will be sent to your registered email address.", size: 14)
    
    private let emailTextField: DSTextField = {
        let textField = DSTextField(placeholder: "Enter email...")
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .send
        return textField
    }()
    
    private let sendButton: DSButton = {
        let button = DSButton(titleText: "Send", backgroundColor: .dsOrange, titleColor: .white)
        button.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        addViews()
    }
}

//MARK: - Configure View Controller
extension PasswordResetController {
    private func configureVC() {
        view.backgroundColor = .dsViewBackground
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = logo
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

//MARK: - Configure Views
extension PasswordResetController {
    private func addViews() {
        self.view.addSubview(resetLabel)
        resetLabel.topToSuperview(offset: 30, usingSafeArea: true)
        resetLabel.left(to: view, offset: 30)
        resetLabel.right(to: view, offset: -30)
        
        self.view.addSubview(instructionsLabel)
        instructionsLabel.topToBottom(of: resetLabel, offset: 14)
        instructionsLabel.left(to: resetLabel)
        instructionsLabel.right(to: resetLabel)
        
        self.view.addSubview(emailTextField)
        emailTextField.topToBottom(of: instructionsLabel, offset: 25)
        emailTextField.left(to: resetLabel)
        emailTextField.right(to: resetLabel)
        
        self.view.addSubview(sendButton)
        sendButton.topToBottom(of: emailTextField, offset: 32)
        sendButton.left(to: resetLabel)
        sendButton.right(to: resetLabel)
    }
}

//MARK: - @objc Functions
extension PasswordResetController {
    @objc private func didTapSend() {
        showLoadingView()
        
        guard let email = self.emailTextField.text, email.isValidEmail else {
            self.dismissLoadingView()
            self.presentAlertOnMainThread(title: "Something went wrong...", message: "Please check your email address.", buttonTitle: "Ok")
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dismissLoadingView()
            let resetSuccessVC = PasswordResetSuccessController()
            self.navigationController?.pushViewController(resetSuccessVC, animated: true)
        }
        //TODO: - Remember to enable this!
//        Service.shared.firebaseForgotPassword(validatedEmail: email) { success, response in
//            guard success == true else {
//                self.dismissLoadingView()
//                self.presentAlertOnMainThread(title: "Something went wrong...", message: response, buttonTitle: "Ok")
//                return
//            }
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.dismissLoadingView()
//                let resetSuccessVC = PasswordResetSuccessController()
//                self.navigationController?.pushViewController(resetSuccessVC, animated: true)
//            }
//        }
    }
}
