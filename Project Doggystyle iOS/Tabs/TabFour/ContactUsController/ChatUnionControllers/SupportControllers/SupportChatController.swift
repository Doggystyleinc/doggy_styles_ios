//
//  SupportChatController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/13/21.
//

import Foundation
import UIKit
import Firebase

class SupportChatController : UIViewController, CustomAlertCallBackProtocol {
    
    enum ControllerState {
        case inProgress
        case complete
    }
    
    var heightConstraint: NSLayoutConstraint?,
        footerOffset: CGFloat = 60.0,
        canBecomeResponder: Bool = true,
        isKeyboardShowing : Bool = false,
        shouldAdjustForKeyboard : Bool = false,
        hasViewBeenLaidOut : Bool = false,
        controllerState = ControllerState.inProgress,
        homeController : HomeViewController?,
        otherUIDS : [String]?,
        chatObjectArray = [ChatSupportModel]()
    
    let mainLoadingScreen = MainLoadingScreen(),
        databaseRef = Database.database().reference()
    
    lazy var headerContainer : UIView = {
        
        let hc = UIView()
        hc.translatesAutoresizingMaskIntoConstraints = false
        hc.backgroundColor = coreBackgroundWhite.withAlphaComponent(0.0)
        hc.layer.masksToBounds = true
        hc.clipsToBounds = true
        
        return hc
    }()
    
    lazy var backButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreOrangeColor
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Chatting with Sophie"
        hl.font = UIFont(name: dsHeaderFont, size: 24)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = dsFlatBlack
        
