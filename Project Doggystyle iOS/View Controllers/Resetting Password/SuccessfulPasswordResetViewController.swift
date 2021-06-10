//
//  SuccessfulPasswordResetViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/13/21.
//

import UIKit

final class SuccessfulPasswordResetViewController: UIViewController {
    private let verticalPadding: CGFloat = 30.0
    
    private let successTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoBold(size: 24)
        label.text = "Successful reset!"
        label.textColor = .headerColor
        return label
    }()
    
    private let successSubTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.robotoRegular(size: 18)
        label.text = "Your password has successfully been reset."
        label.numberOfLines = 2
        label.textColor = .textColor
        return label
    }()
    
    private let dividerView = DividerView()
    
    private let dashboardButton: DSButton = {
        let button = DSButton(titleText: "Visit Dashboard", backgroundColor: .dsGrey, titleColor: .white)
        button.addTarget(self, action: #selector(didTapDashboard(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.addViews()
    }
}

//MARK: - Configure Views
extension SuccessfulPasswordResetViewController {
    private func addViews() {
        self.view.addSubview(successTitle)
        successTitle.top(to: self.view, offset: 80.0)
        successTitle.left(to: self.view, offset: verticalPadding)
        
        self.view.addSubview(dividerView)
        dividerView.height(0.5)
        dividerView.topToBottom(of: self.successTitle, offset: 20.0)
        dividerView.left(to: self.view, offset: verticalPadding)
        dividerView.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(successSubTitle)
        successSubTitle.topToBottom(of: self.dividerView, offset: 20.0)
        successSubTitle.left(to: self.view, offset: verticalPadding)
        successSubTitle.right(to: self.view, offset: -verticalPadding)
        
        self.view.addSubview(dashboardButton)
        dashboardButton.height(44.0)
        dashboardButton.topToBottom(of: self.successSubTitle, offset: 20.0)
        dashboardButton.left(to: self.view, offset: verticalPadding)
        dashboardButton.right(to: self.view, offset: -verticalPadding)
    }
}


//MARK: - @objc Functions
extension SuccessfulPasswordResetViewController {
    @objc private func didTapDashboard(_ sender: UIButton) {
        self.navigationController?.pushViewController(EmailSignInViewController(), animated: true)
    }
}
