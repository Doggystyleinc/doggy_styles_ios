//
//  FullPackageContainer.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 9/1/21.
//

import Foundation
import UIKit

class FullPackageContainer : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let packageInteriorIR = "packageInteriorIR"
    private let headerID = "headerID"
    
    var costForFullPackage : String = "-"

    var appointmentOne : AppointmentOne?
    
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
        self.isScrollEnabled = true
        self.contentInsetAdjustmentBehavior = .never
        
        self.layer.shadowColor = coreOrangeColor.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 4
        self.layer.shouldRasterize = false
        self.layer.cornerRadius = 15
        self.layer.borderColor = coreOrangeColor.cgColor
        self.layer.borderWidth = 0.5
        
        self.register(PackageInteriorSelector.self, forCellWithReuseIdentifier: self.packageInteriorIR)
        self.register(FullPackageHeaderFeeder.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
      return CGSize(width: UIScreen.main.bounds.width - 60, height: 80)
        
    }

     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

         let cell = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerID, for: indexPath) as! FullPackageHeaderFeeder
        
         cell.fullPackageContainer = self

         cell.costLabelFP.text = self.costForFullPackage
            
         return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let datasource = self.appointmentOne?.selectedProfileDataSource.count {
            return datasource
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width - 60, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.packageInteriorIR, for: indexPath) as! PackageInteriorSelector
        
        cell.fullPackageContainer = self
        
        if let dataSource = self.appointmentOne?.selectedProfileDataSource {
            
            let feeder = dataSource[indexPath.item],
                dogsFirstName = feeder.dog_builder_name ?? "Pup",
                dogSize = feeder.dog_builder_size ?? "Medium"
            
            cell.nameLabel.text = dogsFirstName
            
            switch dogSize {
            case "Small": cell.costLabel.text = DogGroomingCostable.Small.description
            case "Medium": cell.costLabel.text = DogGroomingCostable.Medium.description
            case "Large": cell.costLabel.text = DogGroomingCostable.Large.description
            case "X-Large": cell.costLabel.text = DogGroomingCostable.XLarge.description
            default: print("Should not hit")
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
    
    @objc func handleSelection(sender: UIButton) {
        self.appointmentOne?.handleMainContainerTaps()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class PackageInteriorSelector : UICollectionViewCell {
    
    var fullPackageContainer : FullPackageContainer?
   
    let nameLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Rex"
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
    
    @objc func handleContainerTap(sender : UIButton) {
        
        self.fullPackageContainer?.handleSelection(sender : sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FullPackageHeaderFeeder : UICollectionViewCell {

    var fullPackageContainer : FullPackageContainer?

    lazy var mainContainerFP : UIButton = {

        let cv = UIButton(type : .system)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = coreWhiteColor
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false

        cv.addTarget(self, action: #selector(self.handleContainerTap), for: .touchUpInside)

       return cv

    }()

    let iconImageViewFP : UIButton = {

        let iv = UIButton(type: .system)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = dividerGrey
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 20
        iv.isUserInteractionEnabled = false
        iv.tintColor = coreWhiteColor
        iv.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
        iv.setTitle(String.fontAwesomeIcon(name: .shower), for: .normal)
        iv.backgroundColor = coreOrangeColor

       return iv
    }()

    let headerLabelFP : UILabel = {

        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Full Package"
        hl.font = UIFont(name: rubikMedium, size: 18)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.isUserInteractionEnabled = false

        return hl
    }()

    let costLabelFP : UILabel = {

        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = ""
        hl.font = UIFont(name: rubikRegular, size: 16)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.isUserInteractionEnabled = false

        return hl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .clear
        self.addViews()
    }

    func addViews() {

        self.addSubview(self.mainContainerFP)

        self.mainContainerFP.addSubview(self.iconImageViewFP)
        self.mainContainerFP.addSubview(self.costLabelFP)
        self.mainContainerFP.addSubview(self.headerLabelFP)

        self.mainContainerFP.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.mainContainerFP.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.mainContainerFP.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.mainContainerFP.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true

        self.iconImageViewFP.leftAnchor.constraint(equalTo: self.mainContainerFP.leftAnchor, constant: 25).isActive = true
        self.iconImageViewFP.topAnchor.constraint(equalTo: self.mainContainerFP.topAnchor, constant: 20).isActive = true
        self.iconImageViewFP.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.iconImageViewFP.widthAnchor.constraint(equalToConstant: 40).isActive = true

        self.costLabelFP.rightAnchor.constraint(equalTo: self.mainContainerFP.rightAnchor, constant: -25).isActive = true
        self.costLabelFP.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.costLabelFP.centerYAnchor.constraint(equalTo: self.iconImageViewFP.centerYAnchor).isActive = true
        self.costLabelFP.bottomAnchor.constraint(equalTo: self.mainContainerFP.bottomAnchor, constant: 0).isActive = true

        self.headerLabelFP.leftAnchor.constraint(equalTo: self.iconImageViewFP.rightAnchor, constant: 10).isActive = true
        self.headerLabelFP.rightAnchor.constraint(equalTo: self.costLabelFP.leftAnchor, constant: -10).isActive = true
        self.headerLabelFP.centerYAnchor.constraint(equalTo: self.iconImageViewFP.centerYAnchor).isActive = true
        self.headerLabelFP.bottomAnchor.constraint(equalTo: self.mainContainerFP.bottomAnchor).isActive = true

    }

    @objc func handleContainerTap(sender : UIButton) {

        self.fullPackageContainer?.handleSelection(sender : sender)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
