//
//  MyPetsController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/20/21.
//

import UIKit

final class MyPetsController: UIViewController {
    private let rightIcon = DSNavButton(imageName: Constants.closeButton, tagNumber: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dsViewBackground
        
        let title = UILabel(frame: .zero)
        title.text = "Client Pets"
        title.font = UIFont.poppinsRegular(size: 18)
        title.textColor = .dsTextColor
        
        self.view.addSubview(title)
        title.centerInSuperview()
        
        self.view.addSubview(rightIcon)
        rightIcon.right(to: view, offset: -20)
        rightIcon.topToSuperview(offset: 20, usingSafeArea: true)
        
        rightIcon.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }

    @objc private func didTapClose() {
        self.dismiss(animated: true, completion: nil)
    }
}
