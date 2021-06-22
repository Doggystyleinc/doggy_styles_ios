//
//  ServicesController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/2/21.
//

import UIKit

final class ServicesController: UIViewController {
    var homeController: HomeViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = UILabel(frame: .zero)
        title.text = "Services List"
        title.font = UIFont.poppinsRegular(size: 18)
        title.textColor = .dsTextColor
        
        self.view.addSubview(title)
        title.centerInSuperview()
    }
}