//
//  PaymentController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/20/21.
//

import UIKit

final class PaymentController: UIViewController {
    private let rightIcon = DSNavButton(imageName: Constants.closeButton)
    private let logo = LogoImageView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dsViewBackground
        
        let title = UILabel(frame: .zero)
        title.text = "Payment Options"
        title.font = UIFont.poppinsRegular(size: 18)
        title.textColor = .dsTextColor
        
        self.view.addSubview(title)
        title.centerInSuperview()
        
        logo.image = nil
        self.view.addSubview(logo)
        logo.topToSuperview(offset: 26, usingSafeArea: true)
        logo.centerX(to: view)
        
        self.view.addSubview(rightIcon)
        rightIcon.leftToRight(of: logo, offset: 70)
        rightIcon.topToSuperview(offset: 14, usingSafeArea: true)
        
        rightIcon.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }

    @objc private func didTapClose() {
        self.dismiss(animated: true, completion: nil)
    }
}
