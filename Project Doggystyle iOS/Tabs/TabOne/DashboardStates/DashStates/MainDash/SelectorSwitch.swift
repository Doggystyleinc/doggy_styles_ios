//
//  SelectorSwitch.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/1/21.
//

import Foundation
import UIKit

class SelectorSwitch : UIView {
    
    var dashMainView : DashMainView?
    
    let upcomingLabel : UILabel = {
        
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.text = "Upcoming"
        ul.textColor = coreOrangeColor
        ul.font = UIFont(name: rubikBold, size: 13)
        ul.backgroundColor = coreOrangeColor.withAlphaComponent(0.1)
        ul.textAlignment = .center
        ul.layer.masksToBounds = true
        ul.layer.cornerRadius = 26 / 2
        
       return ul
        
    }()
    
    let previousLabel : UILabel = {
        
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.text = "Previous"
        ul.textColor = coreBlackColor
        ul.font = UIFont(name: rubikBold, size: 13)
        ul.backgroundColor = .clear
        ul.textAlignment = .center
        ul.layer.masksToBounds = true
        ul.layer.cornerRadius = 26 / 2
        
       return ul
        
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

        let width = UIScreen.main.bounds.width - 60
        
        self.upcomingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3).isActive = true
        self.upcomingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.upcomingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.upcomingLabel.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        
        self.previousLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        self.previousLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.previousLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.previousLabel.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
