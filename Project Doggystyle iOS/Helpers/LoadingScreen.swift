//
//  LoadingScreen.swift
//  Project Doggystyle
//
//  Created by Charlie Arcodia on 5/11/21.
//

import Foundation
import UIKit

//MARK:- UNIVERSAL LOADING CLASS
class MainLoadingScreen : NSObject {
    
    var keyWindow : UIWindow = UIWindow(),
        smokeView : UIView = UIView(),
        loadingAnimation : UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    func callMainLoadingScreen() {
        
        self.keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }!
        
        self.loadingAnimation.backgroundColor = .clear
        self.loadingAnimation.layer.masksToBounds = true
        self.loadingAnimation.layer.cornerRadius = 40
        self.loadingAnimation.translatesAutoresizingMaskIntoConstraints = false
        self.loadingAnimation.color = .black
        self.loadingAnimation.hidesWhenStopped = true
        
        self.smokeView.translatesAutoresizingMaskIntoConstraints = true
        self.smokeView.frame = UIScreen.main.bounds
        self.smokeView.isUserInteractionEnabled = true
        self.smokeView.backgroundColor = UIColor (white: 0.8, alpha: 0.6)
        
        self.keyWindow.addSubview(self.smokeView)
        self.keyWindow.addSubview(self.loadingAnimation)
        
        self.loadingAnimation.centerYAnchor.constraint(equalTo: self.smokeView.centerYAnchor, constant: 0).isActive = true
        self.loadingAnimation.centerXAnchor.constraint(equalTo: self.smokeView.centerXAnchor, constant: 0).isActive = true
        self.loadingAnimation.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.loadingAnimation.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.loadingAnimation.sizeToFit()
        self.loadingAnimation.startAnimating()
        
    }
    
    func cancelMainLoadingScreen() {
        self.smokeView.removeFromSuperview()
        self.keyWindow.removeFromSuperview()
        self.loadingAnimation.removeFromSuperview()
    }
}
