//
//  ChatCollectionView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/22/21.
//

import Foundation
import UIKit
import Firebase

class ChatCollectionView : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let chatMainID = "chatMainID"
    
    var supportChatController : SupportChatController?,
        shouldScrollToBottom : Bool = false
    
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
        
        self.register(ChatMainFeeder.self, forCellWithReuseIdentifier: self.chatMainID)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.shouldScrollToBottom {
            self.shouldScrollToBottom = false
            self.scrollToBottom(animated: false)
        }
    }
    
    func scrollToBottom(animated: Bool) {
        self.layoutIfNeeded()
        self.setContentOffset(bottomOffset(), animated: animated)
    }
     
    func bottomOffset() -> CGPoint {
        return CGPoint(x: 0, y: max(-self.contentInset.top, self.contentSize.height - (self.bounds.size.height - self.contentInset.bottom)))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let chatArray = self.supportChatController?.chatObjectArray.count ?? 0
        return chatArray
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let feeder = self.supportChatController?.chatObjectArray {
            
                let indexed = feeder[indexPath.item],
                    textToSize = indexed.message ?? "",
                size = CGSize(width: UIScreen.main.bounds.width - 100, height: 2000),
                options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

            let estimatedFrame = NSString(string: textToSize).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont(name: rubikRegular, size: 14)!], context: nil)
            let estimatedHeight = estimatedFrame.height
            
            print("HEIGHT:- ", estimatedHeight)
            
            return CGSize(width: UIScreen.main.bounds.width, height: estimatedHeight + 85)
            
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let feeder = self.supportChatController?.chatObjectArray {
            
            if feeder.count > 0 {
                
            let indexed = feeder[indexPath.item]
            
            let type_of_message = indexed.type_of_message ?? "nil"
            
            switch type_of_message {

            case "text" :
            let cell = self.dequeueReusableCell(withReuseIdentifier: self.chatMainID, for: indexPath) as! ChatMainFeeder
            cell.chatCollectionView = self
            cell.chatObjectArray = indexed
            return cell
                 
            default :
            let cell = self.dequeueReusableCell(withReuseIdentifier: self.chatMainID, for: indexPath) as! ChatMainFeeder
            cell.chatCollectionView = self
            cell.chatObjectArray = indexed
            return cell
            }
        }
    }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatMainFeeder : UICollectionViewCell {
    
    var chatCollectionView : ChatCollectionView?
    
    var chatObjectArray : ChatSupportModel? {
        
        didSet {
            
            if let users_profile_image_url = chatObjectArray?.users_profile_image_url {
                if let message = chatObjectArray?.message {
                    if let senders_firebase_uid = chatObjectArray?.senders_firebase_uid {

                    self.messageLabel.text = message
                    self.profilePhoto.loadImageGeneralUse(users_profile_image_url) { complete in
                        print("photo loaded")
                    }

                    let frameHeight = self.chatBubble.frame.height
                    
                    print("frame height is: \(frameHeight)")
                    
                    if frameHeight >= 70 {
                        self.chatBubble.layer.cornerRadius = 35
                    } else {
                        self.chatBubble.layer.cornerRadius = 12
                    }
                    
                        guard let user_uid = Auth.auth().currentUser?.uid else {return}
                        
                        if user_uid != senders_firebase_uid {
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
    
    let profilePhoto : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = coreOrangeColor.withAlphaComponent(0.2)
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
        cb.backgroundColor = .red
        
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
        thl.backgroundColor = .purple

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
        thl.backgroundColor = .brown

        return thl
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
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
        
        self.messageLabel.topAnchor.constraint(equalTo: self.chatBubble.topAnchor, constant: 19).isActive = true
        self.messageLabel.leftAnchor.constraint(equalTo: self.chatBubble.leftAnchor, constant: 19).isActive = true
        self.messageLabel.bottomAnchor.constraint(equalTo: self.chatBubble.bottomAnchor, constant: -19).isActive = true
        self.messageLabel.rightAnchor.constraint(equalTo: self.chatBubble.rightAnchor, constant: -19).isActive = true

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.chatBubble.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
