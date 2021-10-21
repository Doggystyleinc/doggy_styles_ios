//
//  ReferralContactsContainer.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/19/21.
//

import Foundation
import UIKit
import Contacts
import Firebase

class ReferralContactsContainer : UIViewController, UITextFieldDelegate, CustomAlertCallBackProtocol {
    
    var contactsArray = [ContactsList](),
        filteredContactsArray = [ContactsList](),
        arrayOfPhoneNumbers = [String](),
        collectedPhoneNumbers = [String](),
        arrayOfCollectedNumbers = [String](),
        observingRefOne = Database.database().reference(),
        handleOne = DatabaseHandle(),
        datasourceArray = [UserPhoneNumberModel](),
        arrayOfCurrentUsersPhoneNumbers = [String](),
        selectedContactsArray = [ContactsList](),
        searchCategories : String?,
        currentKeyboardHeight : CGFloat = 0.0

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
    
    let earnLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Select contacts to refer"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    lazy var searchTextField : CustomTextFieldMaps = {
        
        let etfc = CustomTextFieldMaps()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Search for contacts", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
        etfc.attributedPlaceholder = placeholder
        etfc.textAlignment = .left
        etfc.backgroundColor = coreWhiteColor
        etfc.textColor = UIColor .darkGray.withAlphaComponent(1.0)
        etfc.font = UIFont(name: rubikRegular, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.layer.masksToBounds = true
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.leftViewMode = .always
        
        let image = UIImage(named: "magnifyingGlass")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView()
        imageView.contentMode = .center
        etfc.contentMode = .center
        imageView.image = image
        etfc.leftView = imageView
        
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.layer.cornerRadius = 10
        etfc.addTarget(self, action: #selector(handleSearchTextFieldChange(textField:)), for: .editingChanged)
        
        return etfc
        
    }()
    
    lazy var referralProgramCollectionView : ReferralProgramCollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let rpcv = ReferralProgramCollectionView(frame: .zero, collectionViewLayout: layout)
        rpcv.referralContactsContainer = self
        
       return rpcv
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
        
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = dsFlatBlack
        ai.backgroundColor = .clear
        ai.hidesWhenStopped = true
        
       return ai
    }()
    
    lazy var referButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Refer 0 lucky dog owners", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.addTarget(self, action: #selector(self.handleRefurButton), for: .touchUpInside)
        
        return cbf
        
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        self.runDataEngine()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)

    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.earnLabel)
        self.view.addSubview(self.searchTextField)
        self.view.addSubview(self.referralProgramCollectionView)
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(self.referButton)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
       
        self.earnLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 23).isActive = true
        self.earnLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.earnLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.earnLabel.sizeToFit()
        
        self.searchTextField.topAnchor.constraint(equalTo: self.earnLabel.bottomAnchor, constant: 16).isActive = true
        self.searchTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.searchTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.searchTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.referralProgramCollectionView.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor, constant: 10).isActive = true
        self.referralProgramCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.referralProgramCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.referralProgramCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.searchTextField.centerYAnchor).isActive = true
        self.activityIndicator.rightAnchor.constraint(equalTo: self.searchTextField.rightAnchor, constant: -10).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.referButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.referButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.referButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -57).isActive = true
        self.referButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField.resignFirstResponder()
        return false
    }
    
    @objc func handleKeyboardShow(notification : Notification) {
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        self.currentKeyboardHeight = keyboardRectangle.height
        self.referralProgramCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.currentKeyboardHeight, right: 0)
        self.view.layoutIfNeeded()
        self.referralProgramCollectionView.layoutIfNeeded()
     
    }
    
    @objc func handleKeyboardHide(notification : Notification) {
        
        self.currentKeyboardHeight = 0.0
        self.referralProgramCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.currentKeyboardHeight + 150, right: 0)
        self.view.layoutIfNeeded()
        self.referralProgramCollectionView.layoutIfNeeded()
     
    }
    
    @objc func handleKeyboardFrame(notification : Notification) {
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        self.currentKeyboardHeight = keyboardRectangle.height
        self.view.layoutIfNeeded()
        self.referralProgramCollectionView.layoutIfNeeded()
    }

    @objc func handleSearchTextFieldChange(textField : UITextField) {
        
        guard let typedText = textField.text else {return}
        
        self.filteredCount(searchText: typedText)
        
    }
    
    func filteredCount(searchText: String) {
        
        self.filteredContactsArray = (self.contactsArray.filter { user in
            
            let familyName = user.familyName ?? ""
            let givenName = user.givenName ?? ""
            let phoneNumber = user.phoneNumber ?? ""
            let fullPhoneNumber = user.fullPhoneNumber ?? ""
            
            searchCategories = familyName + " " + givenName + " " + phoneNumber + " " + fullPhoneNumber
            return (searchCategories!.lowercased().contains(searchText.lowercased()))
            
        })
        
        DispatchQueue.main.async {
            self.referralProgramCollectionView.reloadData()
        }
    }
    
    //MARK: - RUNS THE INVITER FUNCTION
    @objc func handleRefurButton() {
        
        let invitesList = self.selectedContactsArray
        
        if invitesList.count == 0 {return}
        
        self.runReferralEngine(passedInviteList: invitesList)
        
    }
    
    func runReferralEngine(passedInviteList : [ContactsList]) {
        
        print(passedInviteList.count)
        
        UIView.animate(withDuration: 0.25) {
            self.referralProgramCollectionView.alpha = 0
            self.referButton.alpha = 0
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            let placeholder = NSAttributedString(string: "Inviting...", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
            self.searchTextField.attributedPlaceholder = placeholder
        }
        
        //MARK: - REMOVES ALL USERS THAT OWN THE APP ALREADY AND HAVE IT INSTALLED
        let filtered = passedInviteList.filter { $0.isCurrentDoggystyleUser != true }
        
        //MARK: - CHECK THE INVITATION LIST FOR ALREADY REQUESTED MEMBERS
        let ref = self.databaseRef.child("pending_invites")
        
        ref.observeSingleEvent(of: .value) { snapDataGrab in
            
            if snapDataGrab.exists() {
                
                guard let JSONdata = snapDataGrab.value as? [String : Any] else {return}
                
            } else {
                
                //does not exist, add to the node with the invitied user
                
            }
        }
    }
    
    //MARK: - ALERTS AND BACK BUTTON
    @objc func handleCustomPopUpAlert(title : String, message : String, passedButtons: [String]) {
        
        let alert = AlertController()
        alert.passedTitle = title
        alert.passedMmessage = message
        alert.passedButtonSelections = passedButtons
        alert.customAlertCallBackProtocol = self
        alert.passedIconName = .infoCircle
        alert.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    func onSelectionPassBack(buttonTitleForSwitchStatement type: String) {
        
        switch type {
        
        case Statics.GOT_IT: self.handleBackButton()
            
        default: print("Should not hit")
            
        }
    }
    
    @objc func handleBackButton() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
}


