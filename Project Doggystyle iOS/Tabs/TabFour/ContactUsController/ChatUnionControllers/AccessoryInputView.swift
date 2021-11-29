//
//  AccessoryInputView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/22/21.
//

import Foundation
import UIKit

class AccessoryInputView : UIView, UITextViewDelegate {
    
    var supportChatController : SupportChatController?,
        textViewYConstraint: NSLayoutConstraint?,
        textViewBottomConstraint: NSLayoutConstraint?
    
    lazy var commentTextView: UITextView = {
        let tf = UITextView()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = coreWhiteColor
        tf.textColor =  coreBlackColor
        tf.layer.masksToBounds = true
        tf.font = UIFont(name: rubikRegular, size: 14)
        tf.delegate = self
        tf.returnKeyType = UIReturnKeyType.default
        tf.keyboardAppearance = UIKeyboardAppearance.default
        tf.isScrollEnabled = false
        tf.autocorrectionType = .yes
        tf.spellCheckingType = .yes
        tf.clipsToBounds = true
        tf.isUserInteractionEnabled = true
        tf.layer.borderColor = coreBlackColor.withAlphaComponent(0.2).cgColor
        tf.layer.shouldRasterize = false
        tf.layer.cornerRadius = 15
        return tf
    }()
    
    lazy var sendButton : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFit
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 15, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .paperPlane), for: .normal)
        cbf.setTitleColor(dsFlatBlack, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleSendButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let placeHolderLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Write a message"
        thl.font = UIFont(name: rubikRegular, size: 14)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = placeHolderGrey
        return thl
        
    }()
    
    lazy var addImageButton : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFit
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .image), for: .normal)
        cbf.setTitleColor(dsFlatBlack, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleImagePickerButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    override var intrinsicContentSize: CGSize {
        return self.textViewContentSize()
    }
    
    func textViewContentSize() -> CGSize {
        let size = CGSize(width: self.commentTextView.bounds.width,
                          height: CGFloat.greatestFiniteMagnitude)
        
        let textSize = self.commentTextView.sizeThatFits(size)
        return CGSize(width: bounds.width, height: textSize.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autoresizingMask = .flexibleHeight
        self.sizeToFit()
        self.isUserInteractionEnabled = true
        self.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.commentTextView)
        self.addSubview(self.sendButton)
        self.addSubview(self.placeHolderLabel)
        self.addSubview(self.addImageButton)
        
        self.addImageButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -22).isActive = true
        self.addImageButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.addImageButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.addImageButton.widthAnchor.constraint(equalToConstant: 25).isActive = true

        self.commentTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.textViewYConstraint = self.commentTextView.heightAnchor.constraint(equalToConstant: 40)
        self.textViewYConstraint?.isActive = true
        self.textViewBottomConstraint = self.commentTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        self.textViewBottomConstraint?.isActive = true
        self.commentTextView.leftAnchor.constraint(equalTo: self.addImageButton.rightAnchor, constant: 20).isActive = true
        
        self.commentTextView.textContainerInset = UIEdgeInsets(top: 11, left: 17, bottom: 5, right: 40)
        
        self.sendButton.rightAnchor.constraint(equalTo: self.commentTextView.rightAnchor, constant: -4).isActive = true
        self.sendButton.bottomAnchor.constraint(equalTo: self.commentTextView.bottomAnchor, constant: -2).isActive = true
        self.sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.placeHolderLabel.leftAnchor.constraint(equalTo: self.commentTextView.leftAnchor, constant: 20).isActive = true
        self.placeHolderLabel.centerYAnchor.constraint(equalTo: self.commentTextView.centerYAnchor).isActive = true
        self.placeHolderLabel.rightAnchor.constraint(equalTo: self.sendButton.leftAnchor, constant: -30).isActive = true
        self.placeHolderLabel.sizeToFit()
        
    }
    
    @objc func handleImagePickerButton() {
        self.supportChatController?.handleImagePicker()
    }
    
    func updateHeight() {
        
        UIView.animate(withDuration: 0.4) {
            
            self.invalidateIntrinsicContentSize()
            self.superview?.setNeedsLayout()
            self.superview?.layoutIfNeeded()
            
        } completion: { (complete) in }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count <= 0 {
            self.placeHolderLabel.isHidden = false
            
        } else {
            self.placeHolderLabel.isHidden = true
        }
        
        if self.textViewYConstraint != nil {
            
            let contentHeight = textViewContentSize().height
            
            if self.textViewYConstraint!.constant != contentHeight {
                
                if self.textViewContentSize().height <= 40 {
                    self.textViewYConstraint!.constant = 40
                } else {
                    self.textViewYConstraint!.constant = self.textViewContentSize().height
                }
                
                self.supportChatController?.heightConstraint?.constant = 40.0 + self.textViewContentSize().height
                
                self.layoutIfNeeded()
                self.supportChatController?.reloadInputViews()
                self.supportChatController?.view.layoutIfNeeded()
                
            }
        }
    }
    
    @objc func handleSendButton() {
        self.supportChatController?.handleSendButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
