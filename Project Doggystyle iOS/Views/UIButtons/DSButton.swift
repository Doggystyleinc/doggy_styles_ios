//
//  DSButton.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/3/21.
//

import UIKit

final class DSButton: UIButton {
    
    ///Button without border
    init(titleText: String, backgroundColor: UIColor, titleColor: UIColor) {
        super.init(frame: .zero)
        self.titleLabel?.font = UIFont.poppinsBold(size: 16)
        self.setTitle(titleText.capitalized, for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.adjustsFontForContentSizeCategory = true
        self.layer.cornerRadius = 14
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
        self.layer.shouldRasterize = false
        self.height(60)
    }
    
    ///Button with text + border
    init(text: String) {
        super.init(frame: .zero)
        self.titleLabel?.font = UIFont.robotoMedium(size: 18)
        self.setTitle(text.uppercased(), for: .normal)
        self.backgroundColor = .white
        self.setTitleColor(.dsGrey, for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.dsGrey.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
