//
//  PackageSelectionCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/30/21.
//

import Foundation
import UIKit

class PricingCollectionOne : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let pricingOneID = "pricingOneID"
    
    var servicesDropDownFooterFeeder : ServicesDropDownFooterFeeder?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = .purple
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
        self.contentInsetAdjustmentBehavior = .never
        self.delaysContentTouches = true
        
        self.register(PricingFeederOne.self, forCellWithReuseIdentifier: self.pricingOneID)
        print("Called inside here")

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let preferredDatasource = self.servicesDropDownFooterFeeder?.servicesDropDownCollection?.appointmentOne?.petAppointmentCollection.selectedProfileDataSource {
            
            if preferredDatasource.count > 0 {
                
                return preferredDatasource.count
                
            } else {
                
                return 0
                
            }
            
        } else {
            print("Returning zero here")
            return 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let preferredDatasource = self.servicesDropDownFooterFeeder?.servicesDropDownCollection?.appointmentOne?.petAppointmentCollection.selectedProfileDataSource {
            
            if preferredDatasource.count > 0 {
                
                switch indexPath.item {
                case 0: return CGSize(width: UIScreen.main.bounds.width, height: 100)
                default: return CGSize(width: UIScreen.main.bounds.width, height: 75)
                }
                
            } else {
                return CGSize.zero
            }
            
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.pricingOneID, for: indexPath) as! PricingFeederOne
        
        cell.pricingCollectionOne = self
        
        if let preferredDatasource = self.servicesDropDownFooterFeeder?.servicesDropDownCollection?.appointmentOne?.petAppointmentCollection.selectedProfileDataSource {

            if preferredDatasource.count > 0 {
                
                cell.doggyProfileDataSource = preferredDatasource[indexPath.item]
                cell.isHidden = false
                
                switch indexPath.item {
                
                case 0: cell.packageName.text = "Full Package"
                default: cell.packageName.text = ""
                
                }
                
            } else {
                cell.isHidden = true
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

class PricingFeederOne : UICollectionViewCell {
    
    var pricingCollectionOne : PricingCollectionOne?
    
    var doggyProfileDataSource : DoggyProfileDataSource? {
        
        didSet {
        
        if let feeder = doggyProfileDataSource {
            
            let usersName = feeder.dog_builder_name ?? "Incognito"
            let profileImage = feeder.dog_builder_profile_url ?? "nil"
            
            self.puppyNameLabel.text = usersName
            self.doggyProfileImage.loadImageGeneralUse(profileImage) { complete in
                print("Loaded the doggy profile photo")
            }
        }
    }
}
    
    let containerView : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .green
        
       return cv
    }()
    
    let packageName : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Full Package"
        hl.font = UIFont(name: rubikBold, size: 18)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.isUserInteractionEnabled = false

        return hl
    }()
    
    let puppyNameLabel : UILabel = {
        
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
        hl.text = "$119"
        hl.font = UIFont(name: rubikRegular, size: 14)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .right
        hl.isUserInteractionEnabled = false

        return hl
    }()
    
    lazy var doggyProfileImage : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = coreOrangeColor.withAlphaComponent(0.2)
        vi.contentMode = .scaleAspectFill
        vi.isUserInteractionEnabled = true
        vi.layer.masksToBounds = true
        
       return vi
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .green
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.containerView)
        self.addSubview(self.packageName)
        self.addSubview(self.doggyProfileImage)
        self.addSubview(self.costLabel)
        self.addSubview(self.puppyNameLabel)

        self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true

        self.packageName.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 33).isActive = true
        self.packageName.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0).isActive = true
        self.packageName.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 2).isActive = true
        self.packageName.sizeToFit()
        
        self.doggyProfileImage.leftAnchor.constraint(equalTo: self.packageName.leftAnchor, constant: 0).isActive = true
        self.doggyProfileImage.topAnchor.constraint(equalTo: self.packageName.bottomAnchor, constant: 17).isActive = true
        self.doggyProfileImage.heightAnchor.constraint(equalToConstant: 42).isActive = true
        self.doggyProfileImage.widthAnchor.constraint(equalToConstant: 42).isActive = true
        self.doggyProfileImage.layer.cornerRadius = 42/2
        
        self.costLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -30).isActive = true
        self.costLabel.centerYAnchor.constraint(equalTo: self.doggyProfileImage.centerYAnchor, constant: 0).isActive = true
        self.costLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        self.costLabel.sizeToFit()
        
        self.puppyNameLabel.leftAnchor.constraint(equalTo: self.doggyProfileImage.rightAnchor, constant: 10).isActive = true
        self.puppyNameLabel.rightAnchor.constraint(equalTo: self.costLabel.leftAnchor, constant: -10).isActive = true
        self.puppyNameLabel.centerYAnchor.constraint(equalTo: self.doggyProfileImage.centerYAnchor, constant: 0).isActive = true
        self.puppyNameLabel.sizeToFit()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

