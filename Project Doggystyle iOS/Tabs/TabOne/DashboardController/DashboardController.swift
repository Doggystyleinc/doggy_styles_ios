//
//  DashboardViewController.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/2/21.
//

import UIKit
import Firebase
import SDWebImage
import GoogleMaps
import GooglePlaces

var doggyProfileDataSource = [DoggyProfileDataSource]()

class DashboardViewController: UIViewController, CustomAlertCallBackProtocol {
    
    enum StateListener {
        case YesGroomerLocationYesDoggyProfile
        case YesGroomerLocationNoDoggyProfile
        case NoGroomerLocationNoDoggyProfile
        case NoGroomerLocationYesDoggyProfile
    }
    
    var observingRefOne = Database.database().reference(),
        handleOne = DatabaseHandle(),
        childCounter : Int = 0,
        homeController: HomeViewController?,
        stateListener : StateListener = .NoGroomerLocationNoDoggyProfile
    
    let databaseRef = Database.database().reference(),
        logo = LogoImageView(frame: .zero)
    
    lazy var referButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = UIColor.dsOrange
        cbf.contentMode = .scaleAspectFill
        let image = UIImage(named: "ReFur Icon")?.withRenderingMode(.alwaysOriginal)
        cbf.setImage(image, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleReferralProgram), for: UIControl.Event.touchUpInside)
        cbf.clipsToBounds = false
        cbf.layer.masksToBounds = false
        cbf.layer.shadowColor = UIColor.black.cgColor
        cbf.layer.shadowOpacity = 0.1
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 9
        cbf.layer.shouldRasterize = false
        return cbf
        
    }()
    
    lazy var notificationIcon : UIButton = {
        
        let dcl = UIButton(type: .system)
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = true
        dcl.clipsToBounds = false
        dcl.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        dcl.setTitle(String.fontAwesomeIcon(name: .bell), for: .normal)
        dcl.tintColor = dsGreyMedium.withAlphaComponent(0.5)
        dcl.addTarget(self, action: #selector(self.handleNotificationsController), for: .touchUpInside)
        
        return dcl
    }()
    
    let notificationBubble : UILabel = {
        
        let nb = UILabel()
        nb.backgroundColor = UIColor.red
        nb.translatesAutoresizingMaskIntoConstraints = false
        nb.isUserInteractionEnabled = false
        nb.layer.masksToBounds = true
        nb.font = UIFont(name: dsHeaderFont, size: 11)
        nb.textAlignment = .center
        nb.layer.borderColor = coreWhiteColor.cgColor
        nb.layer.borderWidth = 1.5
        nb.text = ""
        nb.textColor = coreWhiteColor
        nb.isHidden = true
        
        return nb
    }()
    
    let dsCompanyLogoImage : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = false
        let image = UIImage(named: Constants.dsLogo)?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Welcome"
        hl.font = UIFont(name: dsHeaderFont, size: 24)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        
        return hl
    }()
    
    let broadcastingColorCircle : UIView = {
        
        let bcc = UIView()
        bcc.translatesAutoresizingMaskIntoConstraints = false
        bcc.layer.masksToBounds = true
        bcc.backgroundColor = coreRedColor
        
        return bcc
    }()
    
    lazy var emptyStateOne : EmptyStateOne = {
        
        let eso = EmptyStateOne(frame: .zero)
        eso.dashboardController = self
        
        return eso
        
    }()
    
    lazy var emptyStateTwo : EmptyStateTwo = {
        
        let eso = EmptyStateTwo(frame: .zero)
        eso.dashboardController = self
        
        return eso
        
    }()
    
    lazy var dashMainView : DashMainView = {
        
        let eso = DashMainView(frame: .zero)
        eso.dashboardController = self
        
        return eso
        
    }()
    
    lazy var todaysDashView : TodaysDashView = {
        
        let eso = TodaysDashView(frame: .zero)
        eso.dashboardController = self
        
        return eso
        
    }()
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = .dsViewBackground
        
        self.fillValues()
        self.addViews()
        
        self.emptyStateOne.isHidden = true
        self.emptyStateTwo.isHidden = true
        self.dashMainView.isHidden = true
        self.todaysDashView.isHidden = true
        
        self.callDataEngine()
        self.loadNotificationListener()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNewDogFlow), name: NSNotification.Name(Statics.CALL_ADD_NEW_PUP), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentAppointmentsController), name: NSNotification.Name(Statics.CALL_BOOK_NOW), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callDataEngine), name: NSNotification.Name(Statics.RUN_DATA_ENGINE), object: nil)
        
        //MARK: - CHECK FOR FACE ID
        Biometrics.shared.biometricAuth { complete in
            print("print \(complete)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.fillValues()
        
    }
    
    func addViews() {
        
        //MARK: - HEADER
        self.view.addSubview(self.referButton)
        self.view.addSubview(self.dsCompanyLogoImage)
        self.view.addSubview(self.notificationIcon)
        self.view.addSubview(self.notificationBubble)
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.broadcastingColorCircle)
        
        //MARK: - EMPTY STATE ONE
        self.view.addSubview(self.emptyStateOne)
        self.view.addSubview(self.emptyStateTwo)
        
        //MARK: - DASH VIEWS
        self.view.addSubview(self.dashMainView)
        self.view.addSubview(self.todaysDashView)
        
        self.referButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        self.referButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.referButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.referButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.dsCompanyLogoImage.centerYAnchor.constraint(equalTo: self.referButton.centerYAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.dsCompanyLogoImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        self.notificationIcon.centerYAnchor.constraint(equalTo: self.referButton.centerYAnchor, constant: 0).isActive = true
        self.notificationIcon.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.notificationIcon.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.notificationIcon.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.notificationBubble.topAnchor.constraint(equalTo: self.notificationIcon.topAnchor, constant: 7).isActive = true
        self.notificationBubble.rightAnchor.constraint(equalTo: self.notificationIcon.rightAnchor, constant: -7).isActive = true
        self.notificationBubble.heightAnchor.constraint(equalToConstant: 23).isActive = true
        self.notificationBubble.widthAnchor.constraint(equalToConstant: 23).isActive = true
        self.notificationBubble.layer.cornerRadius = 23/2
        
        self.broadcastingColorCircle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100).isActive = true
        self.broadcastingColorCircle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        self.broadcastingColorCircle.heightAnchor.constraint(equalToConstant: 5).isActive = true
        self.broadcastingColorCircle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
        self.broadcastingColorCircle.isHidden = true
        self.broadcastingColorCircle.layer.cornerRadius = 2.5
        
        self.headerLabel.topAnchor.constraint(equalTo: self.dsCompanyLogoImage.bottomAnchor, constant: 50).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.referButton.leftAnchor, constant: 5).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.emptyStateOne.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 10).isActive = true
        self.emptyStateOne.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.emptyStateOne.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.emptyStateOne.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.emptyStateTwo.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 10).isActive = true
        self.emptyStateTwo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.emptyStateTwo.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.emptyStateTwo.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.dashMainView.topAnchor.constraint(equalTo: self.headerLabel.topAnchor, constant: -10).isActive = true
        self.dashMainView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.dashMainView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.dashMainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.todaysDashView.topAnchor.constraint(equalTo: self.headerLabel.topAnchor, constant: -10).isActive = true
        self.todaysDashView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.todaysDashView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.todaysDashView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
    }
    
    func loadNotificationListener() {
        
        let usersFullPhoneNumber = userProfileStruct.users_full_phone_number ?? "nil"
        let replacementNumber = usersFullPhoneNumber.replacingOccurrences(of: " ", with: "")

        let ref = self.databaseRef.child("notifications").child(replacementNumber)
        
        var counter : Int = 0
        
        ref.observe(.value) { snapJSON in
            
            if snapJSON.exists() {
                
                for child in snapJSON.children.allObjects as! [DataSnapshot] {
                    
                    let JSON = child.value as? [String : AnyObject] ?? [:]
                    
                    let has_seen = JSON["notification_has_read"] as? Bool ?? false
                    
                    if has_seen == false {
                        counter += 1
                    }
                }
                
                if counter == 0 {
                    self.notificationBubble.isHidden = true
                    self.notificationBubble.text = ""
                } else {
                    self.notificationBubble.isHidden = false
                    self.notificationBubble.text = "\(counter)"
                    counter = 0
                }
                
                //MARK: - NO DATA HERE EXISTS YET
            } else if !snapJSON.exists() {
                self.notificationBubble.isHidden = true
                counter = 0
            }
        }
    }
    
    @objc func callDataEngine() {
        
        //MARK: - LOCATIONAL DATA FOR HAS A GROOMING LOCATION
        let locational_data = userProfileStruct.user_grooming_locational_data ?? ["nil" : "nil"]
        let hasGroomingLocation = locational_data["found_grooming_location"] as? Bool ?? false
        
        //MARK: - CHECK FOR DOGGY PROFILES (HEADER)
        self.fetchDataSource { isSuccess in
            
            //MARK: - HAS DOGGY PROFILE
            if isSuccess {
                
                userProfileStruct.user_has_doggy_profile = true

                //MARK: - SHARED DATASOURCE FOR THE MAIN DASH AND THE PROFILE MY DOGS TAB
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Statics.RELOAD_DOGGY_PROFILE_SETTINGS), object: self)
                
                if hasGroomingLocation == true {
                    //MARK: - USER HAS A GROOMING LOCATION AND A DOGGY PROFILE - YesGroomerLocationYesDoggyProfile
                    self.stateListener = .YesGroomerLocationYesDoggyProfile
                    self.callListener()
                } else {
                    //MARK: - USER DOES NOT HAVE A GROOMING LOCATION BUT HAS A DOGGY PROFILE - NoGroomerLocationYesDoggyProfile
                    self.stateListener = .NoGroomerLocationYesDoggyProfile
                    self.callListener()
                }
                
            //MARK: - DOES NOT HAVE DOGGY PROFILE
            } else {
                
                userProfileStruct.user_has_doggy_profile = false

                if hasGroomingLocation == true {
                    //MARK: - USER DOES NOT HAVE A DOGGY PROFILE BUT HAS A GROOMING LOCATION - YesGroomerLocationNoDoggyProfile
                    self.stateListener = .YesGroomerLocationNoDoggyProfile
                    self.callListener()
                } else {
                    //MARK: - USER DOES NOT HAVE A DOGGY PROFILE AND DOES NOT HAVE A LOCATION
                    self.stateListener = .NoGroomerLocationNoDoggyProfile
                    self.callListener()
                }
            }
        }
    }
    
    func fetchDataSource(completion : @escaping (_ isSuccess : Bool)->()) {
        
        guard let user_uid = Auth.auth().currentUser?.uid else {return}
        
        let countingRef = self.databaseRef.child("doggy_profile_builder").child(user_uid)
        
        let observingRef = self.databaseRef.child("doggy_profile_builder").child(user_uid)
        
        self.observingRefOne = self.databaseRef.child("doggy_profile_builder").child(user_uid)
        
        //MARK: - FOREVER LISTEN FOR CHANGES
        observingRef.observe(.value) { listener in
            
            doggyProfileDataSource.removeAll()
            
            self.dashMainView.mainDashCollectionView.doggyProfileDataSource.removeAll()
            
            self.dashMainView.registeredPetCollection.doggyProfileDataSource.removeAll()
            
            self.childCounter = 0
            
            //MARK: - CHECK COUNTS TP MATCH UP
            countingRef.observeSingleEvent(of: .value) { snapCount in
                
                if snapCount.exists() {
                    
                    let childrenCount = Int(snapCount.childrenCount)
                    
                    self.handleOne = self.observingRefOne.observe(.childAdded, with: { snapLoop in
                        
                        self.childCounter += 1
                        
                        guard let JSON = snapLoop.value as? [String : Any] else {return}
                        
                        let post = DoggyProfileDataSource(json: JSON)
                        
                        doggyProfileDataSource.append(post)
                        
                        if childrenCount == self.childCounter {
                            completion(true)
                        }
                    })
                    
                } else {
                    completion(false)
                }
            }
        }
    }
    
    //MARK: - STATE MACHINE FOR DASHBOARD ENTRY
    func callListener() {
        
        switch self.stateListener {
        
        case .NoGroomerLocationNoDoggyProfile:
            
            self.emptyStateOne.isHidden = false
            self.emptyStateTwo.isHidden = true
            self.dashMainView.isHidden = true
            self.todaysDashView.isHidden = true
            
            self.handleDatasourceFailure()
            
        case .YesGroomerLocationNoDoggyProfile:
            
            self.emptyStateOne.isHidden = true
            self.emptyStateTwo.isHidden = false
            self.dashMainView.isHidden = true
            self.todaysDashView.isHidden = true
            
            self.handleDatasourceFailure()
            
        case .YesGroomerLocationYesDoggyProfile:
            
            self.emptyStateOne.isHidden = true
            self.emptyStateTwo.isHidden = true
            self.dashMainView.isHidden = false
            self.dashMainView.locationFoundState = true
            self.dashMainView.runScreenChange()
            self.todaysDashView.isHidden = true
        
            self.handleDatasourceSuccess()
            
        case .NoGroomerLocationYesDoggyProfile:

            self.emptyStateOne.isHidden = true
            self.emptyStateTwo.isHidden = true
            self.dashMainView.isHidden = false
            self.dashMainView.locationFoundState = false
            self.dashMainView.runScreenChange()
            self.todaysDashView.isHidden = true
        
            self.handleDatasourceSuccess()

        }
    }
    
    func handleDatasourceFailure() {
       
        globalPetDataSource.removeAll()
        
        self.observingRefOne.removeObserver(withHandle: self.handleOne)
        self.childCounter = 0
        
        self.dashMainView.registeredPetCollection.doggyProfileDataSource.removeAll()
        doggyProfileDataSource.removeAll()
        
        DispatchQueue.main.async {
            self.dashMainView.registeredPetCollection.reloadData()
        }
    }
    
    func handleDatasourceSuccess() {
       
        self.observingRefOne.removeObserver(withHandle: self.handleOne)
        self.childCounter = 0
        
        var datasourceReplica = doggyProfileDataSource
        globalPetDataSource = doggyProfileDataSource
        
        let post = DoggyProfileDataSource(json: ["dog":"dog"])
        datasourceReplica.insert(post, at: 0)
        
        self.dashMainView.registeredPetCollection.doggyProfileDataSource = datasourceReplica
        
        DispatchQueue.main.async {
            self.dashMainView.registeredPetCollection.reloadData()
        }
    }
    
    func fillValues() {
        
        let usersFirstName = userProfileStruct.user_first_name ?? "Dog Lover"
        self.headerLabel.text = "Welcome, \(usersFirstName)"
        
    }
    
    @objc func handleNewDogFlow() {
       
        groomLocationFollowOnRoute = .fromApplication
        self.homeController?.handleAddNewDogFlow()
        
    }
    
    @objc func presentAppointmentsController() {
        
        let locational_data = userProfileStruct.user_grooming_locational_data ?? ["nil" : "nil"]
        let hasGroomingLocation = locational_data["found_grooming_location"] as? Bool ?? false
        
        let hasDogCount = doggyProfileDataSource.count
        if hasDogCount > 0 {
            if hasGroomingLocation == true {
                self.homeController?.presentBookingController()
            } else {
                self.handleCustomPopUpAlert(title: "INFORMATION NEEDED", message: "Before booking an appointment, you will need a serviceable location as well as your puppy added.", passedButtons: [Statics.GOT_IT])
           }
            
        } else {
            self.handleCustomPopUpAlert(title: "INFORMATION NEEDED", message: "Before booking an appointment, you will need a serviceable location as well as your puppy added.", passedButtons: [Statics.GOT_IT])
        }
    }
    
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
        
        case Statics.GOT_IT: print("got it")
            
        default: print("Should not hit")
            
        }
    }
    
    @objc func handleReferralProgram() {
        
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
    
    @objc func handleNotificationsController() {
        let notificationVC = YourNotificationController()
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc func handleTourTruckButton() {
        self.handleCustomPopUpAlert(title: "TRUCK TOUR", message: "Truck tour is currently under development. This feature will be available shortly.", passedButtons: [Statics.OK])
    }
    
    @objc private func didTapViewAllAppointments() {
        homeController?.switchTabs(tabIndex: 2)
    }
    
    @objc private func didTapViewAllServices() {
        homeController?.switchTabs(tabIndex: 1)
    }
}





























