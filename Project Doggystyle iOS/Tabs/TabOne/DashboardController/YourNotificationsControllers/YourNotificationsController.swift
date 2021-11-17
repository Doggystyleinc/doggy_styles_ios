//
//  NotificationController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/2/21.
//

class NotificationModel : NSObject {
    
    var notification_type : String?,
        notification_first_name : String?,
        notification_last_name : String?,
        notification_time_stamp : Double?,
        notification_UID : String?,
        notification_email : String?,
        notification_has_read : Bool?,
        notification_profile_image : String?,
        notification_parent_key : String?
            
    init(JSON : [String : Any], notification_parent_key_grab : String) {
        
        self.notification_type = JSON["notification_type"] as? String ?? "nil"
        self.notification_first_name = JSON["notification_first_name"] as? String ?? "nil"
        self.notification_last_name = JSON["notification_last_name"] as? String ?? "nil"
        self.notification_time_stamp = JSON["notification_time_stamp"] as? Double ?? 0.0
        self.notification_UID = JSON["notification_UID"] as? String ?? "nil"
        self.notification_email = JSON["notification_email"] as? String ?? "nil"
        self.notification_has_read = JSON["notification_has_read"] as? Bool ?? false
        self.notification_profile_image = JSON["notification_profile_image"] as? String ?? "nil"
        
        self.notification_parent_key = notification_parent_key_grab

    }
}

import Foundation
import UIKit
import Firebase

class YourNotificationController : UIViewController {
    
    let databaseRef = Database.database().reference()
    
    lazy var backButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = UIColor.dsOrange
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Your Notifications"
        hl.font = UIFont(name: dsHeaderFont, size: 32)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        
        return hl
    }()
    
    lazy var selectorSwitch : NotificationsSelector = {
        
        let ss = NotificationsSelector()
        ss.translatesAutoresizingMaskIntoConstraints = false
        ss.yourNotificationController = self
        ss.isHidden = true
        
        return ss
        
    }()
    
    lazy var yourNotificationsCollectionView : YourNotificationsCollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let rpc = YourNotificationsCollectionView(frame: .zero, collectionViewLayout: layout)
        rpc.yourNotificationsController = self
        
        return rpc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        self.runEngine()
    }
    
    func runEngine() {
        
        self.loadDataEngine { isComplete in
            
            if isComplete {
                self.handleNotificationState()
            } else {
                self.handleEmptyState()
            }
        }
    }
    
    func handleEmptyState() {
        //SHOW EMPTY ANIMATION HERE MAYBE?
        self.selectorSwitch.isHidden = true
        self.headerLabel.text = "Empty :("

        DispatchQueue.main.async {
            self.yourNotificationsCollectionView.reloadData()
        }
    }
    
    func handleNotificationState() {
        
        self.selectorSwitch.isHidden = false
        self.headerLabel.text = "Your Notifications"
        DispatchQueue.main.async {
            self.yourNotificationsCollectionView.reloadData()
        }
    }
    
    func loadDataEngine(completion : @escaping (_ isComplete : Bool) -> ()) {
        
        let usersFullPhoneNumber = userProfileStruct.users_full_phone_number ?? "nil"
        let replacementNumber = usersFullPhoneNumber.replacingOccurrences(of: " ", with: "")

        let ref = self.databaseRef.child("notifications").child(replacementNumber)
        
        ref.observe(.value) { snapJSON in
            
            if snapJSON.exists() {
            
            self.yourNotificationsCollectionView.notificationsArray.removeAll()
            
            for child in snapJSON.children.allObjects as! [DataSnapshot] {
                
                let JSON = child.value as? [String : AnyObject] ?? [:]
                
                let parentKey = ref.parent?.key ?? "nil"
                let refKey = ref.key ?? "nil"
               
                let post = NotificationModel(JSON: JSON, notification_parent_key_grab: refKey)
                
                self.yourNotificationsCollectionView.notificationsArray.append(post)
            
            }
            //MARK: - LOOP END
            completion(true)
            
            //MARK: - NO DATA HERE EXISTS YET
            } else if !snapJSON.exists() {
                completion(false)
            }
        }
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.selectorSwitch)
        self.view.addSubview(self.yourNotificationsCollectionView)
        
        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 11).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.headerLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 53).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.headerLabel.sizeToFit()
        
        self.selectorSwitch.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 15).isActive = true
        self.selectorSwitch.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.selectorSwitch.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.selectorSwitch.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        self.yourNotificationsCollectionView.topAnchor.constraint(equalTo: self.selectorSwitch.bottomAnchor, constant: 20).isActive = true
        self.yourNotificationsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.yourNotificationsCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.yourNotificationsCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
