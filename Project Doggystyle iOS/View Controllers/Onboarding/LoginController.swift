//
//  LoginController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/22/21.
//

import UIKit

final class LoginController: UIViewController {
    private let logo = LogoImageView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        
        
        let title = UILabel(frame: .zero)
        title.text = "Login Controller"
        title.font = UIFont.poppinsRegular(size: 18)
        title.textColor = .dsTextColor
        
        self.view.addSubview(title)
        title.centerInSuperview()
    }
}

//MARK: - Configure View Controller
extension LoginController {
    private func configureVC() {
        view.backgroundColor = .dsViewBackground
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.titleView = logo
        
    }
}
