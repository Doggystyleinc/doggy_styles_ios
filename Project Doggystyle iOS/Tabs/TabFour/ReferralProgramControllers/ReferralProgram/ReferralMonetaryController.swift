//
//  ReferralMonetaryController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/15/21.
//

import Foundation
import UIKit
import Contacts
import Firebase

class ReferralMonetaryController : UIViewController, CustomAlertCallBackProtocol {
    
    let store = CNContactStore()
    var isActivePopupPresented : Bool = false

    var userGaveContactPermissions : Bool = false,
        pendingUsersMonetaryValueModel = [PendingUsersMonetaryValueModel]()
    
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
        thl.text = "Re-fur a Friend!"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let descriptionLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Re-fur a friend to the TLC and convenience of Doggystyle’s mobile grooming services. "
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    var bottomContainer : UIView = {
        
        let bc = UIView()
        bc.translatesAutoresizingMaskIntoConstraints = false
        bc.backgroundColor = coreWhiteColor
        bc.isUserInteractionEnabled = true
        bc.layer.masksToBounds = true
        bc.layer.cornerRadius = 15
        bc.clipsToBounds = false
        bc.layer.masksToBounds = false
        bc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        bc.layer.shadowOpacity = 0.05
        bc.layer.shadowOffset = CGSize(width: 2, height: 3)
        bc.layer.shadowRadius = 9
        bc.layer.shouldRasterize = false
        
       return bc
    }()
    
    var greyDividerLine : UIView = {
        
        let gdl = UIView()
        gdl.translatesAutoresizingMaskIntoConstraints = false
        gdl.backgroundColor = lightGrey
        return gdl
    }()
    
