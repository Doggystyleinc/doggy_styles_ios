//
//  AvailableAptCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 9/6/21.
//

import Foundation
import UIKit

class AvailableAptCollection : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let availableAptCollectionID = "availableAptCollectionID"
    
    var availableAptScreen : AvailableAptScreen?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = coreBackgroundWhite
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
        
        self.register(AvailableAptFeeder.self, forCellWithReuseIdentifier: self.availableAptCollectionID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 109)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.availableAptCollectionID, for: indexPath) as! AvailableAptFeeder
        
        cell.availableAptCollection = self
        
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

class AvailableAptFeeder : UICollectionViewCell {
    
    var availableAptCollection : AvailableAptCollection?
    
    var dogSelectionContainer : UIView = {
        
        let adc = UIView()
        adc.translatesAutoresizingMaskIntoConstraints = false
        adc.backgroundColor = coreWhiteColor
        adc.clipsToBounds = false
        adc.layer.masksToBounds = false
        adc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        adc.layer.shadowOpacity = 0.05
        adc.layer.shadowOffset = CGSize(width: 2, height: 3)
        adc.layer.shadowRadius = 9
        adc.layer.shouldRasterize = false
        adc.layer.cornerRadius = 15
        
        return adc
    }()
    
    let profileImage : UIImageView = {
        
        let pi = UIImageView()
        pi.translatesAutoresizingMaskIntoConstraints = false
        pi.backgroundColor = dividerGrey
        pi.contentMode = .scaleAspectFill
        pi.layer.masksToBounds = true
        pi.layer.cornerRadius = 24
        
       return pi
    }()
    
    let nameLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Name"
        nl.font = UIFont(name: rubikSemiBold, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.numberOfLines = 1
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var checkMarkButtonEmptyState : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.layer.masksToBounds = true
        cbf.layer.borderWidth = 3
        cbf.layer.borderColor = dividerGrey.cgColor
        cbf.layer.cornerRadius = 15

        return cbf
        
    }()
    
    let breedType : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Cocker Spaniel"
        nl.font = UIFont(name: rubikRegular, size: 16)
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
        
        self.addSubview(self.dogSelectionContainer)
        self.addSubview(self.profileImage)
        self.addSubview(self.checkMarkButtonEmptyState)
        self.addSubview(self.nameLabel)
        self.addSubview(self.breedType)

        self.dogSelectionContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        self.dogSelectionContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.dogSelectionContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.dogSelectionContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        self.profileImage.leftAnchor.constraint(equalTo: self.dogSelectionContainer.leftAnchor, constant: 27).isActive = true
        self.profileImage.centerYAnchor.constraint(equalTo: self.dogSelectionContainer.centerYAnchor, constant: 0).isActive = true
        self.profileImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.profileImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.checkMarkButtonEmptyState.rightAnchor.constraint(equalTo: self.dogSelectionContainer.rightAnchor, constant: -35).isActive = true
        self.checkMarkButtonEmptyState.centerYAnchor.constraint(equalTo: self.dogSelectionContainer.centerYAnchor, constant: 0).isActive = true
        self.checkMarkButtonEmptyState.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.checkMarkButtonEmptyState.widthAnchor.constraint(equalToConstant: 30).isActive = true

        self.nameLabel.leftAnchor.constraint(equalTo: self.profileImage.rightAnchor, constant: 18).isActive = true
        self.nameLabel.centerYAnchor.constraint(equalTo: self.profileImage.centerYAnchor, constant: -12).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.checkMarkButtonEmptyState.leftAnchor, constant: -20).isActive = true
        self.nameLabel.sizeToFit()
        
        self.breedType.leftAnchor.constraint(equalTo: self.profileImage.rightAnchor, constant: 18).isActive = true
        self.breedType.centerYAnchor.constraint(equalTo: self.profileImage.centerYAnchor, constant: 12).isActive = true
        self.breedType.rightAnchor.constraint(equalTo: self.checkMarkButtonEmptyState.leftAnchor, constant: -20).isActive = true
        self.breedType.sizeToFit()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

