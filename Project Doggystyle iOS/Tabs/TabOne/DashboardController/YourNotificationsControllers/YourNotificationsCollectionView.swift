//
//  YourNotificationsCollectionView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/2/21.
//

import Foundation
import UIKit

class YourNotificationsCollectionView : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let yourNotifications = "yourNotifications"
    
    var yourNotificationsController : YourNotificationController?
    
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
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        
        self.register(YourNotificationsFeeder.self, forCellWithReuseIdentifier: self.yourNotifications)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.yourNotifications, for: indexPath) as! YourNotificationsFeeder
        cell.yourNotificationsCollectionView = self
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

class YourNotificationsFeeder : UICollectionViewCell {
    
    var yourNotificationsCollectionView : YourNotificationsCollectionView?
    
    let container : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = coreWhiteColor
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 15
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        cv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cv.layer.shadowOpacity = 0.05
        cv.layer.shadowOffset = CGSize(width: 2, height: 3)
        cv.layer.shadowRadius = 9
        cv.layer.shouldRasterize = false
        
        return cv
    }()
    
    let orangeCircle : UIView = {
        let oc = UIView()
        oc.translatesAutoresizingMaskIntoConstraints = false
        oc.backgroundColor = .clear
        oc.layer.borderWidth = 1
        oc.layer.borderColor = coreOrangeColor.cgColor
        oc.layer.cornerRadius = 9 / 2
        return oc
    }()
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Doggystylist Kaitlyn has arrived"
        hl.font = UIFont(name: rubikBold, size: 16)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    let subHeaderLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "It's time to bring Rex over to us."
        hl.font = UIFont(name: rubikRegular, size: 16)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.container)
        self.addSubview(self.orangeCircle)
        self.addSubview(self.headerLabel)
        self.addSubview(self.subHeaderLabel)
        
        self.container.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.container.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        
        self.orangeCircle.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 30).isActive = true
        self.orangeCircle.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 20).isActive = true
        self.orangeCircle.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.orangeCircle.widthAnchor.constraint(equalToConstant: 9).isActive = true
        
        self.headerLabel.centerYAnchor.constraint(equalTo: self.orangeCircle.centerYAnchor, constant: 0).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.orangeCircle.rightAnchor, constant: 10).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -30).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.subHeaderLabel.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 8).isActive = true
        self.subHeaderLabel.leftAnchor.constraint(equalTo: self.headerLabel.leftAnchor, constant: 0).isActive = true
        self.subHeaderLabel.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -30).isActive = true
        self.subHeaderLabel.sizeToFit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
