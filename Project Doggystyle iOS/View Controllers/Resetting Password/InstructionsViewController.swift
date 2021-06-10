//
//  InstructionsViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/12/21.
//

import UIKit

final class InstructionsViewController: UIViewController {
    private let verticalPadding: CGFloat = 30.0
    
    private let instructionsTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 24)
        label.text = "Instructions sent"
        label.textColor = .headerColor
        return label
    }()
    
    private let instructionsSubTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoRegular(size: 18)
        label.text = "Please check your email for password reset instructions."
        label.numberOfLines = 2
        label.textColor = .textColor
        return label
    }()
    
    private let dividerView = DividerView()
    
    private let openEmailAppButton: DSButton = {
        let button = DSButton(titleText: "Open Email App", backgroundColor: .dsGrey, titleColor: .white)
        button.addTarget(self, action: #selector(didTapOpenEmail(_:)), for: .touchUpInside)
        return button
    }()
    
    private let resendEmailButton: DSButton = {
        let button = DSButton(text: "Login")
        button.addTarget(self, action: #selector(didTapLogin(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.addViews()
    }

}

//MARK: - Configure Views
extension InstructionsViewController {
    private func addViews() {
        self.view.addSubview(instructionsTitle)
        instructionsTitle.top(to: self.view, offset: 80.0)
        instructionsTitle.left(to: self.view, offset: verticalPadding)
        
        self.view.addSubview(dividerView)
        dividerView.height(0.5)
        dividerView.topToBottom(of: self.instructionsTitle, offset: 20.0)
        dividerView.left(to: self.view, offset: verticalPadding)
        dividerView.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(instructionsSubTitle)
        instructionsSubTitle.topToBottom(of: self.dividerView, offset: 20.0)
        instructionsSubTitle.left(to: self.view, offset: verticalPadding)
        instructionsSubTitle.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(openEmailAppButton)
        openEmailAppButton.height(44.0)
        openEmailAppButton.topToBottom(of: self.instructionsSubTitle, offset: 20.0)
        openEmailAppButton.left(to: self.view, offset: verticalPadding)
        openEmailAppButton.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(resendEmailButton)
        resendEmailButton.height(44.0)
        resendEmailButton.topToBottom(of: self.openEmailAppButton, offset: 20.0)
        resendEmailButton.left(to: self.view, offset: verticalPadding)
        resendEmailButton.right(to: self.view, offset: -verticalPadding)
    }
}

//MARK: - @objc Functions
extension InstructionsViewController {
    @objc private func didTapOpenEmail(_ sender: UIButton) {
        let mailURL = URL(string: "message://")!
        if UIApplication.shared.canOpenURL(mailURL) {
            UIApplication.shared.open(mailURL, options: [:])
        }
    }
    
    @objc private func didTapLogin(_ sender: UIButton) {
        let emailSignInVC = EmailSignInViewController()
        self.navigationController?.pushViewController(emailSignInVC, animated: true)
    }
}
