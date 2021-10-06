//
//  DSSMSTextField.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/25/21.
//

import UIKit

class DSSMSTextField: UITextField {

    ///SMS Textfield
    init() {
        super.init(frame: .zero)
        let placeholder = NSAttributedString(string: "-", attributes: [NSAttributedString.Key.foregroundColor: UIColor.dsGray])
        self.attributedPlaceholder = placeholder
        self.textAlignment = .center
        self.textColor = UIColor.dsTextColor
        self.font = UIFont.poppinsSemiBold(size: 18)
        self.allowsEditingTextAttributes = false
        self.autocorrectionType = .no
        self.backgroundColor = .white
        self.returnKeyType = UIReturnKeyType.done
        self.keyboardType = .numberPad
        self.isSecureTextEntry = false
        self.leftViewMode = .always
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
        self.layer.shouldRasterize = false
        self.layer.cornerRadius = 12
        self.height(70)
        self.width(70)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
