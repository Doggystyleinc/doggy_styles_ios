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
    var shouldHideFooter : Bool = false
    
    var yourNotificationsController : YourNotificationController?,
        notificationsArray = [NotificationModel](),
        notificationsReadArray = [NotificationModel](),
        notificationsNewArray = [NotificationModel]()
    
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
        return self.notificationsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let feeder = self.notificationsArray[indexPath.item]
        var textMessage = ""
        
        //MARK: - REFERRAL INVITES
        if feeder.notification_type == "referral_invite" {
            
            let notification_first_name = feeder.notification_first_name ?? "nil"
            let notification_last_name = feeder.notification_last_name ?? "nil"
            
            if notification_first_name == "nil" || notification_last_name == "nil" {
                textMessage = "You have been referred to the DS Application."
            } else {
                textMessage = "\(notification_first_name) \(notification_last_name) has invited you to the Doggystyle application."
            }
            
        //MARK: - WELCOME ABOARD
        } else if feeder.notification_type == "welcome_aboard" {
            textMessage = "We are sure glad to have you and look forward to grooming your puppy!"
        }
        
        let size = CGSize(width: UIScreen.main.bounds.width - 70, height: 2000),
            options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
            estimatedFrame = NSString(string: textMessage).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont(name: rubikRegular, size: 16)!], context: nil),
            estimatedHeight = estimatedFrame.height + 95.0
        
        return CGSize(width: UIScreen.main.bounds.width, height: estimatedHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.yourNotifications, for: indexPath) as! YourNotificationsFeeder
        
        cell.yourNotificationsCollectionView = self
        
        let feeder = self.notificationsArray[indexPath.item]
        
        cell.notificationModel = feeder
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func handleCellSelection(sender: UIButton) {
        
        let selectedButtonCell = sender.superview as! UICollectionViewCell
        guard let indexPath = self.indexPath(for: selectedButtonCell) else {return}
        
        //MARK: - LETS BLOCK THEM HERE
        if self.notificationsArray.count == 0 {return}
        
        let feeder = self.notificationsArray[indexPath.item]
        let notification_has_read = feeder.notification_has_read ?? false
        
        //MARK: - LETS BLOCK THEM HERE
        if notification_has_read == true {return}
        
        let childKey = feeder.child_key ?? "nil"
        let users_full_phone_number = userProfileStruct.users_full_phone_number ?? "nil"
        
        //MARK: - LETS BLOCK THEM HERE
        if childKey == "nil" || users_full_phone_number == "nil" {return}
        
        self.yourNotificationsController?.handleCellReadFlag(childKey : childKey, users_full_phone_number : users_full_phone_number)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YourNotificationsFeeder : UICollectionViewCell {
    
    var yourNotificationsCollectionView : YourNotificationsCollectionView?
    
    var notificationModel : NotificationModel? {
        
        didSet {
            
            let notification_type = notificationModel?.notification_type ?? "nil",
                notification_first_name = notificationModel?.notification_first_name ?? "nil",
                notification_last_name = notificationModel?.notification_last_name ?? "nil",
                headerMessage = "REFERRAL INVITE"
            
            if notification_type == "referral_invite" {
                
                var subHeaderMessage = ""
                
                if notification_first_name == "nil" || notification_last_name == "nil" {
                    subHeaderMessage = "You have been referred to the DS Application."
                } else {
                    subHeaderMessage = "\(notification_first_name) \(notification_last_name) has invited you to the Doggystyle application."
                }
                
                self.headerLabel.text = headerMessage
                self.subHeaderLabel.text = subHeaderMessage
                
            } else if notification_type == "welcome_aboard" {
                
                self.headerLabel.text = "Welcome to Doggystyle!"
                self.subHeaderLabel.text = "We are sure glad to have you and look forward to grooming your puppy!"
                
            }
        }
    }
    
    lazy var container : UIButton = {
        
        let cv = UIButton()
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
        cv.addTarget(self, action: #selector(self.handleCellSelection(sender:)), for: .touchUpInside)
        cv.isUserInteractionEnabled = true
        
        return cv
    }()
    
    let headerContainer : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.isUserInteractionEnabled = false
        
        return cv
    }()
    
    let footerContainer : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.isUserInteractionEnabled = false
        
        return cv
    }()
    
    let orangeCircle : UIView = {
        let oc = UIView()
        oc.translatesAutoresizingMaskIntoConstraints = false
        oc.backgroundColor = .clear
        oc.layer.borderWidth = 1
        oc.layer.borderColor = coreOrangeColor.cgColor
        oc.layer.cornerRadius = 9 / 2
        oc.isUserInteractionEnabled = false
        
        return oc
    }()
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = ""
        hl.font = UIFont(name: rubikBold, size: 16)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = coreBlackColor
        hl.isUserInteractionEnabled = false
        
        return hl
    }()
    
    let subHeaderLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = ""
        hl.font = UIFont(name: rubikRegular, size: 16)
        hl.numberOfLines = -1
        hl.adjustsFontSizeToFitWidth = false
        hl.textAlignment = .left
        hl.textColor = coreBlackColor
        hl.isUserInteractionEnabled = false
        
        return hl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.container)
        
        self.container.addSubview(self.headerContainer)
        self.container.addSubview(self.footerContainer)
        
        self.headerContainer.addSubview(self.orangeCircle)
        self.headerContainer.addSubview(self.headerLabel)
        
        self.footerContainer.addSubview(self.subHeaderLabel)
        
        self.container.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.container.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        
        self.headerContainer.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 10).isActive = true
        self.headerContainer.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 0).isActive = true
        self.headerContainer.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: 0).isActive = true
        self.headerContainer.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.footerContainer.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -10).isActive = true
        self.footerContainer.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 0).isActive = true
        self.footerContainer.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: 0).isActive = true
        self.footerContainer.topAnchor.constraint(equalTo: self.headerContainer.bottomAnchor, constant: 0).isActive = true
        
        self.orangeCircle.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: 0).isActive = true
        self.orangeCircle.leftAnchor.constraint(equalTo: self.headerContainer.leftAnchor, constant: 20).isActive = true
        self.orangeCircle.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.orangeCircle.widthAnchor.constraint(equalToConstant: 9).isActive = true
        
        self.headerLabel.centerYAnchor.constraint(equalTo: self.orangeCircle.centerYAnchor, constant: 0).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.orangeCircle.rightAnchor, constant: 10).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -30).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.subHeaderLabel.topAnchor.constraint(equalTo: self.footerContainer.topAnchor, constant: 5).isActive = true
        self.subHeaderLabel.leftAnchor.constraint(equalTo: self.headerLabel.leftAnchor, constant: 0).isActive = true
        self.subHeaderLabel.rightAnchor.constraint(equalTo: self.headerLabel.rightAnchor, constant: 0).isActive = true
        self.subHeaderLabel.bottomAnchor.constraint(equalTo: self.footerContainer.bottomAnchor, constant: 0).isActive = true
        
    }
    
    @objc func handleCellSelection(sender: UIButton) {
        self.yourNotificationsCollectionView?.handleCellSelection(sender:sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
