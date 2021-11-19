//
//  YourReferralSelectorSwitch.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/22/21.
//


import Foundation
import UIKit

class YourReferralSelectorSwitch : UIView {
    
    var yourReferralContainer : YourReferralContainer?,
        leftConstraint : NSLayoutConstraint?
    
    lazy var pendingLabel : UIButton = {
        
        let ul = UIButton(type : .system)
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.setTitle("Pending", for: .normal)
        ul.tintColor = coreOrangeColor
        ul.titleLabel?.font = UIFont(name: rubikBold, size: 13)
        ul.backgroundColor = .clear
        ul.layer.masksToBounds = true
        ul.layer.cornerRadius = 26 / 2
        ul.tag = 1
        ul.addTarget(self, action: #selector(self.selectorChange(sender:)), for: .touchUpInside)
        
        return ul
        
    }()
    
    lazy var rewardsLabel : UIButton = {
        
        let ul = UIButton(type : .system)
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.setTitle("Rewards", for: .normal)
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
        
        self.addSubview(self.pendingLabel)
        self.addSubview(self.rewardsLabel)
        self.addSubview(self.orangeView)
        
        let width = UIScreen.main.bounds.width - 60
        
        self.pendingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3).isActive = true
        self.pendingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.pendingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.pendingLabel.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        
        self.rewardsLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        self.rewardsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.rewardsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.rewardsLabel.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        
        self.leftConstraint = self.orangeView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3)
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
            
            self.pendingLabel.tintColor = coreOrangeColor
            self.rewardsLabel.tintColor = coreBlackColor
            self.yourReferralContainer?.isPendingSelected = true
            self.yourReferralContainer?.runDataEngine()
            self.yourReferralContainer?.yourReferralCollection.shouldHideFooter = true
            
        case 2:
            
            UIView.animate(withDuration: 0.2) {
                self.leftConstraint?.constant = (width / 2) - 3
                self.layoutIfNeeded()
            }
            
            self.pendingLabel.tintColor = coreBlackColor
            self.rewardsLabel.tintColor = coreOrangeColor
            self.yourReferralContainer?.isPendingSelected = false
            self.yourReferralContainer?.runDataEngine()
            self.yourReferralContainer?.yourReferralCollection.shouldHideFooter = false

            
        default: print("Never called")
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
