//
//  ProfileCollectionFeeder.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/2/21.
//

import Foundation
import UIKit


class ProfileFeeder : UICollectionViewCell {
    
    var profileCollectionSubview : ProfileCollectionSubview?
    
    lazy var mainContainer : UIButton = {
        
        let dc = UIButton(type: .system)
        dc.translatesAutoresizingMaskIntoConstraints = false
        dc.backgroundColor = coreWhiteColor
        dc.isUserInteractionEnabled = true
        dc.clipsToBounds = false
        dc.layer.masksToBounds = false
        dc.layer.shadowColor = coreBlackColor.cgColor
        dc.layer.shadowOpacity = 0.1
        dc.layer.shadowOffset = CGSize(width: 0, height: 0)
        dc.layer.shadowRadius = 7
        dc.layer.shouldRasterize = false
        dc.addTarget(self, action: #selector(self.handleButtonSelection), for: .touchUpInside)
        
       return dc
    }()
    
    let feederIcon : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.textAlignment = .center
        return nl
    }()
    
    let feederLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "This is my label here"
        nl.font = UIFont(name: dsHeaderFont, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.numberOfLines = 1
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.mainContainer)
        self.addSubview(self.feederIcon)
        self.addSubview(self.feederLabel)

        self.mainContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.mainContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        self.mainContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        self.mainContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        self.mainContainer.layer.cornerRadius = 12
        
        self.feederIcon.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 17).isActive = true
        self.feederIcon.centerYAnchor.constraint(equalTo: self.mainContainer.centerYAnchor, constant: 0).isActive = true
        self.feederIcon.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.feederIcon.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.feederLabel.leftAnchor.constraint(equalTo: self.feederIcon.rightAnchor, constant: 8).isActive = true
        self.feederLabel.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -12).isActive = true
        self.feederLabel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true

    }
    
    @objc func handleButtonSelection(sender : UIButton) {
            self.profileCollectionSubview?.handleSelection(sender : sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
