//
//  AppointmentsViewController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/16/21.
//

import UIKit

final class AppointmentsViewController: UIViewController {
    var homeController: HomeViewController?
    private let logo = LogoImageView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .dsViewBackground
        
        let title = UILabel(frame: .zero)
        title.text = "Appointments List"
        title.font = UIFont.poppinsRegular(size: 18)
        title.textColor = .dsTextColor
        
        self.view.addSubview(title)
        title.centerInSuperview()
        
        self.view.addSubview(logo)
        logo.topToSuperview(offset: 26, usingSafeArea: true)
        logo.centerX(to: view)
    }
}
