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
        child_key : String?
            
    init(JSON : [String : Any]) {
        
        self.notification_type = JSON["notification_type"] as? String ?? "nil"
        self.notification_first_name = JSON["notification_first_name"] as? String ?? "nil"
        self.notification_last_name = JSON["notification_last_name"] as? String ?? "nil"
        self.notification_time_stamp = JSON["notification_time_stamp"] as? Double ?? 0.0
        self.notification_UID = JSON["notification_UID"] as? String ?? "nil"
        self.notification_email = JSON["notification_email"] as? String ?? "nil"
        self.notification_has_read = JSON["notification_has_read"] as? Bool ?? false
        self.notification_profile_image = JSON["notification_profile_image"] as? String ?? "nil"
        self.child_key = JSON["child_key"] as? String ?? "nil"

    }
}

import Foundation
import UIKit
import Firebase

class YourNotificationController : UIViewController {
    
    let databaseRef = Database.database().reference()
    
    enum SelectedState {
        case new
        case read
    }
    
    var selectedState = SelectedState.new
    
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
        //MARK: - SHOW EMPTY ANIMATION HERE IF APPLICABLE, TEXT NO STATE FOR NOW
        self.selectorSwitch.isHidden = false

        DispatchQueue.main.async {
            self.yourNotificationsCollectionView.reloadData()
        }
    }
    
    func handleNotificationState() {
        
        self.selectorSwitch.isHidden = false
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
                self.yourNotificationsCollectionView.notificationsNewArray.removeAll()
                self.yourNotificationsCollectionView.notificationsReadArray.removeAll()

            for child in snapJSON.children.allObjects as! [DataSnapshot] {
                
                let JSON = child.value as? [String : AnyObject] ?? [:]
               
                let post = NotificationModel(JSON: JSON)
                
                let notification_has_read = JSON["notification_has_read"] as? Bool ?? false
                
                if notification_has_read == false {
                    self.yourNotificationsCollectionView.notificationsNewArray.append(post)
                } else {
                    self.yourNotificationsCollectionView.notificationsReadArray.append(post)
                }
                }
                
                if self.selectedState == .new {
                    self.yourNotificationsCollectionView.notificationsArray = self.yourNotificationsCollectionView.notificationsNewArray
                } else {
                    self.yourNotificationsCollectionView.notificationsArray = self.yourNotificationsCollectionView.notificationsReadArray
                }
                
            //MARK: - LOOP END
            completion(true)
            
            //MARK: - NO DATA HERE EXISTS YET
            } else if !snapJSON.exists() {
                self.yourNotificationsCollectionView.notificationsArray.removeAll()
                self.yourNotificationsCollectionView.notificationsNewArray.removeAll()
                self.yourNotificationsCollectionView.notificationsReadArray.removeAll()
                DispatchQueue.main.async {
                    self.yourNotificationsCollectionView.reloadData()
                }
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
    
    @objc func handleSelector(isNewMessages : Bool) {
        
        if isNewMessages {
            
            self.selectedState = .new
            
            self.yourNotificationsCollectionView.notificationsArray.removeAll()
            self.yourNotificationsCollectionView.notificationsArray = self.yourNotificationsCollectionView.notificationsNewArray
            
            self.yourNotificationsCollectionView.alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.yourNotificationsCollectionView.alpha = 1
            }
     
        } else {
            
            self.selectedState = .read

            self.yourNotificationsCollectionView.notificationsArray.removeAll()
            self.yourNotificationsCollectionView.notificationsArray = self.yourNotificationsCollectionView.notificationsReadArray
            
            self.yourNotificationsCollectionView.alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.yourNotificationsCollectionView.alpha = 1
            }
        }
        
        DispatchQueue.main.async {
            self.yourNotificationsCollectionView.reloadData()
        }
    }
    
    @objc func handleCellReadFlag(childKey : String, users_full_phone_number : String) {
        
        let filteredNumber = users_full_phone_number.replacingOccurrences(of: " ", with: "")
        
        let path = self.databaseRef.child("notifications").child(filteredNumber).child(childKey)
        let values : [String : Any] = ["notification_has_read" : true]
        
        path.updateChildValues(values) { error, ref in
            print("should auto update due to the listener")
        }
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
