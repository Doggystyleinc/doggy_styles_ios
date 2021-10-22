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
        cbf.alpha = 0
        cbf.addTarget(self, action: #selector(self.handleRefurButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        self.perform(#selector(self.runDataEngine), with: nil, afterDelay: 0.01)
        
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
        self.searchTextField.text = ""
        self.filteredCount(searchText: "")
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
        let ref = self.databaseRef.child("global_pending_invites")
        
        ref.observeSingleEvent(of: .value) { snapDataGrab in
            
            if snapDataGrab.exists() {
                
                for i in filtered {
                   
                    let selectedPhoneNumber = i.phoneNumber ?? "nil"
                    
                    //MARK: - CHECK FOR PAST INVITES TO MAKE SURE SOMEONE ELSE HAS NOT INVITED THIS USER
                    self.checkifInviteeHasAlreadyBeenInvited(JSONdata: snapDataGrab, selectedusersPhoneNumber: selectedPhoneNumber) { hasAlreadyBeenInvited in
                        
                        if hasAlreadyBeenInvited == false {
                            
                            let timeStamp : Double = Date().timeIntervalSince1970
                            
                            let familyName = i.familyName ?? "nil"
                            let givenName = i.givenName ?? "nil"
                            let phoneNumber = i.phoneNumber ?? "nil"
                            let fullPhoneNumber = i.fullPhoneNumber ?? "nil"
                            
                            let inviters_firstName = userProfileStruct.user_first_name ?? "nil"
                            let inviters_lastName = userProfileStruct.user_last_name ?? "nil"
                            let inviters_fullName = userProfileStruct.users_full_name ?? "nil"
                            let inviters_phoneNumber = userProfileStruct.users_phone_number ?? "nil"
                            let inviters_fullPhoneNumber = userProfileStruct.users_full_phone_number ?? "nil"
                            let inviters_UID = userProfileStruct.users_ref_key ?? "nil"
                            let inviters_country_code = userProfileStruct.users_country_code ?? "nil"
                            let inviters_email = userProfileStruct.users_email ?? "nil"
                            let referral_code = userProfileStruct.referral_code_grab ?? "nil"

                            guard let user_uid = Auth.auth().currentUser?.uid else {return}
                            
                            let refStamp = self.databaseRef.child("global_pending_invites").childByAutoId()
                            let personalStamp = self.databaseRef.child("personal_pending_invites").child(user_uid).childByAutoId()
                            
                                                           //MARK: - INVITERS INFORMATION
                            let values : [String : Any] = ["inviters_firstName" : inviters_firstName,
                                                           "inviters_lastName" : inviters_lastName,
                                                           "inviters_fullName" : inviters_fullName,
                                                           "inviters_phoneNumber" : inviters_phoneNumber,
                                                           "inviters_fullPhoneNumber" : inviters_fullPhoneNumber,
                                                           "inviters_UID" : inviters_UID,
                                                           "inviters_country_code" : inviters_country_code,
                                                           "inviters_email" : inviters_email,
                                                           "inviters_email_companion_success" : false,
                                                           
                                                           //MARK: - RECIPIENTS INFORMATION
                                                           "recipient_family_name" : familyName,
                                                           "recipient_given_name" : givenName,
                                                           "recipient_phone_number" : phoneNumber,
                                                           "recipient_full_phone_number" : fullPhoneNumber,
                                                           "time_stamp" : timeStamp]
                            
                            refStamp.updateChildValues(values) { error, ref in
                                personalStamp.updateChildValues(values) { error, ref in
                                    self.sendTextMessage(passedCountryCode: "1", passedPhoneNumber: "8455581855", passedReferralCode: referral_code, inviteesName: "\(inviters_firstName) \(inviters_lastName)")
                                }
                            }
                        } //MARK: - THESE USERS HAVE ALREADY BEEN INVITED FOR THE ELSE AT THIS BRACKET
                    }
                }
                
                //after loop - continue logic
                //MARK: - COMPLETED THE INVITE FUNCTION, BAIL OUT AND GO BACK
                self.unlockAndComplete()
                
            } else {
                
                var counter : Int = 0
                
                for i in filtered {
                    
                    let timeStamp : Double = Date().timeIntervalSince1970
                    
                    let familyName = i.familyName ?? "nil"
                    let givenName = i.givenName ?? "nil"
                    let phoneNumber = i.phoneNumber ?? "nil"
                    let fullPhoneNumber = i.fullPhoneNumber ?? "nil"
                    
                    let inviters_firstName = userProfileStruct.user_first_name ?? "nil"
                    let inviters_lastName = userProfileStruct.user_last_name ?? "nil"
                    let inviters_fullName = userProfileStruct.users_full_name ?? "nil"
                    let inviters_phoneNumber = userProfileStruct.users_phone_number ?? "nil"
                    let inviters_fullPhoneNumber = userProfileStruct.users_full_phone_number ?? "nil"
                    let inviters_UID = userProfileStruct.users_ref_key ?? "nil"
                    let inviters_country_code = userProfileStruct.users_country_code ?? "nil"
                    let inviters_email = userProfileStruct.users_email ?? "nil"
                    let referral_code = userProfileStruct.referral_code_grab ?? "nil"

                    guard let user_uid = Auth.auth().currentUser?.uid else {return}
                    
                    let refStamp = self.databaseRef.child("global_pending_invites").childByAutoId()
                    let personalStamp = self.databaseRef.child("personal_pending_invites").child(user_uid).childByAutoId()
                    
                    //MARK: - INVITERS INFORMATION
                    let values : [String : Any] = ["inviters_firstName" : inviters_firstName,
                                                   "inviters_lastName" : inviters_lastName,
                                                   "inviters_fullName" : inviters_fullName,
                                                   "inviters_phoneNumber" : inviters_phoneNumber,
                                                   "inviters_fullPhoneNumber" : inviters_fullPhoneNumber,
                                                   "inviters_UID" : inviters_UID,
                                                   "inviters_country_code" : inviters_country_code,
                                                   "inviters_email" : inviters_email,
                                                   "inviters_email_companion_success" : false,
                                                   
                                                   //MARK: - RECIPIENTS INFORMATION
                                                   "recipient_family_name" : familyName,
                                                   "recipient_given_name" : givenName,
                                                   "recipient_phone_number" : phoneNumber,
                                                   "recipient_full_phone_number" : fullPhoneNumber,
                                                   "time_stamp" : timeStamp]
                    
                    refStamp.updateChildValues(values) { error, ref in
                        personalStamp.updateChildValues(values) { error, ref in
                            
                            //MARK: - INCREASE THE COUNT AFTER THE DATABASE HAS BEEN UPDATED THEN COMPLETE OUT
                            counter += 1
                            
                            self.sendTextMessage(passedCountryCode: "1", passedPhoneNumber: phoneNumber, passedReferralCode: referral_code, inviteesName: "\(inviters_firstName) \(inviters_lastName)")
                            
                            //MARK: - FALL THROUGH ERROR
                            if counter == filtered.count {
                                self.unlockAndComplete()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkifInviteeHasAlreadyBeenInvited(JSONdata : DataSnapshot, selectedusersPhoneNumber : String, completion : @escaping (_ hasBeenInvited : Bool) -> ()) {
        
        var alreadyTaken : Bool = false
        
        for child in JSONdata.children.allObjects as! [DataSnapshot] {
            
            let JSON = child.value as? [String : AnyObject] ?? [:]
            
            let databasePhoneNumber = JSON["recipient_full_phone_number"] as? String ?? "nill"
            
            //MARK: - SELECTED RECIPIENTS - CHECK AGAINST THE DATABASE FOR PRIOIR INVITES
            let selectedUserPhoneNumber = selectedusersPhoneNumber
            
            if selectedUserPhoneNumber == databasePhoneNumber {
                alreadyTaken = true
                print("User already received an Referral Code")
            }
        }
        
        if alreadyTaken == true {
            completion(true)
        } else {
            completion(false)
        }
        
    }
    
    func unlockAndComplete() {
        self.navigationController?.popViewController(animated: true)
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
    
    func sendTextMessage(passedCountryCode : String, passedPhoneNumber : String, passedReferralCode : String, inviteesName : String) {
        
        let stringMessage = "Woof! Woof! \(inviteesName) has invited you to the Doggy Style iOS application (Groomers for Dirty Dogs) - Please use the following referral code during registration: \(passedReferralCode). Get it now: \(Statics.DOGGYSTYLE_CONSUMER_APP_URL)"
        
        TextMessageHTTP.shared.twilioSendTextMessage(users_country_code: passedCountryCode, users_phone_number: passedPhoneNumber, stringMessage: stringMessage) { response, error in
            print("Text message response: ", response)
        }
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


