//
//  ResetPasswordViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/13/21.
//

import UIKit

final class ResetPasswordViewController: UIViewController {
    private let verticalPadding: CGFloat = 30.0
    
    private let resetPasswordTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 24)
        label.text = "Reset password"
        label.textColor = .headerColor
        return label
    }()
    
    private let dividerView = DividerView()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10.0
        textField.setLeftPaddingPoints(10)
        textField.backgroundColor = .textFieldBackground
        textField.placeholder = "New Password"
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        textField.returnKeyType = .next
        textField.tag = 0
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private let confirmPWTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10.0
        textField.setLeftPaddingPoints(10)
        textField.backgroundColor = .textFieldBackground
        textField.placeholder = "Confirm New Password"
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        textField.returnKeyType = .done
        textField.tag = 1
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        return textField
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
    
    private let resetButton: DSButton = {
        let button = DSButton(titleText: "Reset", backgroundColor: .dsGrey, titleColor: .white)
        button.addTarget(self, action: #selector(didTapReset(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureVC()
        self.dismissKeyboardTapGesture()
        self.addViews()
    }
}


//MARK: - Configure View Controller
extension ResetPasswordViewController {
    private func configureVC() {
        self.view.backgroundColor = .white
        self.passwordTextField.delegate = self
        self.confirmPWTextField.delegate = self
    }
}


//MARK: - Configure Views
extension ResetPasswordViewController {
    private func addViews() {
        self.view.addSubview(resetPasswordTitle)
        resetPasswordTitle.top(to: self.view, offset: 80.0)
        resetPasswordTitle.left(to: self.view, offset: verticalPadding)
        
        self.view.addSubview(dividerView)
        dividerView.height(0.5)
        dividerView.topToBottom(of: self.resetPasswordTitle, offset: 20.0)
        dividerView.left(to: self.view, offset: verticalPadding)
        dividerView.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(passwordTextField)
        passwordTextField.topToBottom(of: self.dividerView, offset: 30.0)
        passwordTextField.height(44.0)
        passwordTextField.left(to: self.view, offset: verticalPadding)
        passwordTextField.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(passwordErrorLabel)
        passwordErrorLabel.topToBottom(of: passwordTextField, offset: 5)
        passwordErrorLabel.left(to: self.passwordTextField, offset: 5)
        
        self.view.addSubview(confirmPWTextField)
        confirmPWTextField.topToBottom(of: self.passwordErrorLabel, offset: 20.0)
        confirmPWTextField.height(44.0)
        confirmPWTextField.left(to: self.view, offset: verticalPadding)
        confirmPWTextField.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(confirmPWErrorLabel)
        confirmPWErrorLabel.topToBottom(of: confirmPWTextField, offset: 5)
        confirmPWErrorLabel.left(to: self.confirmPWTextField, offset: 5)
        
        self.view.addSubview(resetButton)
        resetButton.height(44)
        resetButton.bottom(to: self.view, offset: -50)
        resetButton.left(to: self.view, offset: verticalPadding)
        resetButton.right(to: self.view, offset: -verticalPadding)
    }
}

//MARK: - TextField Delegates
extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

//MARK: - @objc Functions
extension ResetPasswordViewController {
    @objc private func didTapReset(_ sender: UIButton) {
        print(#function)
        self.navigationController?.pushViewController(SuccessfulPasswordResetViewController(), animated: true)
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
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
    }
}
