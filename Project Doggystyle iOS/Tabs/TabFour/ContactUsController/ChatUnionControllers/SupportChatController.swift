//
//  SupportChatController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/13/21.
//

import Foundation
import UIKit

class SupportChatController : UIViewController, CustomAlertCallBackProtocol {
    
    enum ControllerState {
        case inProgress
        case complete
    }
    
    var heightConstraint: NSLayoutConstraint?,
        footerOffset: CGFloat = 60.0,
        canBecomeResponder: Bool = true,
        isResponder: Bool = false,
        isKeyboardShowing : Bool = false,
        shouldAdjustForKeyboard : Bool = false,
        hasViewBeenLaidOut : Bool = false,
        controllerState = ControllerState.inProgress
    
    lazy var headerContainer : UIView = {
        
        let hc = UIView()
        hc.translatesAutoresizingMaskIntoConstraints = false
        hc.backgroundColor = .clear
        
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
    
    override var isFirstResponder: Bool {
        return self.isResponder
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        self.handleObservers()
        
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
    }
    
    //MARK: - HEADER AND FOOTER GRADIENT
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.hasViewBeenLaidOut == true {return}
        self.hasViewBeenLaidOut = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = headerContainer.bounds
        gradientLayer.colors = [coreBackgroundWhite.cgColor,
                                coreBackgroundWhite.cgColor,
                                coreBackgroundWhite.cgColor,
                                coreBackgroundWhite.cgColor,
                                coreBackgroundWhite.withAlphaComponent(0.7).cgColor
                                
        ]
        
        self.headerContainer.layer.insertSublayer(gradientLayer, at: 0)
        
        let gradientLayerTwo = CAGradientLayer()
        gradientLayerTwo.frame = self.customInputAccessoryView.bounds
        gradientLayerTwo.colors = [coreBackgroundWhite.withAlphaComponent(0.7).cgColor,
                                   coreBackgroundWhite.cgColor,
                                   coreBackgroundWhite.cgColor,
                                   coreBackgroundWhite.cgColor
                                   
        ]
        
        self.customInputAccessoryView.layer.insertSublayer(gradientLayerTwo, at: 0)
        self.stateListener()
        
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
        
        self.chatMainCollection.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 0).isActive = true
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
        insets.bottom = keyboardHeight
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            
            self.chatMainCollection.contentInset = insets
            self.chatMainCollection.scrollIndicatorInsets = insets
            
            if distanceFromBottom < 10 {
                self.chatMainCollection.contentOffset = self.chatMainCollection.bottomOffset()
            }
        }, completion: nil)
        
        shown ? self.chatMainCollection.scrollToBottom() : self.chatMainCollection.scrollToTop()
    }
    
    //MARK: - HIDES THE ACCESSORY VIEW
    func hideFirstResponder() {
        if !self.customInputAccessoryView.commentTextView.isFirstResponder {
            self.isResponder = true
            self.canBecomeResponder = false
            self.customInputAccessoryView.isHidden = true
            self.reloadInputViews()
        } else {
            self.customInputAccessoryView.commentTextView.becomeFirstResponder()
            self.isResponder = true
            self.canBecomeResponder = false
            self.customInputAccessoryView.isHidden = true
            self.reloadInputViews()
        }
    }
    
    //MARK: - SHOWS THE ACCESSORY VIEW
    func showFirstResponder() {
        if !self.customInputAccessoryView.commentTextView.isFirstResponder {
            self.customInputAccessoryView.isHidden = false
            self.isResponder = false
            self.canBecomeResponder = true
            self.customInputAccessoryView.commentTextView.becomeFirstResponder()
            self.becomeFirstResponder()
            self.reloadInputViews()
        } else {
            self.customInputAccessoryView.isHidden = false
            self.isResponder = false
            self.canBecomeResponder = true
            self.customInputAccessoryView.commentTextView.becomeFirstResponder()
            self.becomeFirstResponder()
            self.reloadInputViews()
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
    
    func onSelectionPassBack(buttonTitleForSwitchStatement type: String) {
        
        switch type {
        case Statics.OK: print(Statics.OK)
        default: print("Should not hit")
            
        }
    }
    
    //MARK: - AUDIO CALL
    @objc func handleContactHelpCenter() {
        self.handlePhoneCall()
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
