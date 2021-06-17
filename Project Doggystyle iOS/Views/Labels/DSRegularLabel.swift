//
//  DSRegularLabel.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/16/21.
//


import UIKit

final class DSRegularLabel: UILabel {

    init(title: String, size: CGFloat) {
        super.init(frame: .zero)
        self.text = title
        self.font = UIFont.poppinsRegular(size: size)
        self.textColor = .dsTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
