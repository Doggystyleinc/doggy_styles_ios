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
        self.contentInset = UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0)
        self.register(ChatMainFeeder.self, forCellWithReuseIdentifier: self.chatMainID)
        self.register(ChatMediaFeeder.self, forCellWithReuseIdentifier: self.chatMediaID)
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.defaultID)

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
        
        self.counter += 1
        if self.counter == 1 {
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
                    size = CGSize(width: UIScreen.main.bounds.width - (94 + 40), height: 2000),
                    options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                
                let estimatedFrame = NSString(string: textToSize).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont(name: rubikRegular, size: 14)!], context: nil)
                let estimatedHeight = estimatedFrame.height
                
                return CGSize(width: UIScreen.main.bounds.width, height: estimatedHeight + 55)
                
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
    
    @objc func handleLongPress(sender: UIButton) {
        
        if let imageFromButton : UIImage = sender.backgroundImage(for: .normal) {
            self.supportChatController?.handleImageSave(sender : imageFromButton)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
