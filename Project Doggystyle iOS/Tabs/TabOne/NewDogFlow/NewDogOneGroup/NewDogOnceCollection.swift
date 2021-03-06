//
//  NewDogOnceCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/11/21.
//


import Foundation
import UIKit

class NewDogTableView : UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private let newDogOneID = "newDogOneID"
    
    var newDogSearchBreedSubview : NewDogSearchBreedSubview?
    
    var newDogArray : [String] = [String]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = coreWhiteColor
        self.delegate = self
        self.dataSource = self
        self.alpha = 1
        self.isHidden = false
        self.layer.masksToBounds = true
        self.keyboardDismissMode = .interactive
        self.separatorStyle = .none
        self.layer.cornerRadius = 10
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.register(NewDogOneFeeder.self, forCellReuseIdentifier: self.newDogOneID)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newDogOneID, for: indexPath) as! NewDogOneFeeder
        cell.selectionStyle = .none
        
        if self.newDogArray.count != 0 {
            let feeder = self.newDogArray[indexPath.item]
            cell.breedLabel.text = feeder
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newDogArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let feeder = self.newDogArray[indexPath.item]
        self.newDogSearchBreedSubview?.newDogOne?.fillBreed(breedType: feeder)
        self.newDogSearchBreedSubview?.centerConstraint?.constant = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NewDogOneFeeder : UITableViewCell {
    
    let breedLabel : UILabel = {
        
        let pl = UILabel()
        pl.translatesAutoresizingMaskIntoConstraints = false
        pl.textColor = coreBlackColor
        pl.text = ""
        pl.textAlignment = .left
        pl.font = UIFont(name: rubikRegular, size: 18)
        pl.numberOfLines = 1
        pl.adjustsFontSizeToFitWidth = true
        
        return pl
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor .clear
        self.addViews()
    }
    
    func addViews() {
        
        self.addSubview(self.breedLabel)
        
        self.breedLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        self.breedLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.breedLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.breedLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


