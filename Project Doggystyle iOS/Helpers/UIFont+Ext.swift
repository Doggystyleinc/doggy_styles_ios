//
//  UIFont+Ext.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/3/21.
//

import UIKit

extension UIFont {
    static func robotoBold(size fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: fontSize)!
    }
    
    static func robotoMedium(size fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: fontSize)!
    }
    
    static func robotoRegular(size fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: fontSize)!
    }
}

extension UIFont {
    static func poppinsRegular(size fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: fontSize)!
    }
    
    static func poppinsBold(size fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Bold", size: fontSize)!
    }
    
    static func poppinsSemiBold(size fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: fontSize)!
    }
}
