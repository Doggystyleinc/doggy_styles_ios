//
//  NotificationCollectionView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/18/21.
//


import Foundation
import UIKit

class NotificationCollectionView : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let notificationID = "servicesID"
    
    var notificationManagement : NotificationManagement?
    
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
        
        self.register(NotificationFeeder.self, forCellWithReuseIdentifier: self.notificationID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: 88)
        } else if indexPath.item == 1 {
            return CGSize(width: UIScreen.main.bounds.width, height: 310)
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 185)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.notificationID, for: indexPath) as! NotificationFeeder
        
        cell.notificationCollectionView = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NotificationFeeder : UICollectionViewCell {
    
    var notificationCollectionView : NotificationCollectionView?
    
    var containerView : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = coreWhiteColor
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        cv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cv.layer.shadowOpacity = 0.05
        cv.layer.shadowOffset = CGSize(width: 2, height: 3)
        cv.layer.shadowRadius = 9
        cv.layer.shouldRasterize = false
        cv.layer.cornerRadius = 15
        
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.containerView)
        
        self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