        return hl
    }()
    
    let subHeaderLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Appt #9475; Rex & Jolene"
        hl.font = UIFont(name: rubikMedium, size: 18)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = dsFlatBlack
        
        return hl
    }()
    
    let completeLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Appointment Complete"
        hl.font = UIFont(name: dsSubHeaderFont, size: 16)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = completeGreen
        hl.isHidden = true
        
        return hl
    }()
    
    lazy var chatMainCollection : ChatCollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cmc = ChatCollectionView(frame: .zero, collectionViewLayout: layout)
        cmc.supportChatController = self
        
        return cmc
    }()
    
    lazy var customInputAccessoryView: AccessoryInputView = {
        let cia = AccessoryInputView()
        cia.supportChatController = self
        cia.alpha = 0
        return cia
    }()
    
    var transparentHeader : UIView = {
        
        let th = UIView()
        th.translatesAutoresizingMaskIntoConstraints = false
        th.backgroundColor = coreWhiteColor
        th.layer.masksToBounds = true
        th.isUserInteractionEnabled = false
        
        return th
    }()
    
    var completionContainer : UIView = {
        
        let cc = UIView()
        cc.translatesAutoresizingMaskIntoConstraints = false
        cc.backgroundColor = coreWhiteColor
        cc.isUserInteractionEnabled = true
        cc.isHidden = true
        
        return cc
    }()
    
    let aptCompleteButton : UIButton = {
        
        let cbf = UIButton(type : .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("    Appointment complete. Chat closed.    ", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: rubikRegular, size: 12)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreOrangeColor
        cbf.backgroundColor = dividerGrey
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreOrangeColor
        cbf.layer.masksToBounds = true
        cbf.isUserInteractionEnabled = false
        
        return cbf
        
    }()
    
    lazy var contactHelpCenterButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Contact our Help Center", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: rubikRegular, size: 12)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreOrangeColor
        cbf.backgroundColor = coreOrangeColor.withAlphaComponent(0.2)
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreOrangeColor
        cbf.layer.masksToBounds = true
        cbf.addTarget(self, action: #selector(self.handleContactHelpCenter), for: .touchUpInside)
        
        return cbf
    }()
    
    //MARK: - ACCESSORY VIEWS
    override var canBecomeFirstResponder: Bool {
        return self.canBecomeResponder
    }
    
    override var inputAccessoryView: UIView? {
        return self.customInputAccessoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        self.handleObservers()
        self.handleDataSource()
        self.customInputAccessoryView.commentTextView.becomeFirstResponder()
        
        //MARK: - FORCE LAYOUTSUBVIEWS
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - REMOVE THE INPUT ACCESSORY VIEW (PREVENTS IT FROM STICKING WHEN CONTROLLER IS DISMISSED)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.hideFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.shouldAdjustForKeyboard = true
        self.chatMainCollection.scrollToBottom(animated: true)
        self.showFirstResponder()
    }
    
    //MARK: - HEADER AND FOOTER GRADIENT
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if self.hasViewBeenLaidOut == true {return}
        self.hasViewBeenLaidOut = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.headerContainer.bounds
        gradientLayer.colors = [
            coreBackgroundWhite.withAlphaComponent(1.0).cgColor,
            coreBackgroundWhite.withAlphaComponent(0.9).cgColor,
        ]
        self.headerContainer.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //MARK: - VIEW LAYOUT
    func addViews() {
        
        //MARK: - GENERAL LAYOUT
        self.view.addSubview(self.chatMainCollection)
        self.view.addSubview(self.customInputAccessoryView)
        
        self.view.addSubview(self.headerContainer)
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.subHeaderLabel)
        self.view.addSubview(self.completeLabel)
        
        //MARK: - COMPLETED CONTAINER
        self.view.addSubview(self.completionContainer)
        self.completionContainer.addSubview(self.aptCompleteButton)
        self.completionContainer.addSubview(self.contactHelpCenterButton)
        
        self.headerContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.headerContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.headerContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.headerContainer.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.headerContainer.isUserInteractionEnabled = false
        
        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 11).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.headerLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 10).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.headerLabel.sizeToFit()
        
        self.subHeaderLabel.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 5).isActive = true
        self.subHeaderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.subHeaderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.subHeaderLabel.sizeToFit()
        
        self.chatMainCollection.topAnchor.constraint(equalTo: self.headerLabel.topAnchor, constant: 0).isActive = true
        self.chatMainCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.chatMainCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.chatMainCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.heightConstraint = self.customInputAccessoryView.heightAnchor.constraint(equalToConstant: 70)
        self.heightConstraint?.isActive = true
        self.customInputAccessoryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.customInputAccessoryView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.customInputAccessoryView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        self.completeLabel.topAnchor.constraint(equalTo: self.subHeaderLabel.bottomAnchor, constant: 10).isActive = true
        self.completeLabel.leftAnchor.constraint(equalTo: self.subHeaderLabel.leftAnchor).isActive = true
        self.completeLabel.rightAnchor.constraint(equalTo: self.subHeaderLabel.rightAnchor, constant: 0).isActive = true
        self.completeLabel.sizeToFit()
        
        self.completionContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        self.completionContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.completionContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.completionContainer.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        self.aptCompleteButton.centerYAnchor.constraint(equalTo: self.completionContainer.centerYAnchor, constant: -16).isActive = true
        self.aptCompleteButton.leftAnchor.constraint(equalTo: self.completionContainer.leftAnchor, constant: 70).isActive = true
        self.aptCompleteButton.rightAnchor.constraint(equalTo: self.completionContainer.rightAnchor, constant: -70).isActive = true
        self.aptCompleteButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        self.aptCompleteButton.layer.cornerRadius = 11
        
        self.contactHelpCenterButton.centerYAnchor.constraint(equalTo: self.completionContainer.centerYAnchor, constant: 16).isActive = true
        self.contactHelpCenterButton.leftAnchor.constraint(equalTo: self.completionContainer.leftAnchor, constant: 80).isActive = true
        self.contactHelpCenterButton.rightAnchor.constraint(equalTo: self.completionContainer.rightAnchor, constant: -80).isActive = true
        self.contactHelpCenterButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        self.contactHelpCenterButton.layer.cornerRadius = 11
        
    }
    
    //MARK: - RUN DATA ENGINE
    @objc func handleDataSource() {
        
        self.runDataEngine { isComplete in
            if isComplete == true {
                self.handleSuccess()
            } else {
                self.handleFailureNoMessage()
            }
        }
    }
    
    func runDataEngine(completion : @escaping (_ isComplete : Bool) -> ()) {
        
        let starterKey = "this_is_a_random_starter_key"
        let ref = self.databaseRef.child("customer_support").child("support_chat").child(starterKey)
        var errorFlag : Bool = false
        var counter : Int = 0
        
        ref.observe(.value) { snap in
            
            //MARK: - CLEAR THE DATASOURCE SINCE WE HAVE OPEN SCOKETS LISTENING AND THE COUNTER
            self.chatObjectArray.removeAll()
            counter = 0
            
            //MARK: - MESSAGES EXISTS
            if snap.exists() {
                let childrenCount = Int(snap.childrenCount)
                
                for child in snap.children.allObjects as! [DataSnapshot] {
                    counter += 1
                    let JSON = child.value as? [String : Any] ?? [:]
                    
                    let senders_firebase_uid = JSON["senders_firebase_uid"] as? String ?? "nil"
                    let message = JSON["message"] as? String ?? "nil"
                    let message_parent_key = JSON["message_parent_key"] as? String ?? "nil"
                    let time_stamp = JSON["time_stamp"] as? Double ?? 0.0
                    let type_of_message = JSON["type_of_message"] as? String ?? "nil"
                    let users_selected_image_url = JSON["users_selected_image_url"] as? String ?? "nil"
                    let image_height = JSON["image_height"] as? Double ?? 0.0
                    let image_width = JSON["image_width"] as? Double ?? 0.0
                    
                    let ref = self.databaseRef.child("all_users").child(senders_firebase_uid)
                    
                    ref.observeSingleEvent(of: .value) { userSnap in
                        
                        if userSnap.exists() {
                            
                            let JSON = userSnap.value as? [String : AnyObject] ?? [:]
                            
                            let is_groomer = JSON["is_groomer"] as? Bool ?? false
                            
                            let user_first_name = JSON["user_first_name"] as? String ?? "nil"
                            let user_last_name = JSON["user_last_name"] as? String ?? "nil"
                            let users_email = JSON["users_email"] as? String ?? "nil"
                            let users_profile_image_url = JSON["users_profile_image_url"] as? String ?? "nil"
                            
                            let object : [String : Any] = ["senders_firebase_uid" : senders_firebase_uid,
                                                           "message" : message,
                                                           "message_parent_key" : message_parent_key,
                                                           "time_stamp" : time_stamp,
                                                           "type_of_message" : type_of_message,
                                                           "users_selected_image_url" : users_selected_image_url,
                                                           "is_groomer" : is_groomer,
                                                           "user_first_name" : user_first_name,
                                                           "user_last_name" : user_last_name,
                                                           "users_email" : users_email,
                                                           "users_profile_image_url" : users_profile_image_url,
                                                           "image_height" : image_height,
                                                           "image_width" : image_width]
                            
                            //MARK: - LOAD THE DATA INTO THE MODEL
                            let post = ChatSupportModel(JSON: object)
                            self.chatObjectArray.append(post)
                            
                            //MARK: - SORT THE DICTIONARY BY THE TIME STAMP
                            self.chatObjectArray.sort(by: { (timeOne, timeTwo) -> Bool in
                                
                                if let timeOne = timeOne.time_stamp {
                                    if let timeTwo = timeTwo.time_stamp {
                                        return timeOne < timeTwo
                                    }
                                }
                                
                                return true
                                
                            })
                            
                            if childrenCount == counter {
                                if errorFlag == true {
                                    completion(false)
                                } else {
                                    completion(true)
                                }
                            }
                            
                        } else {
                            errorFlag = true
                            completion(false)
                        }
                    }
                }
                
            } else {
                completion(false)
            }
        }
    }
    
    @objc func handleSuccess() {
        
        DispatchQueue.main.async {
            self.chatMainCollection.reloadData()
        }
        
        UIView.animate(withDuration: 0.5) {
            self.customInputAccessoryView.alpha = 1.0
        }
    }
    
    @objc func handleFailureNoMessage() {
        
        self.chatObjectArray.removeAll()
        
        DispatchQueue.main.async {
            self.chatMainCollection.reloadData()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.customInputAccessoryView.alpha = 1.0
        }
    }
    
    //MARK: - UPDATED THE UI ACCORDING TO THE CONTROLLERS STATE, IN PROGRESS OR COMPLETE
    func stateListener() {
        
        switch self.controllerState {
        case .inProgress :
            self.showFirstResponder()
            self.completionContainer.isHidden = true
            self.completeLabel.isHidden = true
        case .complete :
            self.hideFirstResponder()
            self.completionContainer.isHidden = false
            self.completeLabel.isHidden = false
        }
    }
    
    //MARK: - KEYBOARD LISTENER
    func handleObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - KEYBOARD PRESENTATION
    @objc func handleKeyboardShow(notification : Notification) {
        
        self.adjustContentForKeyboard(shown: true, notification: notification as NSNotification)
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        if keyboardRectangle.height > 200 {
            if self.isKeyboardShowing == true {return}
            self.isKeyboardShowing = true
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                self.customInputAccessoryView.textViewBottomConstraint?.constant = -15
                self.customInputAccessoryView.updateHeight()
                self.customInputAccessoryView.updateConstraints()
            } completion: { complete in
                print("up")
            }
        }
    }
    
    //MARK: - KEYBOARD DISMISS
    @objc func handleKeyboardHide(notification : Notification) {
        
        self.isKeyboardShowing = false
        
        self.adjustContentForKeyboard(shown: false, notification: notification as NSNotification)
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.customInputAccessoryView.textViewBottomConstraint?.constant = -20
            self.customInputAccessoryView.updateHeight()
            self.customInputAccessoryView.updateConstraints()
        } completion: { complete in
            print("up")
        }
    }
    
    //MARK: - CONTENT ADJUSTMENT
    func adjustContentForKeyboard(shown: Bool, notification: NSNotification) {
        
        //MARK: - KEYBOARD HEIGHT
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        //MARK: - KEYBOARD DURATION
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
        
        //MARK: - KEYBOARD FRAME
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let _ = notification.userInfo![frameKey] as! NSValue
        
        //MARK: - KEYBOARD CURVE
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let _ = UIView.AnimationCurve(rawValue: curveValue)!
        
        guard shouldAdjustForKeyboard else { return }
        
        let keyboardHeight = shown ? keyboardRectangle.height : self.customInputAccessoryView.frame.height
        if self.chatMainCollection.contentInset.bottom == keyboardHeight {
            return
        }
        
        let distanceFromBottom = self.chatMainCollection.bottomOffset().y - self.chatMainCollection.contentOffset.y
        
        var insets = self.chatMainCollection.contentInset
        insets.bottom = keyboardHeight - 30.0
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            
            self.chatMainCollection.contentInset = insets
            self.chatMainCollection.scrollIndicatorInsets = insets
            
            if distanceFromBottom < 10 {
                self.chatMainCollection.contentOffset = self.chatMainCollection.bottomOffset()
            }
        }, completion: nil)
    }
    
    //MARK: - HIDES THE ACCESSORY VIEW
    @objc func hideFirstResponder() {
        if !self.customInputAccessoryView.commentTextView.isFirstResponder {
            self.canBecomeResponder = false
            self.customInputAccessoryView.isHidden = true
            self.reloadInputViews()
        } else {
            self.customInputAccessoryView.commentTextView.becomeFirstResponder()
            self.canBecomeResponder = false
            self.customInputAccessoryView.isHidden = true
            self.reloadInputViews()
        }
    }
    
    //MARK: - SHOWS THE ACCESSORY VIEW
    @objc func showFirstResponder() {
        if !self.customInputAccessoryView.commentTextView.isFirstResponder {
            self.customInputAccessoryView.isHidden = false
            self.canBecomeResponder = true
            self.customInputAccessoryView.commentTextView.becomeFirstResponder()
            self.becomeFirstResponder()
            self.reloadInputViews()
            self.customInputAccessoryView.reloadInputViews()
        } else {
            self.customInputAccessoryView.isHidden = false
            self.canBecomeResponder = true
            self.customInputAccessoryView.commentTextView.becomeFirstResponder()
            self.becomeFirstResponder()
            self.reloadInputViews()
            self.customInputAccessoryView.reloadInputViews()
            
        }
    }
    
    //MARK: - MOBILE (DEVICE) AUDIO CALL
    @objc func handlePhoneCall() {
        
        UIDevice.vibrateLight()
        
        if let url = URL(string: "tel://\(Statics.SUPPORT_PHONE_NUMBER)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            self.handleCustomPopUpAlert(title: "Restriction", message: "This device is unable to make phone calls.", passedButtons: [Statics.OK])
        }
    }
    
    //MARK: - CUSTOM POP UP
    @objc func handleCustomPopUpAlert(title : String, message : String, passedButtons: [String]) {
        
        let alert = AlertController()
        alert.passedTitle = title
        alert.passedMmessage = message
        alert.passedButtonSelections = passedButtons
        alert.customAlertCallBackProtocol = self
        alert.passedIconName = .paw
        alert.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: -- ON SELECTION FOR CUSTOM POPUP
    func onSelectionPassBack(buttonTitleForSwitchStatement type: String) {
        
        switch type {
        case Statics.OK:
            
            self.customInputAccessoryView.sendButton.isUserInteractionEnabled = true
            self.chatMainCollection.scrollToBottom(animated: true)
            self.customInputAccessoryView.commentTextView.text = ""
            self.customInputAccessoryView.placeHolderLabel.isHidden = false
            
        default: print("Should not hit")
            
        }
    }
    
    func handleImagePicker() {
        //MARK: - REQUIRES HOMECONTROLLER SO THE IMAGE CAN UPLOAD IF THE USER BAILS FROM THE CHAT
        if self.homeController == nil {return}
        
        self.hideFirstResponder()
        self.customInputAccessoryView.isHidden = true
        self.checkForGalleryAuth()
    }
    
    //MARK: - AUDIO CALL
    @objc func handleContactHelpCenter() {
        self.handlePhoneCall()
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - SEND MESSAGE BUTTON
    @objc func handleSendButton() {
        
        guard let user_uid = Auth.auth().currentUser?.uid else {return}
        guard let text = self.customInputAccessoryView.commentTextView.text else {return}
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanText.count <= 0 {return}
        
        var containsNSFWText : Bool = false
        
        //MARK: - START LOOP
        for word in cleanText.split(separator: " ") {
          
            if NSFWComparisonArray.contains(word.lowercased()) {
                containsNSFWText = true
            } else {
                containsNSFWText = false
            }
        }
        
        //MARK: - END LOOP
        if !containsNSFWText {
            //CLEAN
            self.customInputAccessoryView.resetAfterSend()
            self.customInputAccessoryView.sendButton.isUserInteractionEnabled = false
            
            //ALL CLEAR HERE NOW
            let time_stamp : Double = NSDate().timeIntervalSince1970
            
            let starterKey = "this_is_a_random_starter_key"
            
            //MARK: - GETTING THE USERS VALUES WHEN LOADING THE CHAT CONTROLLER, NOT SENDING IT HERE IN CASE THEY CHANGE IT.
            let ref = self.databaseRef.child("customer_support").child("support_chat").child(starterKey).childByAutoId()
            let parent_key = ref.key ?? "nil"
            
            let values : [String : Any] = ["time_stamp" : time_stamp, "type_of_message" : "text", "message" : cleanText, "senders_firebase_uid" : user_uid, "message_parent_key" : parent_key]
            
            ref.updateChildValues(values) { error, ref in
                
                self.customInputAccessoryView.sendButton.isUserInteractionEnabled = true
                self.chatMainCollection.scrollToBottom(animated: true)
                self.customInputAccessoryView.placeHolderLabel.isHidden = false
                
                if self.otherUIDS != nil {
                    
                    guard let safeIDS = self.otherUIDS else {return}
                    
                    for i in safeIDS {
                        PushNotificationManager.sendPushNotification(title: "Message", body: "cleanText", recipients_user_uid: i) { success, error in
                            print("notification sent")
                        }
                    }
                }
            }
        } else {
            self.handleCustomPopUpAlert(title: "Ruh roh!", message: "Please enter another message, we aim to keep a friendly environment here at Doggystyle - for both humans and pups.", passedButtons: [Statics.OK])
        }
    }
}

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices
import Photos

extension SupportChatController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func checkForGalleryAuth() {
        
        UIDevice.vibrateLight()
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        
        case .authorized:
            self.openGallery()
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.openGallery()
                }
            })
            
        case .restricted:
            self.handleCustomPopUpAlert(title: "PERMISSIONS", message: "Please allow Photo Library Permissions in the Settings application.", passedButtons: [Statics.OK])
        case .denied:
            self.handleCustomPopUpAlert(title: "PERMISSIONS", message: "Please allow Photo Library Permissions in the Settings application.", passedButtons: [Statics.OK])
        default :
            self.handleCustomPopUpAlert(title: "PERMISSIONS", message: "Please allow Photo Library Permissions in the Settings application.", passedButtons: [Statics.OK])
        }
    }
    
    func openCameraOptions() {
        
        DispatchQueue.main.async {
            
            let ip = UIImagePickerController()
            ip.sourceType = .camera
            ip.mediaTypes = [kUTTypeImage as String]
            ip.allowsEditing = true
            ip.delegate = self
            
            if let topViewController = UIApplication.getTopMostViewController() {
                topViewController.present(ip, animated: true) {
                }
            }
        }
    }
    
    func openGallery() {
        
        DispatchQueue.main.async {
            
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            
            if let topViewController = UIApplication.getTopMostViewController() {
                topViewController.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true) {
            self.showFirstResponder()
            self.customInputAccessoryView.isHidden = false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            
            let mediaType = info[.mediaType] as! CFString
            
            switch mediaType {
            
            case kUTTypeImage :
                
                if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    
                    self.mainLoadingScreen.callMainLoadingScreen(lottiAnimationName: Statics.PAW_ANIMATION)
                    
                    let height = Double(editedImage.size.height)
                    let width = Double(editedImage.size.width)
                    
                    self.homeController?.uploadUserChatImage(imageToUpload: editedImage, imageHeight: height, imageWidth: width, completion: { complete in
                        self.mainLoadingScreen.cancelMainLoadingScreen()
                        UIDevice.vibrateLight()
                        self.customInputAccessoryView.isHidden = false
                        self.perform(#selector(self.showFirstResponder), with: nil, afterDelay: 1.0)
                    })
                    
                } else if let originalImage = info[.originalImage] as? UIImage  {
                    self.mainLoadingScreen.callMainLoadingScreen(lottiAnimationName: Statics.PAW_ANIMATION)
                    
                    let height = Double(originalImage.size.height)
                    let width = Double(originalImage.size.width)
                    
                    self.homeController?.uploadUserChatImage(imageToUpload: originalImage, imageHeight: height, imageWidth: width, completion: { complete in
                        self.mainLoadingScreen.cancelMainLoadingScreen()
                        UIDevice.vibrateLight()
                        self.customInputAccessoryView.isHidden = false
                        self.perform(#selector(self.showFirstResponder), with: nil, afterDelay: 1.0)
                    })
                    
                } else {
                    print("Failed grabbing the photo")
                }
                
            default : print("SHOULD NOT HIT FOR THE CAMERA PICKER")
                
            }
        }
    }
}








