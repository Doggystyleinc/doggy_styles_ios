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
    private let chatMediaID = "chatMediaID"
    private let defaultID = "defaultID"
    
    var supportChatController : SupportChatController?,
        shouldScrollToBottom : Bool = false,
        counter : Int = 0
    
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
        self.register(ChatMediaFeeder.self, forCellWithReuseIdentifier: self.chatMediaID)
        
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
        counter += 1
        if counter == 1 {
            return CGPoint(x: 0, y: max(-self.contentInset.top, self.contentSize.height - (self.bounds.size.height - self.contentInset.bottom)) + 38.0)
        } else {
            return CGPoint(x: 0, y: max(-self.contentInset.top, self.contentSize.height - (self.bounds.size.height - self.contentInset.bottom)))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let chatArray = self.supportChatController?.chatObjectArray.count ?? 0
        return chatArray
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let feeder = self.supportChatController?.chatObjectArray {
            
            let messageType = feeder[indexPath.item].type_of_message ?? "nil"
            
            //MARK: - TEXT MESSAGES
            if messageType == "text" {
                
                let indexed = feeder[indexPath.item],
                    textToSize = indexed.message ?? "",
                    size = CGSize(width: UIScreen.main.bounds.width - 60, height: 2000),
                    options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                
                let estimatedFrame = NSString(string: textToSize).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont(name: rubikRegular, size: 14)!], context: nil)
                let estimatedHeight = estimatedFrame.height
                
                print("HEIGHT:- ", estimatedHeight)
                
                return CGSize(width: UIScreen.main.bounds.width, height: estimatedHeight + 65)
                
            //MARK: - MEDIA MESSAGES
            } else {
                
                return CGSize(width: UIScreen.main.bounds.width, height: 227)
            }
            
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let feeder = self.supportChatController?.chatObjectArray {
            
            if feeder.count > 0 {
                
                let indexed = feeder[indexPath.item]
                let type_of_message = indexed.type_of_message ?? "text"
                
                switch type_of_message {
                
                case "text" :
                    let cell = self.dequeueReusableCell(withReuseIdentifier: self.chatMainID, for: indexPath) as! ChatMainFeeder
                    cell.chatCollectionView = self
                    cell.chatObjectArray = indexed
                    return cell
                    
                default :
                    let cell = self.dequeueReusableCell(withReuseIdentifier: self.chatMediaID, for: indexPath) as! ChatMediaFeeder
                    cell.chatCollectionView = self
                    cell.chatObjectArray = indexed
                    return cell
                }
            } else {
                return self.dequeueReusableCell(withReuseIdentifier: self.defaultID, for: indexPath)
            }
        } else {
            return self.dequeueReusableCell(withReuseIdentifier: self.defaultID, for: indexPath)
        }
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
            
             let users_profile_image_url = chatObjectArray?.users_profile_image_url ?? "nil"
                if let message = chatObjectArray?.message {
                    if let senders_firebase_uid = chatObjectArray?.senders_firebase_uid {
                        if let time_stamp = chatObjectArray?.time_stamp {
                            
                            let convertedDate = Date(timeIntervalSince1970: time_stamp).timePassed()
                            self.timeLabel.text = "\(convertedDate)"

                            self.messageLabel.text = message
                            
                            if users_profile_image_url != "nil" {
                            self.profilePhoto.loadImageGeneralUse(users_profile_image_url) { complete in
                                print("photo loaded")
                            }
                            } else {
                                let image = UIImage(named: "Temp Placeholder")?.withRenderingMode(.alwaysOriginal)
                                self.profilePhoto.image = image
                            }
                            
                            let frameHeight = self.chatBubble.frame.height
                            
                            print("Cells frame height is: (text): \(frameHeight)")
                            
                            DispatchQueue.main.async {
                                self.chatBubble.layer.cornerRadius = 51.3 / 2
                            }
                            
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
//        self.deployColorsForDebugging()
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatMediaFeeder : UICollectionViewCell {
    
    var chatCollectionView : ChatCollectionView?
    
    var chatObjectArray : ChatSupportModel? {
        
        didSet {
            
            let users_profile_image_url = chatObjectArray?.users_profile_image_url ?? "nil"
                if let users_selected_image_url = chatObjectArray?.users_selected_image_url {
                    if let _ = chatObjectArray?.image_height {
                        if let _ = chatObjectArray?.image_width {
                            if let time_stamp = chatObjectArray?.time_stamp {
                                
                                let convertedDate = Date(timeIntervalSince1970: time_stamp).timePassed()
                                self.timeLabel.text = "\(convertedDate)"
                                
                                if users_profile_image_url != "nil" {

                                self.profilePhoto.loadImageGeneralUse(users_profile_image_url) { complete in
                                    print("photo loaded")
                                }
                                } else {
                                    let image = UIImage(named: "Temp Placeholder")?.withRenderingMode(.alwaysOriginal)
                                    self.profilePhoto.image = image
                                }
                                
                                self.portraitImageView.isHidden = false
                                self.landscapeImageView.isHidden = true
                                self.squareImageView.isHidden = true
                                self.portraitImageView.loadImageGeneralUse(users_selected_image_url) { complete in
                                   print("portrait image has loaded")
                                }
                                
                                //MARK: - PORTRAIT IMAGE
//                                if image_height > image_width {
//
//                                    self.portraitImageView.isHidden = false
//                                    self.landscapeImageView.isHidden = true
//                                    self.squareImageView.isHidden = true
//
//                                    self.portraitImageView.loadImageGeneralUse(users_selected_image_url) { complete in
//                                        print("portrait image has loaded")
//                                    }
//
//                                    //MARK: - LANDSCAPE IMAGE
//                                } else if image_height < image_width {
//
//                                    self.portraitImageView.isHidden = true
//                                    self.landscapeImageView.isHidden = false
//                                    self.squareImageView.isHidden = true
//
//                                    self.landscapeImageView.loadImageGeneralUse(users_selected_image_url) { complete in
//                                        print("portrait image has loaded")
//                                    }
//
//                                    //MARK: - SQUARE IMAGE
//                                } else if image_height == image_width {
//
//                                    self.portraitImageView.isHidden = true
//                                    self.landscapeImageView.isHidden = true
//                                    self.squareImageView.isHidden = false
//
//                                    self.squareImageView.loadImageGeneralUse(users_selected_image_url) { complete in
//                                        print("portrait image has loaded")
//                                    }
//                                }
                            }
                        }
                    }
                }
            }
        }
    
    
    var containerView : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        
        return cv
        
    }()
    
    let profilePhoto : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = coreOrangeColor.withAlphaComponent(0.2)
        dcl.contentMode = .scaleAspectFill
        dcl.layer.masksToBounds = true
        
        return dcl
    }()
    
    //MARK: 4:5 RATIO FOR SCALING
    let portraitImageView : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = coreOrangeColor.withAlphaComponent(0.2)
        dcl.contentMode = .scaleAspectFill
        dcl.clipsToBounds = true
        dcl.layer.cornerRadius = 10
        dcl.isUserInteractionEnabled = false
        
        return dcl
    }()
    
    //MARK: 3:2 RATIO FOR SCALING
    let landscapeImageView : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = coreOrangeColor.withAlphaComponent(0.2)
        dcl.contentMode = .scaleAspectFill
        dcl.clipsToBounds = true
        dcl.layer.cornerRadius = 10
        dcl.isUserInteractionEnabled = false
        
        return dcl
    }()
    
    //MARK: 3:2 RATIO FOR SCALING
    let squareImageView : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = coreOrangeColor.withAlphaComponent(0.2)
        dcl.contentMode = .scaleAspectFill
        dcl.clipsToBounds = true
        dcl.layer.cornerRadius = 10
        dcl.isUserInteractionEnabled = false
        
        return dcl
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.containerView)
        
        self.containerView.addSubview(self.profilePhoto)
        self.containerView.addSubview(self.portraitImageView)
        self.containerView.addSubview(self.landscapeImageView)
        self.containerView.addSubview(self.squareImageView)
        self.containerView.addSubview(self.timeLabel)
        
        self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        
        self.profilePhoto.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.profilePhoto.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.profilePhoto.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.profilePhoto.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.profilePhoto.layer.cornerRadius = 15
        
        self.portraitImageView.leftAnchor.constraint(equalTo: self.profilePhoto.rightAnchor, constant: 20).isActive = true
        self.portraitImageView.topAnchor.constraint(equalTo: self.profilePhoto.topAnchor, constant: 0).isActive = true
        self.portraitImageView.heightAnchor.constraint(equalToConstant: 195).isActive = true
        self.portraitImageView.widthAnchor.constraint(equalToConstant: 156).isActive = true
        
        self.landscapeImageView.leftAnchor.constraint(equalTo: self.profilePhoto.rightAnchor, constant: 20).isActive = true
        self.landscapeImageView.topAnchor.constraint(equalTo: self.profilePhoto.topAnchor, constant: 0).isActive = true
        self.landscapeImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        self.landscapeImageView.widthAnchor.constraint(equalToConstant: 195).isActive = true
        
        self.squareImageView.leftAnchor.constraint(equalTo: self.profilePhoto.rightAnchor, constant: 20).isActive = true
        self.squareImageView.topAnchor.constraint(equalTo: self.profilePhoto.topAnchor, constant: 0).isActive = true
        self.squareImageView.heightAnchor.constraint(equalToConstant: 156).isActive = true
        self.squareImageView.widthAnchor.constraint(equalToConstant: 156).isActive = true
        
        self.timeLabel.rightAnchor.constraint(equalTo: self.portraitImageView.rightAnchor, constant: 0).isActive = true
        self.timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        self.timeLabel.sizeToFit()
        
        //MARK: - RATIO
        /*
         
         Since
         3 : 2 = 195 : X
         
         Then we know
         2/3 = X/195
         
         Multiplying both sides by 195 cancels on the right
         195 × (2/3) = (X/195) × 195
         195 × (2/3) = X
         
         Then solving for X
         X = 195 × (2/3)
         X = 130
         
         Therefore
         3 : 2 = 195 : 130
         
         */
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

