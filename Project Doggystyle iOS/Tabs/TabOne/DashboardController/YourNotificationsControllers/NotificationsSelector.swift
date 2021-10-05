//
//  NotificationsSelector.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/2/21.
//

import Foundation
import UIKit

class NotificationsSelector : UIView {
    
    var yourNotificationController : YourNotificationController?,
        leftConstraint : NSLayoutConstraint?
    
    lazy var upcomingLabel : UIButton = {
        
        let ul = UIButton(type : .system)
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.setTitle("New", for: .normal)
        ul.tintColor = coreOrangeColor
        ul.titleLabel?.font = UIFont(name: rubikBold, size: 13)
        ul.backgroundColor = .clear
        ul.layer.masksToBounds = true
        ul.layer.cornerRadius = 26 / 2
        ul.tag = 1
        ul.addTarget(self, action: #selector(self.selectorChange(sender:)), for: .touchUpInside)
        
        return ul
        
    }()
    
    lazy var previousLabel : UIButton = {
        
        let ul = UIButton(type : .system)
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.setTitle("Read", for: .normal)
        ul.tintColor = coreBlackColor
        ul.titleLabel?.font = UIFont(name: rubikBold, size: 13)
        ul.backgroundColor = .clear
        ul.layer.masksToBounds = true
        ul.layer.cornerRadius = 26 / 2
        ul.tag = 2
        ul.addTarget(self, action: #selector(self.selectorChange(sender:)), for: .touchUpInside)
        
        return ul
        
    }()
    
    let orangeView : UIView = {
        
        let ov = UIView()
        ov.translatesAutoresizingMaskIntoConstraints = false
        ov.backgroundColor = coreOrangeColor.withAlphaComponent(0.1)
        ov.layer.masksToBounds = true
        ov.layer.cornerRadius = 26 / 2
        
        return ov
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreWhiteColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = coreWhiteColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 32/2
        
        self.addViews()
    }
    
    func addViews() {
        
        self.addSubview(self.upcomingLabel)
        self.addSubview(self.previousLabel)
        self.addSubview(self.orangeView)
        
        let width = UIScreen.main.bounds.width - 60
        
        self.upcomingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3).isActive = true
        self.upcomingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.upcomingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.upcomingLabel.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        
        self.previousLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        self.previousLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.previousLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.previousLabel.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        
        leftConstraint = self.orangeView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3)
        self.leftConstraint?.isActive = true
        self.orangeView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.orangeView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.orangeView.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        
    }
    
    @objc func selectorChange(sender : UIButton) {
        
        UIDevice.vibrateLight()
        
        let width = UIScreen.main.bounds.width - 60
        
        switch sender.tag {
        
        case 1:
            
            UIView.animate(withDuration: 0.2) {
                self.leftConstraint?.constant = 3
                self.layoutIfNeeded()
            }
            
            self.upcomingLabel.tintColor = coreOrangeColor
            self.previousLabel.tintColor = coreBlackColor
            
        case 2:
            
            UIView.animate(withDuration: 0.2) {
                self.leftConstraint?.constant = ((width / 2) - 3)
                self.layoutIfNeeded()
            }
            
            self.upcomingLabel.tintColor = coreBlackColor
            self.previousLabel.tintColor = coreOrangeColor
            
        default: print("Never called")
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
