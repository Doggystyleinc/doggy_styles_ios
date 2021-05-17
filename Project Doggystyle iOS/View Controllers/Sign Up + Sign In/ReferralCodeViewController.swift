//
//  ReferralCodeViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/6/21.
//

import UIKit

final class ReferralCodeViewController: UIViewController {
    private let verticalPadding: CGFloat = 30.0
    
    private let referralCodeTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 24)
        label.text = "Referral code"
        label.textColor = .headerColor
        return label
    }()
    
    private let dividerView = DividerView()
    
    private let referralSubTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoRegular(size: 18)
        label.text = "Have a referral code? Enter it here to get a discount off your first appointment!"
        label.textColor = .textColor
        label.numberOfLines = 0
        return label
    }()
    
    private let referralTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .textFieldBackground
        textField.placeholder = "Referral Code (optional)"
        return textField
    }()
    
    private let signUpButton: DSButton = {
        let button = DSButton(titleText: "Sign up with [O-Auth]", backgroundColor: .dsGrey, titleColor: .white)
        button.addTarget(self, action: #selector(didTapSignUp(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.dismissKeyboardTapGesture()
        self.addTitleViews()
        self.addTextField()
        self.addSignUpButton()
    }
    
}

//MARK: - Configure Title Views
extension ReferralCodeViewController {
    private func addTitleViews() {
        self.view.addSubview(referralCodeTitle)
        referralCodeTitle.top(to: self.view, offset: 80.0)
        referralCodeTitle.left(to: self.view, offset: verticalPadding)
        
        self.view.addSubview(dividerView)
        dividerView.height(0.5)
        dividerView.topToBottom(of: self.referralCodeTitle, offset: 20.0)
        dividerView.left(to: self.view, offset: verticalPadding)
        dividerView.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(referralSubTitle)
        referralSubTitle.topToBottom(of: self.dividerView, offset: 30.0)
        referralSubTitle.left(to: self.view, offset: verticalPadding)
        referralSubTitle.right(to: self.view, offset: -verticalPadding)
    }
}

//MARK: - Configure Text Field
extension ReferralCodeViewController {
    private func addTextField() {
        self.view.addSubview(referralTextField)
        referralTextField.height(44)
        referralTextField.topToBottom(of: referralSubTitle, offset: 30.0)
        referralTextField.left(to: self.view, offset: verticalPadding)
        referralTextField.right(to: self.view, offset: -verticalPadding)
    }
}

//MARK: - Configure Sign Up Button
extension ReferralCodeViewController {
    private func addSignUpButton() {
        self.view.addSubview(signUpButton)
        signUpButton.height(44)
        signUpButton.topToBottom(of: referralTextField, offset: 30.0)
        signUpButton.left(to: self.view, offset: verticalPadding)
        signUpButton.right(to: self.view, offset: -verticalPadding)
    }
}

//MARK: - @ojbc Functions
extension ReferralCodeViewController {
    @objc private func didTapSignUp(_ sender: UIButton) {
        print(#function)
    }
}

