//
//  DSAlertViewController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/18/21.
//

import UIKit

final class DSAlertViewController: UIViewController {

    private let padding: CGFloat = 20.0
    
    private let containverView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .headerColor
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoRegular(size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .textColor
        label.textAlignment = .center
        label.minimumScaleFactor = 0.75
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .dsGrey
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        addContainerView()
        addTitleLabel()
        addActionButton()
        addMessageLabel()
    }
    
}


//MARK: - Layout Views
extension DSAlertViewController {
    private func addContainerView() {
        self.view.addSubview(containverView)
        
        containverView.layer.cornerRadius = 12.0
        containverView.layer.borderWidth = 2.0
        containverView.layer.borderColor = UIColor.white.cgColor
        containverView.backgroundColor = .systemBackground
        
        containverView.centerInSuperview()
        containverView.width(280)
        containverView.height(220)
    }
    
    private func addTitleLabel() {
        self.containverView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong..."
        
        titleLabel.top(to: self.containverView, offset: padding)
        titleLabel.left(to: self.containverView, offset: padding)
        titleLabel.right(to: self.containverView, offset: -padding)
        titleLabel.height(28)
    }
    
    private func addActionButton() {
        self.containverView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
        actionButton.bottom(to: self.containverView, offset: -padding)
        actionButton.left(to: self.containverView, offset: padding)
        actionButton.right(to: self.containverView, offset: -padding)
        actionButton.height(44)
    }
    
    private func addMessageLabel() {
        self.containverView.addSubview(messageLabel)
        messageLabel.text = message ?? "Unable to complete request."
        messageLabel.numberOfLines = 4
        
        messageLabel.topToBottom(of: self.titleLabel, offset: 8)
        messageLabel.left(to: self.containverView, offset: padding)
        messageLabel.right(to: self.containverView, offset: -padding)
        messageLabel.bottomToTop(of: self.actionButton, offset: -12)
    }
}


//MARK: - @objc Functions
extension DSAlertViewController {
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}

