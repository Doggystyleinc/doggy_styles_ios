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
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 120)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.chatMainID, for: indexPath) as! ChatMainFeeder
        
        cell.chatCollectionView = self
        
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

class ChatMainFeeder : UICollectionViewCell {
    
    var chatCollectionView : ChatCollectionView?
    
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
        //cb.backgroundColor = dividerGrey
        cb.backgroundColor = coreOrangeColor
        cb.isUserInteractionEnabled = false
        cb.layer.masksToBounds = true
        
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
        return thl
        
    }()
    
    let messageLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Hi Moses, you can go ahead and bring Rex to the van!"
        thl.font = UIFont(name: rubikRegular, size: 14)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreWhiteColor
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
        
        self.chatBubble.leftAnchor.constraint(equalTo: self.profilePhoto.rightAnchor, constant: 20).isActive = true
        self.chatBubble.topAnchor.constraint(equalTo: self.profilePhoto.topAnchor, constant: 0).isActive = true
        self.chatBubble.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.chatBubble.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.chatBubble.layer.cornerRadius = 35
        
        self.timeLabel.rightAnchor.constraint(equalTo: self.chatBubble.rightAnchor, constant: 0).isActive = true
        self.timeLabel.topAnchor.constraint(equalTo: self.chatBubble.bottomAnchor, constant: 12).isActive = true
        self.timeLabel.sizeToFit()
        
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
