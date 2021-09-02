//
//  SelectPackageContainer.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 9/1/21.
//


import Foundation
import UIKit

class SelectFullPackageContainer : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let selectPackageInteriorID = "selectPackageInteriorID"
    private let selectHeaderID = "selectHeaderID"
    var arrayOfIndexPaths = [IndexPath]()
  
    var costForFullPackage : String = "-"

    var servicesDropDownFeeder : ServicesDropDownFeeder?
    
    var gloablCounter : Int = 0
    var typeOfServiceSelection : String = ""

    
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
        
        if let datasource = self.servicesDropDownFeeder?.servicesDropDownCollection?.appointmentOne?.selectedProfileDataSource.count {
            return datasource
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 60, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.selectPackageInteriorID, for: indexPath) as! PackageInteriorSelectorFeeder
        
        cell.selectFullPackageContainer = self
      
        if let datasource = self.servicesDropDownFeeder?.servicesDropDownCollection?.appointmentOne?.selectedProfileDataSource {
            
            let feeder = datasource[gloablCounter],
                dogsFirstName = feeder.dog_builder_name ?? "Error",
                dogSize = feeder.dog_builder_size ?? "-"
            
            cell.nameLabel.text = dogsFirstName
            
            switch dogSize {
            case "Small": cell.costLabel.text = DogGroomingCostable.Small.description
            case "Medium": cell.costLabel.text = DogGroomingCostable.Medium.description
            case "Large": cell.costLabel.text = DogGroomingCostable.Large.description
            case "X-Large": cell.costLabel.text = DogGroomingCostable.XLarge.description
            default: print("Should not hit")
            }
            
            switch typeOfServiceSelection {
            
            case "dematting": print("We are filling the dematting cell")
            case "deshedding": print("We are filling the deshedding cell")
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
        hl.text = "name"
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
        hl.text = "cost"
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
