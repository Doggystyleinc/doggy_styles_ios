//
//  PasswordResetSuccessController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/13/21.
//

import UIKit

final class PasswordResetSuccessController: UIViewController {
    private let logo = LogoImageView(frame: .zero)
    
    private let successImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: Constants.successIcon)?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.height(60)
        imageView.width(60)
        return imageView
    }()
    
    private let successTitle = DSBoldLabel(title: "Password reset sent", size: 22)
    private let successSubText = DSRegularLabel(title: "Lorem ipsum dolor sit amet, consectetur adipiscing.", size: 14)
    
    private let openEmailButton: DSButton = {
        let button = DSButton(titleText: "Open Email", backgroundColor: .white, titleColor: .dsOrange)
        button.addTarget(self, action: #selector(didTapOpenEmail), for: .touchUpInside)
        return button
    }()
    
    private let loginButton: DSButton = {
        let button = DSButton(titleText: "Login", backgroundColor: .dsOrange, titleColor: .white)
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dsViewBackground
        navigationController?.navigationBar.isHidden = true
        navigationItem.titleView = logo
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.addViews()
    }
}

//MARK: - Configure Views
extension PasswordResetSuccessController {
    private func addViews() {
        self.view.addSubview(successImageView)
        successImageView.centerX(to: view)
        successImageView.topToSuperview(offset: 150, usingSafeArea: true)
        
        self.view.addSubview(successTitle)
        successTitle.textAlignment = .center
        successTitle.topToBottom(of: successImageView, offset: 22)
        successTitle.left(to: view, offset: 66)
        successTitle.right(to: view, offset: -66)
        
        self.view.addSubview(successSubText)
        successSubText.textAlignment = .center
        successSubText.topToBottom(of: successTitle, offset: 15)
        successSubText.left(to: view, offset: 56)
        successSubText.right(to: view, offset: -56)
        
        self.view.addSubview(openEmailButton)
        openEmailButton.topToBottom(of: successSubText, offset: 30)
        openEmailButton.left(to: view, offset: 30)
        openEmailButton.right(to: view, offset: -30)
        
        self.view.addSubview(loginButton)
        loginButton.topToBottom(of: openEmailButton, offset: 25)
        loginButton.left(to: openEmailButton)
        loginButton.right(to: openEmailButton)
    }
}


//MARK: - @objc Functions
extension PasswordResetSuccessController {
    @objc private func didTapLogin() {
        let loginVC = LoginController()
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
    
    @objc private func didTapOpenEmail() {
        let mailURL = URL(string: "message://")!
        if UIApplication.shared.canOpenURL(mailURL) {
            UIApplication.shared.open(mailURL, options: [:])
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let loginVC = LoginController()
            let navVC = UINavigationController(rootViewController: loginVC)
            navVC.modalPresentationStyle = .fullScreen
            self.navigationController?.present(navVC, animated: true)
        }
    }
}
