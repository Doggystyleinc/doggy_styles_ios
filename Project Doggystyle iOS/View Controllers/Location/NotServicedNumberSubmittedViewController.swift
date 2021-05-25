//
//  NotServicedNumberSubmittedViewController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/24/21.
//

import UIKit

final class NotServicedNumberSubmittedViewController: UIViewController {
    private let verticalPadding: CGFloat = 30.0
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 30)
        label.text = "We'll be in touch"
        label.textColor = .headerColor
        return label
    }()
    
    private let dividerView = DividerView()
    
    private let contactLaterLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoRegular(size: 18)
        label.textColor = .textColor
        label.numberOfLines = 0
        label.text = "A member of our team will message you within 24 hours. Thanks for your patience!"
        return label
    }()
    
    private let subDividerView = DividerView()
    
    private let contactLaterSubLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoRegular(size: 18)
        label.textColor = .textColor
        label.numberOfLines = 0
        label.text = "In the meantime, would you like to:"
        return label
    }()
    
    private let createProfileButton: UIButton = {
        let button = DSButton(titleText: "create doggy profile", backgroundColor: .dsGrey, titleColor: .white)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.tag = 1
        return button
    }()
    
    private let visitDashboardButton: UIButton = {
        let button = DSButton(titleText: "visit dashboard", backgroundColor: .dsGrey, titleColor: .white)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.tag = 2
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        addViews()
    }
}

//MARK: - Configure View Controller
extension NotServicedNumberSubmittedViewController {
    private func configureVC() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
    }
}

//MARK: - Configure Views
extension NotServicedNumberSubmittedViewController {
    private func addViews() {
        self.view.addSubview(titleLabel)
        titleLabel.top(to: view, offset: 80.0)
        titleLabel.left(to: view, offset: verticalPadding)
        
        self.view.addSubview(dividerView)
        dividerView.height(0.5)
        dividerView.topToBottom(of: titleLabel, offset: 20.0)
        dividerView.left(to: view, offset: verticalPadding)
        dividerView.right(to: view, offset: -verticalPadding)
        
        self.view.addSubview(contactLaterLabel)
        contactLaterLabel.left(to: dividerView)
        contactLaterLabel.right(to: dividerView)
        contactLaterLabel.topToBottom(of: dividerView, offset: verticalPadding)
        
        self.view.addSubview(subDividerView)
        subDividerView.topToBottom(of: contactLaterLabel, offset: verticalPadding)
        subDividerView.height(to: dividerView)
        subDividerView.left(to: dividerView)
        subDividerView.right(to: dividerView)
        
        self.view.addSubview(contactLaterSubLabel)
        contactLaterSubLabel.topToBottom(of: subDividerView, offset: verticalPadding)
        contactLaterSubLabel.left(to: dividerView)
        contactLaterSubLabel.right(to: dividerView)
        
        self.view.addSubview(createProfileButton)
        createProfileButton.topToBottom(of: contactLaterSubLabel, offset: verticalPadding)
        createProfileButton.left(to: dividerView)
        createProfileButton.right(to: dividerView)
        createProfileButton.height(44)
        
        self.view.addSubview(visitDashboardButton)
        visitDashboardButton.topToBottom(of: createProfileButton, offset: verticalPadding)
        visitDashboardButton.left(to: dividerView)
        visitDashboardButton.right(to: dividerView)
        visitDashboardButton.height(44)
    }
}

//MARK: - @objc Functions
extension NotServicedNumberSubmittedViewController {
    @objc private func didTapButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("Profile Tapped")
        case 2:
            print("Dashboard Tapped")
        default:
            break
        }
    }
}
