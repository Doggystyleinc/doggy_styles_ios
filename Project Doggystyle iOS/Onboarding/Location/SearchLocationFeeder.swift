//
//  SearchLocationFeeder.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/22/21.
//

import Foundation
import UIKit

class FilterResultsFeeder : UITableViewCell {
    
    let placeLabel : UILabel = {
        
        let pl = UILabel()
        pl.translatesAutoresizingMaskIntoConstraints = false
        pl.textColor = coreBlackColor
        pl.text = ""
        pl.textAlignment = .left
        pl.font = UIFont(name: dsSubHeaderFont, size: 12)
        pl.numberOfLines = 2
        
        return pl
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor .clear
        self.addViews()
    }
    
    func addViews() {
        
        self.addSubview(self.placeLabel)
        
        self.placeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.placeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.placeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        self.placeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

