//
//  DashboardViewController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/2/21.
//

import UIKit
import Firebase

final class DashboardViewController: UIViewController {
    private let leftIcon = DSNavButton(imageName: Constants.refurIcon)
    private let rightIcon = DSNavButton(imageName: Constants.bellIcon)
    private let logo = LogoImageView(frame: .zero)
    
    private let notificationsButton: UIButton = {
        let button = UIButton(type: .system)
        let attrString = NSAttributedString(string: "99", attributes: [NSAttributedString.Key.font : UIFont.poppinsSemiBold(size: 11)])
        button.setAttributedTitle(attrString, for: .normal)
        button.backgroundColor = .dsError
        button.layer.cornerRadius = 10.0
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        self.configureVC()
        self.addViews()
    }
}

//MARK: - Configure View Controller
extension DashboardViewController {
    private func configureVC() {
        self.view.backgroundColor = .dsViewBackground
    }
}


//MARK: - Configure Views
extension DashboardViewController {
    private func addViews() {
        self.view.addSubview(logo)
        logo.topToSuperview(offset: 26, usingSafeArea: true)
        logo.centerX(to: view)
        
        self.view.addSubview(leftIcon)
        leftIcon.rightToLeft(of: logo, offset: -70)
        leftIcon.topToSuperview(offset: 14, usingSafeArea: true)
        
        self.view.addSubview(rightIcon)
        rightIcon.leftToRight(of: logo, offset: 70)
        rightIcon.top(to: leftIcon)
        
        rightIcon.addSubview(notificationsButton)
        notificationsButton.height(20)
        notificationsButton.width(20)
        notificationsButton.top(to: rightIcon, offset: 4)
        notificationsButton.right(to: rightIcon, offset: -4)
    }
}
