//
//  DSContainerView.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/17/21.
//

import UIKit

class DSContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 20.0
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
