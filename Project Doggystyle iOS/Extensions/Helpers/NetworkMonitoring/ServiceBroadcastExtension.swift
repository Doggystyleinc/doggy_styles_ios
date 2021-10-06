//
//  ServiceBroadcastExtension.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/6/21.
//

import Foundation
import UIKit

class NoServiceFlag : NSObject {
    
    var keyWindow : UIWindow = UIWindow(),
        homeViewController : HomeViewController?,
        statusBarHeight : CGFloat = 0.0
    
    let flagView : UIView = {
        
        let fv = UIView()
        fv.translatesAutoresizingMaskIntoConstraints = false
        fv.backgroundColor = coreOrangeColor
        fv.isUserInteractionEnabled = false
        fv.alpha = 0.0
        fv.layer.zPosition = 91
        return fv
        
    }()
    
    var noServiceLabel : UILabel = {
        
        let nsl = UILabel()
        nsl.translatesAutoresizingMaskIntoConstraints = false
        nsl.backgroundColor = coreOrangeColor
        nsl.textColor = coreWhiteColor
        nsl.text = "Looking for service"
        nsl.textAlignment = .left
        nsl.adjustsFontSizeToFitWidth = true
        nsl.font = UIFont(name: dsSubHeaderFont, size: 17)
        
        return nsl
    }()
    
    var activityLoader : UIActivityIndicatorView = {
        
        let al = UIActivityIndicatorView(style: .medium)
        al.tintColor = coreWhiteColor
        al.hidesWhenStopped = true
        al.translatesAutoresizingMaskIntoConstraints = false
        al.color = coreWhiteColor
        
        return al
    }()
    
    func callFlagWindow() {
        
        DispatchQueue.main.async {
            
            self.keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }!
            
            self.keyWindow.addSubview(self.flagView)
            self.flagView.addSubview(self.activityLoader)
            self.flagView.addSubview(self.noServiceLabel)
            
            self.flagView.topAnchor.constraint(equalTo: self.keyWindow.topAnchor, constant: 0).isActive = true
            self.flagView.leftAnchor.constraint(equalTo: self.keyWindow.leftAnchor, constant: 0).isActive = true
            self.flagView.rightAnchor.constraint(equalTo: self.keyWindow.rightAnchor, constant: 0).isActive = true
            
            self.activityLoader.bottomAnchor.constraint(equalTo: self.flagView.bottomAnchor, constant: -9).isActive = true
            self.activityLoader.leftAnchor.constraint(equalTo: self.flagView.leftAnchor, constant: 20).isActive = true
            self.activityLoader.sizeToFit()
            
            self.noServiceLabel.leftAnchor.constraint(equalTo: self.activityLoader.rightAnchor, constant: 15).isActive = true
            self.noServiceLabel.centerYAnchor.constraint(equalTo: self.activityLoader.centerYAnchor, constant: 0).isActive = true
            self.noServiceLabel.rightAnchor.constraint(equalTo: self.flagView.rightAnchor, constant: -20).isActive = true
            self.noServiceLabel.sizeToFit()
            
            self.activityLoader.startAnimating()
            
            let insets = self.keyWindow.safeAreaInsets.top
            
            if insets > CGFloat(30.0) {
                self.statusBarHeight = insets
            } else {
                self.statusBarHeight = 30
            }
            
            self.flagView.heightAnchor.constraint(equalToConstant: self.statusBarHeight * 2.0).isActive = true
            
            UIView.animate(withDuration: 0.5) {
                self.flagView.alpha = 1.0
            }
        }
    }
    
    func cancelFlagView() {
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.5) {
                self.flagView.alpha = 0.0
            } completion: { (true) in
                self.keyWindow.removeFromSuperview()
            }
        }
    }
}
