//
//  UIButton+Ext.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/18/21.
//

import UIKit

extension UIButton {
    //Switch background + enable/disable button
    func enable(_ enable: Bool) {
        self.isEnabled = enable ? true : false
        self.backgroundColor = enable ? UIColor.systemGreen : UIColor.dsGrey
    }
}


