//
//  ChatMainFeeder.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 12/5/21.
//

import Foundation
import UIKit
import Firebase

class ChatMainFeeder : UICollectionViewCell {
    
    var chatCollectionView : ChatCollectionView?
    
    var chatObjectArray : ChatSupportModel? {
        
        didSet {
            
             let users_profile_image_url = chatObjectArray?.users_profile_image_url ?? "nil"
                if let message = chatObjectArray?.message {
                    if let senders_firebase_uid = chatObjectArray?.senders_firebase_uid {
                        if let time_stamp = chatObjectArray?.time_stamp {
                            
                            let convertedDate = Date(timeIntervalSince1970: time_stamp).timePassed()
                            self.timeLabel.text = "\(convertedDate)"

                            self.messageLabel.text = message
                            
                            self.profilePhoto.setBackgroundImage(UIImage(), for: .normal)
                            self.profilePhoto.setTitle("", for: .normal)
                            
                            //MARK: - PROFILE PHOTO LOAD
                            if users_profile_image_url != "nil" {
                                let imageView = UIImageView()
                                imageView.loadImageGeneralUse(users_profile_image_url) { complete in
                                    guard let image = imageView.image else {return}
                                    self.profilePhoto.setBackgroundImage(image, for: .normal)
                                }
                                
                            } else {
                                
                                self.profilePhoto.titleLabel?.font = UIFont.fontAwesome(ofSize: 15, style: .solid)
                                self.profilePhoto.setTitle(String.fontAwesomeIcon(name: .dog), for: .normal)
                                self.profilePhoto.setTitleColor(coreWhiteColor, for: .normal)
                            }
                            
                            
                            //MARK: - CONTAINER COLOR BASED OFF OF SENDER UID
                            guard let user_uid = Auth.auth().currentUser?.uid else {return}
                            if user_uid == senders_firebase_uid {
                                self.chatBubble.backgroundColor = coreOrangeColor
                                self.messageLabel.textColor = coreWhiteColor
                            } else {
                                self.chatBubble.backgroundColor = dividerGrey
                                self.messageLabel.textColor = coreBlackColor
                            }
                        }
                    }
                }
            }
        }
    
    let profilePhoto : UIButton = {
        
        let dcl = UIButton()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = lightGrey
        dcl.contentMode = .scaleAspectFill
        dcl.layer.masksToBounds = true
        
        return dcl
    }()
    
    let chatBubble : UIView = {
        
        let cb = UIView()
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.backgroundColor = coreOrangeColor
        cb.isUserInteractionEnabled = false
        cb.layer.masksToBounds = true
        cb.backgroundColor = coreWhiteColor
        
        return cb
    }()
    
    let timeLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .right
        thl.text = "09:27 am"
        thl.font = UIFont(name: rubikRegular, size: 11)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = chatTimeGrey
        thl.backgroundColor = .clear
        
        return thl
        
    }()
    
    let messageLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = ""
        thl.font = UIFont(name: rubikRegular, size: 14)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreWhiteColor
        thl.backgroundColor = .clear
        
        return thl
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addViews()
    }
    
    func addViews() {
        
        self.addSubview(self.profilePhoto)
        self.addSubview(self.chatBubble)
        self.addSubview(self.timeLabel)
        self.addSubview(self.messageLabel)
        
        self.profilePhoto.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.profilePhoto.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.profilePhoto.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.profilePhoto.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.profilePhoto.layer.cornerRadius = 15
        
        self.timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        self.timeLabel.sizeToFit()
        
        self.chatBubble.leftAnchor.constraint(equalTo: self.profilePhoto.rightAnchor, constant: 20).isActive = true
        self.chatBubble.topAnchor.constraint(equalTo: self.profilePhoto.topAnchor, constant: 0).isActive = true
        self.chatBubble.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.chatBubble.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        
        self.messageLabel.topAnchor.constraint(equalTo: self.chatBubble.topAnchor, constant: 10).isActive = true
        self.messageLabel.leftAnchor.constraint(equalTo: self.chatBubble.leftAnchor, constant: 14).isActive = true
        self.messageLabel.bottomAnchor.constraint(equalTo: self.chatBubble.bottomAnchor, constant: -10).isActive = true
        self.messageLabel.rightAnchor.constraint(equalTo: self.chatBubble.rightAnchor, constant: -10).isActive = true
        
       
    }
    
    func deployColorsForDebugging() {
        self.messageLabel.backgroundColor = .purple
        self.timeLabel.backgroundColor = .green
        self.backgroundColor = .lightGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.chatBubble.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        let frameHeight = self.chatBubble.frame.height
        
        DispatchQueue.main.async {
            
            if frameHeight < 45.0 {
                self.chatBubble.layer.cornerRadius = frameHeight / 2.0
            } else {
                self.chatBubble.layer.cornerRadius = 30.0
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

