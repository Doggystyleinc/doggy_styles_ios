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
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Password reset"
        hl.font = UIFont(name: dsHeaderFont, size: 24)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        
       return hl
    }()
    
    private let successSubText = DSRegularLabel(title: "Tap continue to log in to your Doggystyle account once your password is reset VIA Email", size: 16)
   
    lazy var loginButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Continue", for: UIControl.State.normal)
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
        self.view.addSubview(headerLabel)
        self.view.addSubview(successSubText)
        self.view.addSubview(loginButton)

        self.successImageView.centerX(to: view)
        self.successImageView.topToSuperview(offset: 150, usingSafeArea: true)
        
        self.headerLabel.textAlignment = .center
        self.headerLabel.topToBottom(of: successImageView, offset: 22)
        self.headerLabel.left(to: view, offset: 66)
        self.headerLabel.right(to: view, offset: -66)
        
        self.successSubText.textAlignment = .center
        self.successSubText.topToBottom(of: headerLabel, offset: 15)
        self.successSubText.left(to: view, offset: 56)
        self.successSubText.right(to: view, offset: -56)
        
        self.loginButton.topAnchor.constraint(equalTo: self.successSubText.bottomAnchor, constant: 50).isActive = true
        self.loginButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    @objc private func didTapLogin() {
        let loginVC = WelcomePageController()
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
}
