//
//  AppointmentTwoCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/23/21.
//

import Foundation

import Foundation
import UIKit

class AppointmentTwoCollection : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let appointmentTwoID = "appointmentTwoID"
    
    var appointmentTwoContainer : AppointmentTwoContainer?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        
        self.isPrefetchingEnabled = false
        self.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        self.alwaysBounceVertical = false
        self.alwaysBounceHorizontal = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.canCancelContentTouches = false
        self.contentInsetAdjustmentBehavior = .never
        self.delaysContentTouches = true
        self.isPagingEnabled = true
        
        self.register(AppointmentTwoFeeder.self, forCellWithReuseIdentifier: self.appointmentTwoID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = UIScreen.main.bounds.width - 60.0
        let adjustedWidthForCells : CGFloat = (width / 2)
        
        return CGSize(width: adjustedWidthForCells, height: 70)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.appointmentTwoID, for: indexPath) as! AppointmentTwoFeeder
        
        cell.appointmentTwoCollection = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AppointmentTwoFeeder : UICollectionViewCell {
    
    var appointmentTwoCollection : AppointmentTwoCollection?
    
    lazy var selectionButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("9:00 AM", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: rubikMedium, size: 16)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 2
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dividerGrey
        cbf.backgroundColor = dividerGrey
        cbf.layer.cornerRadius = 15
        cbf.tintColor = coreBlackColor
        cbf.titleLabel?.textAlignment = .center
        cbf.tag = 2
        cbf.layer.borderWidth = 1
        cbf.layer.masksToBounds = false
        cbf.layer.borderColor = UIColor .clear.cgColor
        
        cbf.layer.shadowColor = coreOrangeColor.cgColor
        cbf.layer.shadowOpacity = 0.35
        cbf.layer.shadowOffset = CGSize(width: 0, height: 0)
        cbf.layer.shadowRadius = 0
        cbf.layer.shouldRasterize = false
        
        return cbf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.selectionButton)
        
        self.selectionButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.selectionButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3).isActive = true
        self.selectionButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        self.selectionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
