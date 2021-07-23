//
//  MainLoadingScreen.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/7/21.
//

import Foundation
import Lottie
import UIKit

class MainLoadingScreen : NSObject {
    
    var keyWindow : UIWindow = UIWindow()
    
    var smokeView : UIView = UIView()
    
    var loadingAnimation : AnimationView = AnimationView()
    
    func callMainLoadingScreen(lottiAnimationName : String) {
        
        self.keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }!
        
        let pawAnimation = Animation.named(lottiAnimationName)
        self.loadingAnimation.animation = pawAnimation
        self.loadingAnimation.loopMode = .loop
        self.loadingAnimation.backgroundBehavior = .pauseAndRestore
        self.loadingAnimation.animationSpeed = 2
        self.loadingAnimation.backgroundColor = .clear
        self.loadingAnimation.layer.masksToBounds = true
        self.loadingAnimation.layer.cornerRadius = 40
        self.loadingAnimation.translatesAutoresizingMaskIntoConstraints = false
        
        self.smokeView.translatesAutoresizingMaskIntoConstraints = true
        self.smokeView.frame = UIScreen.main.bounds
        self.smokeView.isUserInteractionEnabled = true
        self.smokeView.backgroundColor = coreBackgroundWhite.withAlphaComponent(0.8)
        
        self.smokeView.alpha = 1
        self.loadingAnimation.alpha = 1
        
        self.keyWindow.addSubview(self.smokeView)
        self.keyWindow.addSubview(self.loadingAnimation)
        
        self.loadingAnimation.centerYAnchor.constraint(equalTo: self.smokeView.centerYAnchor, constant: 0).isActive = true
        self.loadingAnimation.centerXAnchor.constraint(equalTo: self.smokeView.centerXAnchor, constant: 0).isActive = true
        self.loadingAnimation.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.2).isActive = true
        self.loadingAnimation.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.2).isActive = true
        
        
        self.loadingAnimation.play()
        
    }
    
    func cancelMainLoadingScreen() {
        
        UIView.animate(withDuration: 0.5) {
            
            self.smokeView.alpha = 0
            self.loadingAnimation.alpha = 0
            
        } completion: { (isComplete) in
            
            self.loadingAnimation.stop()

            self.smokeView.removeFromSuperview()
            self.keyWindow.removeFromSuperview()
            self.loadingAnimation.removeFromSuperview()
            
        }
    }
}
