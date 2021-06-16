//
//  DSNavButton.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/15/21.
//

import UIKit

final class DSNavButton: UIButton {
    
    init(imageName: String) {
        super.init(frame: .zero)
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        self.setImage(image, for: .normal)
        self.contentMode = .scaleAspectFit
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
        self.height(54)
        self.width(54)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