    let doggyDollarsLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "Doggy Dollars"
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let doggyCurrencyLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = ""
        thl.font = UIFont(name: rubikMedium, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let pendingLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "Pending"
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let pendingCurrencyLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = ""
        thl.font = UIFont(name: rubikMedium, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    lazy var upArrowButton : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 17, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .paperPlane), for: .normal)
        cbf.setTitleColor(coreOrangeColor, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleYourReferralsController), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let referralsLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Referrals"
        thl.font = UIFont(name: rubikMedium, size: 20)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreOrangeColor
        return thl
        
    }()
    
    let shareContainer : UIView = {
        
        let sc = UIView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .clear
        sc.layer.cornerRadius = 15
        sc.layer.borderWidth = 1
        sc.layer.borderColor = coreOrangeColor.cgColor
        sc.clipsToBounds = true
        
       return sc
    }()
    
    lazy var shareButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = coreOrangeColor
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .share), for: .normal)
        cbf.setTitleColor(coreWhiteColor, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleShareCodeButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let shareCodeLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = ""
        thl.font = UIFont(name: rubikMedium, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let rewardsLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Share to earn rewards"
        thl.font = UIFont(name: rubikMedium, size: 20)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreOrangeColor
        return thl
        
    }()
    
    let dogImage : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = false
        let image = UIImage(named: "referral_dog_image")?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    let pendingActivity : UIActivityIndicatorView = {
        
        let pa = UIActivityIndicatorView(style: .medium)
        pa.translatesAutoresizingMaskIntoConstraints = false
        pa.backgroundColor = .clear
        pa.hidesWhenStopped = true
        pa.color = dsFlatBlack
        pa.startAnimating()
        
       return pa
    }()
    
    let doggyActivity : UIActivityIndicatorView = {
        
        let pa = UIActivityIndicatorView(style: .medium)
        pa.translatesAutoresizingMaskIntoConstraints = false
        pa.backgroundColor = .clear
        pa.hidesWhenStopped = true
        pa.color = dsFlatBlack
        pa.startAnimating()

       return pa
    }()
    
    lazy var yourReferralPopup : YourReferralPopup = {
         
         let adpu = YourReferralPopup(frame: .zero)
         adpu.referralMonetaryController = self
             
        return adpu
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        
        self.addViews()
        self.fillValues()
        self.observePendingAndDoggyDollarsAmount()
        self.handleInviteRewardsController()
    
    }
    
    func handleInviteRewardsController() {
        
        //MARK: - HAS ALREADY SEEN THE INVITE ADS
        if let _ = UserDefaults.standard.object(forKey: "invite_10_dogs") as? Bool {
            print("user has seen the invites screen already")
        } else {
            //MARK: - HAs NOT SEEN INVITE ADS
            UserDefaults.standard.set(true, forKey:"invite_10_dogs")
            self.perform(#selector(self.handleReferralPopup), with: nil, afterDelay: 1.0)
        }
    }
    
    func observePendingAndDoggyDollarsAmount() {
        
        self.observeMonetaryPendingAndCompletedAmount { isComplete in
            
            let count = self.pendingUsersMonetaryValueModel.count
            
            self.pendingActivity.stopAnimating()
            self.doggyActivity.stopAnimating()
            
            if count == 0 {
                self.pendingCurrencyLabel.text = "$0"
                self.doggyCurrencyLabel.text = "$0"
            } else {
                let total = count * 5
                self.pendingCurrencyLabel.text = "$\(total)"
                self.doggyCurrencyLabel.text = "$0"
            }
        }
    }
    
    func fillValues() {
        
        let referralCode = userProfileStruct.user_created_referral_code_grab ?? "nil"
        
        if referralCode == "nil" {
            self.handleCustomPopUpAlert(title: "Error", message: "Well this is weird – your custom referral code has vanished. We were just alerted, we’ll have a fix out shortly. Thank you.", passedButtons: [Statics.GOT_IT])
        } else {
            self.shareCodeLabel.text = "\(referralCode)"
        }
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.earnLabel)
        self.view.addSubview(self.descriptionLabel)
        self.view.addSubview(self.bottomContainer)
        
        self.bottomContainer.addSubview(self.greyDividerLine)
        self.bottomContainer.addSubview(self.doggyDollarsLabel)
        self.bottomContainer.addSubview(self.pendingLabel)
        self.bottomContainer.addSubview(self.doggyCurrencyLabel)
        self.bottomContainer.addSubview(self.pendingCurrencyLabel)
        self.bottomContainer.addSubview(self.upArrowButton)
        
        self.view.addSubview(self.referralsLabel)
        self.view.addSubview(self.shareContainer)
        
        self.shareContainer.addSubview(self.shareButton)
        self.shareContainer.addSubview(self.shareCodeLabel)
        
        self.view.addSubview(self.rewardsLabel)
        self.view.addSubview(self.dogImage)
        
        self.view.addSubview(self.pendingActivity)
        self.view.addSubview(self.doggyActivity)
        self.view.addSubview(self.yourReferralPopup)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.earnLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 23).isActive = true
        self.earnLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.earnLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.earnLabel.sizeToFit()
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.earnLabel.bottomAnchor, constant: 29).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.descriptionLabel.sizeToFit()
        
        self.bottomContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -47).isActive = true
        self.bottomContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.bottomContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.bottomContainer.heightAnchor.constraint(equalToConstant: 133).isActive = true
        
        self.greyDividerLine.centerXAnchor.constraint(equalTo: self.bottomContainer.centerXAnchor, constant: 0).isActive = true
        self.greyDividerLine.topAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: 17).isActive = true
        self.greyDividerLine.bottomAnchor.constraint(equalTo: self.bottomContainer.bottomAnchor, constant: -17).isActive = true
        self.greyDividerLine.widthAnchor.constraint(equalToConstant: 1.5).isActive = true

        self.doggyDollarsLabel.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 8).isActive = true
        self.doggyDollarsLabel.rightAnchor.constraint(equalTo: self.greyDividerLine.leftAnchor, constant: -8).isActive = true
        self.doggyDollarsLabel.topAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: 34).isActive = true
        self.doggyDollarsLabel.sizeToFit()
        
        self.pendingLabel.rightAnchor.constraint(equalTo: self.bottomContainer.rightAnchor, constant: -8).isActive = true
        self.pendingLabel.leftAnchor.constraint(equalTo: self.greyDividerLine.rightAnchor, constant: 8).isActive = true
        self.pendingLabel.topAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: 34).isActive = true
        self.pendingLabel.sizeToFit()
        
        self.doggyCurrencyLabel.topAnchor.constraint(equalTo: self.doggyDollarsLabel.bottomAnchor, constant: 14).isActive = true
        self.doggyCurrencyLabel.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 10).isActive = true
        self.doggyCurrencyLabel.rightAnchor.constraint(equalTo: self.greyDividerLine.leftAnchor, constant: -10).isActive = true
        self.doggyCurrencyLabel.sizeToFit()
        
        self.doggyActivity.centerYAnchor.constraint(equalTo: self.doggyCurrencyLabel.centerYAnchor, constant: 8).isActive = true
        self.doggyActivity.centerXAnchor.constraint(equalTo: self.doggyCurrencyLabel.centerXAnchor, constant: 0).isActive = true
        self.doggyActivity.sizeToFit()
        
        self.pendingCurrencyLabel.topAnchor.constraint(equalTo: self.pendingLabel.bottomAnchor, constant: 14).isActive = true
        self.pendingCurrencyLabel.rightAnchor.constraint(equalTo: self.bottomContainer.rightAnchor, constant: -10).isActive = true
        self.pendingCurrencyLabel.leftAnchor.constraint(equalTo: self.greyDividerLine.rightAnchor, constant: 10).isActive = true
        self.pendingCurrencyLabel.sizeToFit()
        
        self.pendingActivity.centerYAnchor.constraint(equalTo: self.pendingCurrencyLabel.centerYAnchor, constant: 8).isActive = true
        self.pendingActivity.centerXAnchor.constraint(equalTo: self.pendingCurrencyLabel.centerXAnchor, constant: 0).isActive = true
        self.pendingActivity.sizeToFit()
        
        self.upArrowButton.rightAnchor.constraint(equalTo: self.bottomContainer.rightAnchor, constant: -13).isActive = true
        self.upArrowButton.topAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: 13).isActive = true
        self.upArrowButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.upArrowButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.referralsLabel.bottomAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: -24).isActive = true
        self.referralsLabel.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 0).isActive = true
        self.referralsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        self.referralsLabel.sizeToFit()
        
        self.shareContainer.bottomAnchor.constraint(equalTo: self.referralsLabel.topAnchor, constant: -14).isActive = true
        self.shareContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.shareContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.shareContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.shareButton.rightAnchor.constraint(equalTo: self.shareContainer.rightAnchor, constant: 0).isActive = true
        self.shareButton.topAnchor.constraint(equalTo: self.shareContainer.topAnchor, constant: 0).isActive = true
        self.shareButton.bottomAnchor.constraint(equalTo: self.shareContainer.bottomAnchor, constant: 0).isActive = true
        self.shareButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        
        self.shareCodeLabel.centerYAnchor.constraint(equalTo: self.shareContainer.centerYAnchor, constant: 0).isActive = true
        self.shareCodeLabel.leftAnchor.constraint(equalTo: self.shareContainer.leftAnchor, constant: 20).isActive = true
        self.shareCodeLabel.rightAnchor.constraint(equalTo: self.shareButton.leftAnchor, constant: -20).isActive = true
        self.shareCodeLabel.sizeToFit()
        
        self.rewardsLabel.bottomAnchor.constraint(equalTo: self.shareContainer.topAnchor, constant: -14).isActive = true
        self.rewardsLabel.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 0).isActive = true
        self.rewardsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        self.rewardsLabel.sizeToFit()
        
        self.dogImage.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 10).isActive = true
        self.dogImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.dogImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        self.dogImage.bottomAnchor.constraint(equalTo: self.rewardsLabel.topAnchor, constant: -10).isActive = true
        
    }
    
    @objc func handleBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func observeMonetaryPendingAndCompletedAmount(completion : @escaping (_ isComplete : Bool) -> ()) {
        
        guard let user_uid = Auth.auth().currentUser?.uid else {return}
        
        let personalStamp = self.databaseRef.child("global_pending_invites")
      
        personalStamp.observe(.value) { snapJSON in
            
            self.pendingUsersMonetaryValueModel.removeAll()
            
            self.pendingCurrencyLabel.text = ""
            self.doggyCurrencyLabel.text = ""
            
            self.pendingActivity.startAnimating()
            self.doggyActivity.startAnimating()

            for child in snapJSON.children.allObjects as! [DataSnapshot] {
                
                let JSON = child.value as? [String : AnyObject] ?? [:]
                
                let inviters_UID = JSON["inviters_UID"] as? String ?? "nil"
                
                print("I: ", inviters_UID)
                print("U: ", user_uid)
                
                if inviters_UID == user_uid {
                    
                    let model = PendingUsersMonetaryValueModel(JSON: JSON)
                    
                    self.pendingUsersMonetaryValueModel.append(model)
                }
            }
            
            completion(true)
        }
    }
    
    @objc func handleYourReferralsController() {

        let yourReferralContainer = YourReferralContainer()
        yourReferralContainer.modalPresentationStyle = .fullScreen
        yourReferralContainer.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(yourReferralContainer, animated: true)
        
    }
    
    @objc func handleShareCodeButton() {
        
        UIDevice.vibrateLight()
        self.checkForContactsPermissions()
    }
    
    func checkForContactsPermissions() {
        
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        
        case .authorized: self.contactsAuth(gavePermissions: true)
        case .denied: self.contactsAuth(gavePermissions: false)
        case .restricted, .notDetermined:
            
            self.store.requestAccess(for: .contacts, completionHandler: { (gaveAuth, error) in
                
                if error != nil {
                    self.contactsAuth(gavePermissions: false)
                    return
                }
                
                DispatchQueue.main.async {
                    self.contactsAuth(gavePermissions: true)
                }
            })
            
        default:
            print("Default for contacts permissions")
        }
    }
    
    func contactsAuth(gavePermissions : Bool) {
        
        self.userGaveContactPermissions = gavePermissions
        let referralCode = userProfileStruct.user_created_referral_code_grab ?? "nil"
        
        if gavePermissions == true {
            
            print("send the user to the contacts selection page")
            let referralContactsContainer = ReferralContactsContainer()
            referralContactsContainer.navigationController?.navigationBar.isHidden = true
            referralContactsContainer.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(referralContactsContainer, animated: true)
            
        } else {
            
            if referralCode != "nil" {
                ShareFunctionHelper.handleShareSheet(passedURLString: referralCode, passedView: self.view) { activityViewController in
                    self.navigationController?.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
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
        case Statics.OK: print(Statics.OK)
        case Statics.ENABLE : print("enable")
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    
                    if success {
                        print("success from the devices settings")
                    } else {
                        print("error from the devices settings")
                    }
                    
                })
            }
            
        default: print("Should not hit")
            
        }
    }
    
    @objc func handleReferralPopup() {
        print("called the new popup")
        if self.isActivePopupPresented {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveEaseInOut) {
                self.yourReferralPopup.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.35)
                self.view.layoutIfNeeded()
                self.yourReferralPopup.layoutIfNeeded()
            } completion: { complete in
                self.isActivePopupPresented = false
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveEaseInOut) {
                self.yourReferralPopup.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height - (UIScreen.main.bounds.height / 1.35)), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.35)
                self.view.layoutIfNeeded()
                self.yourReferralPopup.layoutIfNeeded()
            } completion: { complete in
                self.isActivePopupPresented = true
            }
        }
    }
}

