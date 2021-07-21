//
//  TextField+Ext.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/6/21.
//

import UIKit

extension UITextField {
    //Toggle Password Image
    func setPasswordToggleImage(_ button: UIButton) {
        if isSecureTextEntry {
            button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            button.tintColor = .dsGrey
        } else {
            button.setImage(UIImage(systemName: "eye"), for: .normal)
            button.tintColor = .dsGrey
        }
    }
    
    func enablePasswordToggle() {
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    
    //Enable Left Padding
    func setLeftPaddingPoints(_ amount:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
   
    //Show/Hide Password
    @objc func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
}

extension UITextField {
    func setupLeftImage(imageName: String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(systemName: imageName)
        
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 40))
        imageContainerView.addSubview(imageView)
        
        self.leftView = imageContainerView
        self.leftViewMode = .always
        self.tintColor = .lightGray
    }
}
