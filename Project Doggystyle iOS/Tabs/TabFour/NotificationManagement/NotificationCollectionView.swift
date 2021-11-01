//
//  NotificationCollectionView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/1/21.
//

import Foundation
import UIKit

class NotificationAlertsCollectionView : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let notificationAlertsID = "notificationAlertsID"
    
    let labelArrayDatasource : [String] = ["Available appointments", "Grooming updates", "Direct messages", "Appointment reminders", "Doggystyle updates"]
    
    var notificationManagement : NotificationManagement?
    
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
        self.contentInsetAdjustmentBehavior = .never
        self.delaysContentTouches = true
        
        self.register(NotificationAlertController.self, forCellWithReuseIdentifier: self.notificationAlertsID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.labelArrayDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width - 60, height: 42)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.notificationAlertsID, for: indexPath) as! NotificationAlertController
        
        cell.notificationAlertsCollectionView = self
        
        let feeder = self.labelArrayDatasource[indexPath.item]
        cell.labelType.text = feeder
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NotificationAlertController : UICollectionViewCell {
    
    var notificationAlertsCollectionView : NotificationAlertsCollectionView?
    
    let labelType : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = ""
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreBlackColor
        return thl
        
    }()
    
    lazy var allowNotificationsSwitch : UISwitch = {
        
        let bs = UISwitch()
        bs.translatesAutoresizingMaskIntoConstraints = false
        bs.tintColor = UIColor .lightGray
        bs.thumbTintColor = UIColor .white
        bs.setOn(true, animated: false)
        bs.isUserInteractionEnabled = true
        bs.addTarget(self, action: #selector(self.handleToggle(sender:)), for: .touchUpInside)
        return bs
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreWhiteColor
        self.addViews()
        
        self.allowNotificationsSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
    }
    
    func addViews() {
        
        self.addSubview(self.allowNotificationsSwitch)
        self.addSubview(self.labelType)
        
        self.allowNotificationsSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        self.allowNotificationsSwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        self.labelType.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        self.labelType.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.labelType.rightAnchor.constraint(equalTo: self.allowNotificationsSwitch.leftAnchor, constant: -20).isActive = true
        self.labelType.sizeToFit()
        
    }
    
    @objc func handleToggle(sender : UISwitch) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

