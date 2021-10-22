//
//  YourReferralContainer.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/22/21.
//

import Foundation
import UIKit
import Firebase


class YourReferralContainer : UIViewController {
    
    var referralMonetaryController : ReferralMonetaryController?,
        pendingUsersMonetaryValueModel = [PendingUsersMonetaryValueModel]()
    
    var isPendingSelected : Bool = true
    
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
    
    let referralsHeaderLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Your Re-furrals"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    lazy var selectorSwitch : YourReferralSelectorSwitch = {
        
        let ss = YourReferralSelectorSwitch()
        ss.translatesAutoresizingMaskIntoConstraints = false
        ss.yourReferralContainer = self
        return ss
        
    }()
    
    lazy var yourReferralCollection : YourReferralCollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let yrcv = YourReferralCollectionView(frame: .zero, collectionViewLayout: layout)
        yrcv.translatesAutoresizingMaskIntoConstraints = false
        yrcv.yourReferralContainer = self
        
        return yrcv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        self.runDataEngine()
        
    }
    
    func runDataEngine() {
        
        UIView.animate(withDuration: 0.25) {
            self.yourReferralCollection.alpha = 0
        }
        
        self.observeMonetaryPendingAndCompletedAmount(isPending: self.isPendingSelected) { isComplete in
            
            DispatchQueue.main.async {
                self.yourReferralCollection.reloadData()
            }
            
            UIView.animate(withDuration: 0.25) {
                self.yourReferralCollection.alpha = 1
            }
        }
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.referralsHeaderLabel)
        self.view.addSubview(self.selectorSwitch)
        self.view.addSubview(self.yourReferralCollection)
        
        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.referralsHeaderLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 43).isActive = true
        self.referralsHeaderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.referralsHeaderLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.referralsHeaderLabel.sizeToFit()
        
        self.selectorSwitch.topAnchor.constraint(equalTo: self.referralsHeaderLabel.bottomAnchor, constant: 20).isActive = true
        self.selectorSwitch.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.selectorSwitch.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.selectorSwitch.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        self.yourReferralCollection.topAnchor.constraint(equalTo: self.selectorSwitch.bottomAnchor, constant: 20).isActive = true
        self.yourReferralCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.yourReferralCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.yourReferralCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
    func observeMonetaryPendingAndCompletedAmount(isPending : Bool, completion : @escaping (_ isComplete : Bool) -> ()) {
        
        guard let user_uid = Auth.auth().currentUser?.uid else {return}
        
        let personalStamp = self.databaseRef.child("personal_pending_invites").child(user_uid)
        
        personalStamp.observe(.value) { snapJSON in
            
            self.pendingUsersMonetaryValueModel.removeAll()
            
            for child in snapJSON.children.allObjects as! [DataSnapshot] {
                
                let JSON = child.value as? [String : AnyObject] ?? [:]
                
                let model = PendingUsersMonetaryValueModel(JSON: JSON)
                
                let isCompanionSatisfied = JSON["inviters_email_companion_success"] as? Bool ?? false
                
                if self.isPendingSelected == true {
                    if isCompanionSatisfied == false {
                        self.pendingUsersMonetaryValueModel.append(model)
                    }
                    
                } else {
                    if isCompanionSatisfied == true {
                        self.pendingUsersMonetaryValueModel.append(model)
                    }
                }
            }
            
            completion(true)
        }
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
