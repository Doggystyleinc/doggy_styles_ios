//
//  SelectPackageContainer.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 9/1/21.
//


import Foundation
import UIKit

class SelectFullPackageContainer : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let selectPackageInteriorID = "selectPackageInteriorID",
                selectHeaderID = "selectHeaderID"
    
    var costForFullPackage : String = "-",
        servicesDropDownFeeder : ServicesDropDownFeeder?,
        typeOfServiceSelection : String = ""
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = coreWhiteColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        self.isPrefetchingEnabled = false
        self.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        self.alwaysBounceVertical = true
        self.alwaysBounceHorizontal = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.canCancelContentTouches = false
        self.delaysContentTouches = true
        self.isScrollEnabled = false
        self.contentInsetAdjustmentBehavior = .never
        self.register(PackageInteriorSelectorFeeder.self, forCellWithReuseIdentifier: self.selectPackageInteriorID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return globalArrayOfDicts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width - 60, height: 40)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.selectPackageInteriorID, for: indexPath) as! PackageInteriorSelectorFeeder
        
        cell.selectFullPackageContainer = self
        
        if let _ = self.servicesDropDownFeeder?.servicesDropDownCollection?.appointmentOne?.selectedProfileDataSource {
            
            let feeder = globalArrayOfDicts[indexPath.item]
            
            for (key ,value) in feeder {
                
                let name = key
                let cost = value
                
                cell.nameLabel.text = name
                cell.costLabel.text = cost
                
            }
            
            switch typeOfServiceSelection {
            
            case "dematting": print("Calling dematting")
            case "deshedding": print("Calling deshsedding")
            default: print("here now")
                
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class PackageInteriorSelectorFeeder : UICollectionViewCell {
    
    var selectFullPackageContainer : SelectFullPackageContainer?
    
    let nameLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = ""
        hl.font = UIFont(name: rubikRegular, size: 14)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.isUserInteractionEnabled = false
        
        return hl
    }()
    
    let costLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = ""
        hl.font = UIFont(name: rubikRegular, size: 14)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .right
        hl.isUserInteractionEnabled = false
        
        return hl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreWhiteColor
        self.addViews()
    }
    
    func addViews() {
        
        self.addSubview(self.nameLabel)
        self.addSubview(self.costLabel)
        
        self.costLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.costLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        self.costLabel.sizeToFit()
        
        self.nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        self.nameLabel.sizeToFit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
