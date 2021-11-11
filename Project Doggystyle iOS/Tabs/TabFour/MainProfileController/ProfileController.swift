//
//  ProfileController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/2/21.
//


import Foundation
import Firebase

class ProfileController : UIViewController, CustomAlertCallBackProtocol {
    
    var homeController : HomeViewController?
    let storageRef = Storage.storage().reference(),
        databaseRef = Database.database().reference()
    
    let dsCompanyLogoImage : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = true
        let image = UIImage(named: "DS Logo")?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        return dcl
    }()
    
    lazy var notificationIcon : UIButton = {
        
        let dcl = UIButton(type: .system)
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        dcl.setTitle(String.fontAwesomeIcon(name: .powerOff), for: .normal)
        dcl.tintColor = coreOrangeColor
        dcl.addTarget(self, action: #selector(self.handleLogout), for: .touchUpInside)
        
        return dcl
    }()
    
    lazy var profileImageView : UIImageView = {
        
        let pv = UIImageView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = coreLightGrayColor
        pv.contentMode = .scaleAspectFill
        pv.isUserInteractionEnabled = true
        pv.layer.masksToBounds = true
        pv.clipsToBounds = true
        pv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.checkForGalleryAuth)))
        return pv
    }()
    
    let containerView : UIView = {
        
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = coreWhiteColor
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        cv.layer.shadowColor = coreBlackColor.cgColor
        cv.layer.shadowOpacity = 0.1
        cv.layer.shadowOffset = CGSize(width: 0, height: 0)
        cv.layer.shadowRadius = 7
        cv.layer.shouldRasterize = false
        cv.layer.cornerRadius = 15
        
        return cv
    }()
    
    let nameLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = ""
        nl.font = UIFont(name: dsHeaderFont, size: 20)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = 1
        
        return nl
    }()
    
    let stylingSinceLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = ""
        nl.font = UIFont(name: rubikRegular, size: 13)
        nl.textColor = coreOrangeColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = 1
        
        return nl
    }()
    
    lazy var profileCollectionSubview : ProfileCollectionSubview = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let dh = ProfileCollectionSubview(frame: .zero, collectionViewLayout: layout)
        dh.profileController = self
        return dh
        
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
        
        let ai = UIActivityIndicatorView(style: .medium)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = coreOrangeColor
        ai.backgroundColor = coreBlackColor.withAlphaComponent(0.5)
        return ai
    }()
    
    lazy var pencilIcon : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 15, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        cbf.setTitleColor(coreOrangeColor, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleEditProfilePencil), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.navigationController?.navigationBar.isHidden = true
        
        self.addViews()
        self.fetchJSON()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.fetchJSON()
    }
    
    func addViews() {
        
        self.view.addSubview(self.notificationIcon)
        self.view.addSubview(self.dsCompanyLogoImage)
        
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.profileImageView)
        self.containerView.addSubview(self.nameLabel)
        self.containerView.addSubview(self.stylingSinceLabel)
        self.containerView.addSubview(self.pencilIcon)

        self.view.addSubview(self.profileCollectionSubview)
        self.view.addSubview(self.activityIndicator)
        
        self.notificationIcon.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        self.notificationIcon.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.notificationIcon.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.notificationIcon.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.dsCompanyLogoImage.centerYAnchor.constraint(equalTo: self.notificationIcon.centerYAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2.5).isActive = true
        self.dsCompanyLogoImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        self.containerView.topAnchor.constraint(equalTo: self.dsCompanyLogoImage.bottomAnchor, constant: 34).isActive = true
        self.containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.containerView.heightAnchor.constraint(equalToConstant: 147).isActive = true
        
        self.profileImageView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor, constant: 0).isActive = true
        self.profileImageView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 20).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 107).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 107).isActive = true
        self.profileImageView.layer.cornerRadius = 107/2
        
        self.nameLabel.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor, constant: -12).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 20).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -30).isActive = true
        self.nameLabel.sizeToFit()
        
        self.stylingSinceLabel.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor, constant: 12).isActive = true
        self.stylingSinceLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 20).isActive = true
        self.stylingSinceLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -30).isActive = true
        self.stylingSinceLabel.sizeToFit()
        
        self.pencilIcon.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 18).isActive = true
        self.pencilIcon.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -18).isActive = true
        self.pencilIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pencilIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true

        self.profileCollectionSubview.topAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 20).isActive = true
        self.profileCollectionSubview.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.profileCollectionSubview.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.profileCollectionSubview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor, constant: 0).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.profileImageView.centerXAnchor, constant: 0).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 107).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 107).isActive = true
        self.activityIndicator.layer.cornerRadius = 107/2
        
    }
    
    func fetchJSON() {
      
        let userProfilePhoto = userProfileStruct.users_profile_image_url ?? "nil"
        let users_name = userProfileStruct.users_full_name ?? "Incognito"
        self.nameLabel.text = users_name
        
        let accountCreationDate = Auth.auth().currentUser?.metadata.creationDate ?? nil
        
        if accountCreationDate == nil {
            self.stylingSinceLabel.text = "Doggystyling since 2021"
        } else {
            
            guard let dateFetch = accountCreationDate else {return}
            
            let calendar = Calendar.current
            let registrationYear = calendar.component(.year, from: dateFetch)
            self.stylingSinceLabel.text = "Doggystyling since \(registrationYear)"
            
        }
        
        if userProfilePhoto == "nil" {
            self.profileImageView.image = UIImage(named: "Owner Profile Placeholder")?.withRenderingMode(.alwaysOriginal)
        } else {
            self.profileImageView.loadImageGeneralUse(userProfilePhoto) { complete in
            }
        }
    }
    
    @objc func handleEditProfilePencil() {
        self.handleEditProfileController()
    }
    
    @objc func handleProfileSelection(sender : UIImageView) {
        print("handle profile selection")
    }
    
    @objc func handleCustomPopUpAlert(title : String, message : String, passedButtons: [String]) {
        
        let alert = AlertController()
        alert.passedTitle = title
        alert.passedMmessage = message
        alert.passedButtonSelections = passedButtons
        alert.customAlertCallBackProtocol = self
        
        alert.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    func onSelectionPassBack(buttonTitleForSwitchStatement type: String) {
        
        switch type {
        
        case Statics.OK: print(Statics.OK)
            
        default: print("Should not hit")
            
        }
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            return
        }
        
        Database.database().reference().removeAllObservers()
        
        let decisionController = DecisionController()
        let nav = UINavigationController(rootViewController: decisionController)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.navigationController?.present(nav, animated: true, completion: nil)
        
    }
    
    @objc func handleRefurFriend() {
        
        //MARK: - LOCATIONAL DATA FOR HAS A GROOMING LOCATION
        let locational_data = userProfileStruct.user_grooming_locational_data ?? ["nil" : "nil"]
        let hasGroomingLocation = locational_data["found_grooming_location"] as? Bool ?? false
        
        let referralCodeGrab = userProfileStruct.user_created_referral_code_grab ?? "nil"
        
        if referralCodeGrab == "nil" {
        
        let referralProgram = ReferralProgram()
        let nav = UINavigationController(rootViewController: referralProgram)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        referralProgram.clientHasGroomingLocation = hasGroomingLocation
        self.navigationController?.present(nav, animated: true, completion: nil)
            
        } else {

            let referralMonetaryController = ReferralMonetaryController()
            let nav = UINavigationController(rootViewController: referralMonetaryController)
            nav.modalPresentationStyle = .fullScreen
            nav.navigationBar.isHidden = true
            self.navigationController?.present(nav, animated: true, completion: nil)

        }
    }
    
    @objc func handleContactUs() {
        
        let contactUsProfileController = ContactUsProfileController()
        let nav = UINavigationController(rootViewController: contactUsProfileController)
        nav.navigationController?.navigationBar.isHidden = true
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true, completion: nil)
        
    }
    
    @objc func handleAddDogController() {
        
        var hasDog : Bool = false
        
        if userProfileStruct.user_has_doggy_profile != nil {
            guard let has_profile = userProfileStruct.user_has_doggy_profile else {return}
            hasDog = has_profile
        } else {
            hasDog = false
        }
        
        if hasDog == false {
        
            //MARK: - PRESENT IF THEIR ARE NO DOGS IN THEIR PROFILE
            let addDogEntryController = AddDogEntryController()
            let nav = UINavigationController(rootViewController: addDogEntryController)
            nav.modalPresentationStyle = .fullScreen
            nav.navigationController?.navigationBar.isHidden = true
            self.navigationController?.present(nav, animated: true, completion: nil)
            
        } else {
            
            //MARK: - PRESENT IF THEIR ARE DOGS IN THEIR PROFILE
            let myDogsCollectionContainer = MyDogsCollectionContainer()
            myDogsCollectionContainer.homeViewController = self.homeController
            myDogsCollectionContainer.navigationController?.navigationBar.isHidden = true
            myDogsCollectionContainer.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(myDogsCollectionContainer, animated: true)
            
        }
    }
    
    @objc func handleNotificationManagementController() {
        
        //MARK: - PRESENT IF THEIR ARE NO DOGS IN THEIR PROFILE
        let notificationManagement = NotificationManagement()
        let nav = UINavigationController(rootViewController: notificationManagement)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationController?.navigationBar.isHidden = true
        self.navigationController?.present(nav, animated: true, completion: nil)
        
    }
    
    @objc func handlePaymentPreferencesController() {
        
        let paymentMethodsController = PaymentMethodsController()
        let nav = UINavigationController(rootViewController: paymentMethodsController)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationController?.navigationBar.isHidden = true
        self.navigationController?.present(nav, animated: true, completion: nil)
        
    }
    
    
    @objc func handleEditProfileController() {
        
        let editProfileController = EditProfileController()
        let nav = UINavigationController(rootViewController: editProfileController)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationController?.navigationBar.isHidden = true
        self.navigationController?.present(nav, animated: true, completion: nil)
        
    }
    
    @objc func handleLocationChange() {
        
        let locationFinder = LocationFinder()
        let nav = UINavigationController(rootViewController: locationFinder)
        nav.modalPresentationStyle = .fullScreen
        globalLocationTrajectory = .fromSettings
        navigationController?.present(nav, animated: true)
    }
}
