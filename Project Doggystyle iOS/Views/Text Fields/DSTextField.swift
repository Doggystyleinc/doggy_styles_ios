//
//  DSTextField.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/23/21.
//

import UIKit

final class DSTextField: UITextField {
    
    ///No-border textfield
    init(placeholder: String) {
        super.init(frame: .zero)
        self.font = UIFont.poppinsSemiBold(size: 16)
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.borderStyle = .none
        self.layer.cornerRadius = 10.0
        self.setLeftPaddingPoints(25)
        self.backgroundColor = .white
        self.placeholder = placeholder
        self.clearButtonMode = .whileEditing
        self.spellCheckingType = .no
        self.height(60)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
