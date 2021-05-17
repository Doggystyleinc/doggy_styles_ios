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
        self.titleLabel?.font = UIFont.robotoBold(size: 18)
        self.setTitle(titleText.uppercased(), for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
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