class PendingUsersMonetaryValueModel : NSObject {
    
    var recipient_family_name : String?
    var recipient_full_phone_number : String?
    var recipient_given_name : String?
    var recipient_phone_number : String?

    var inviters_fullPhoneNumber : String?
    var inviters_email : String?
    var inviters_phoneNumber : String?
    var inviters_fullName : String?
    var inviters_UID : String?
   
    var inviters_country_code : String?
    var inviters_lastName : String?
    var inviters_firstName : String?
    var inviters_email_companion_success : Bool?
    var time_stamp : Double?
    
    init(JSON : [String : Any]) {
        
        self.recipient_family_name = JSON["recipient_family_name"] as? String ?? "nil"
        self.recipient_full_phone_number = JSON["recipient_full_phone_number"] as? String ?? "nil"
        self.recipient_given_name = JSON["recipient_given_name"] as? String ?? "nil"
        self.recipient_phone_number = JSON["recipient_phone_number"] as? String ?? "nil"
        self.inviters_fullPhoneNumber = JSON["inviters_fullPhoneNumber"] as? String ?? "nil"
        self.inviters_email = JSON["inviters_email"] as? String ?? "nil"
        self.inviters_phoneNumber = JSON["inviters_phoneNumber"] as? String ?? "nil"
        self.inviters_fullName = JSON["inviters_fullName"] as? String ?? "nil"
        self.inviters_UID = JSON["inviters_UID"] as? String ?? "nil"
        self.inviters_country_code = JSON["inviters_country_code"] as? String ?? "nil"
        self.inviters_lastName = JSON["inviters_lastName"] as? String ?? "nil"
        self.inviters_firstName = JSON["inviters_firstName"] as? String ?? "nil"
        self.inviters_email_companion_success = JSON["inviters_email_companion_success"] as? Bool ?? false
        self.time_stamp = JSON["time_stamp"] as? Double ?? 0.0

    }
}
