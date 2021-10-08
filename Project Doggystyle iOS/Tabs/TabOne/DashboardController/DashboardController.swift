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

class DashboardViewController: UIViewController {
    
    enum StateListener {
        
        case YesGroomerLocationYesDoggyProfile
        case NoGroomerLocationYesDoggyProfile
        case YesGroomerLocationNoDoggyProfile
        case NoGroomerLocationNoDoggyProfile
        
    }
    
    var observingRefOne = Database.database().reference(),
        handleOne = DatabaseHandle(),
        childCounter : Int = 0,
        homeController: HomeViewController?,
        doggyProfileDataSource = [DoggyProfileDataSource](),
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
        cbf.addTarget(self, action: #selector(self.didTapRefur), for: UIControl.Event.touchUpInside)
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
        nb.text = "1"
        nb.textColor = coreWhiteColor
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNewDogFlow), name: NSNotification.Name(Statics.CALL_ADD_NEW_PUP), object: nil)
        
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
        
        self.referButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
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
    
    func callDataEngine() {
        
        //MARK: - LOCATIONAL DATA FOR HAS A GROOMING LOCATION
        let locational_data = userProfileStruct.user_grooming_locational_data ?? ["nil" : "nil"]
        let hasGroomingLocation = locational_data["found_grooming_location"] as? Bool ?? false
        
        //MARK: - CHECK FOR DOGGY PROFILES (HEADER)
        self.fetchDataSource { isSuccess in
            
            if isSuccess {
                
                if hasGroomingLocation == true {
                    //MARK: - USER HAS A GROOMING LOCATION AND A DOGGY PROFILE - YesGroomerLocationYesDoggyProfile
                    self.stateListener = .YesGroomerLocationYesDoggyProfile
                    
                } else {
                    //MARK: - USER DOES NOT HAVE A GROOMING LOCATION BUT HAS A DOGGY PROFILE - NoGroomerLocationYesDoggyProfile
                    self.stateListener = .NoGroomerLocationYesDoggyProfile
                    
                }
            } else {
                
                if hasGroomingLocation == true {
                    //MARK: - USER DOES NOT HAVE A DOGGY PROFILE BUT HAS A GROOMING LOCATION - YesGroomerLocationNoDoggyProfile
                    self.stateListener = .YesGroomerLocationNoDoggyProfile
                    
                } else {
                    //MARK: - USER DOES NOT HAVE A DOGGY PROFILE AND DOES NOT HAVE A LOCATION
                    self.stateListener = .NoGroomerLocationNoDoggyProfile
                    
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
            
            self.doggyProfileDataSource.removeAll()
            
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
                        
                        self.doggyProfileDataSource.append(post)
                        
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
    
    func callListener() {
        
        switch self.stateListener {
        
        case .NoGroomerLocationNoDoggyProfile: print("NoGroomerLocationNoDoggyProfile")
        case .NoGroomerLocationYesDoggyProfile: print("NoGroomerLocationYesDoggyProfile")
        case .YesGroomerLocationNoDoggyProfile: print("YesGroomerLocationNoDoggyProfile")
        case .YesGroomerLocationYesDoggyProfile: print("YesGroomerLocationYesDoggyProfile")
        
        }
        
    }
    
    func handleDatasourceFailure() {
        
        self.emptyStateOne.isHidden = true //has refur a friends at the bottom - and add doggy profile, the one that has been there for a while now
        self.emptyStateTwo.isHidden = true //new to doggystyle, tour the truick
        self.dashMainView.isHidden = true //not sure, just has a selector - prob the main view
        self.todaysDashView.isHidden = false // todays apt view with the stats, get ready etc...
        
        globalPetDataSource.removeAll()
        
        self.observingRefOne.removeObserver(withHandle: self.handleOne)
        self.childCounter = 0
        
        self.dashMainView.registeredPetCollection.doggyProfileDataSource.removeAll()
        self.doggyProfileDataSource.removeAll()
        
        DispatchQueue.main.async {
            self.dashMainView.registeredPetCollection.reloadData()
        }
    }
    
    func handleDatasourceSuccess() {
        
        self.emptyStateOne.isHidden = false
        self.emptyStateTwo.isHidden = true
        self.dashMainView.isHidden = false
        self.todaysDashView.isHidden = true
        
        self.observingRefOne.removeObserver(withHandle: self.handleOne)
        self.childCounter = 0
        
        var datasourceReplica = self.doggyProfileDataSource
        globalPetDataSource = self.doggyProfileDataSource
        
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
    
    @objc func handleReferAFriendButton() {
        self.didTapRefur()
    }
    
    @objc func handleNewDogFlow() {
        
        //MARK: - HAS ALREADY SEEN THE ENTRY PAGE
        if let _ = UserDefaults.standard.object(forKey: "entry_path_one") as? Bool {
            
            let newDogOne = NewDogOne()
            let navigationController = UINavigationController(rootViewController: newDogOne)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.navigationBar.isHidden = true
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        } else {
            
            //MARK: - HAD NOT SEEN THE ENTRY PAGE
            UserDefaults.standard.set(true, forKey:"entry_path_one")
            
            let newDogEntry = NewDogEntry()
            let navigationController = UINavigationController(rootViewController: newDogEntry)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.navigationBar.isHidden = true
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        }
    }
    
    @objc func presentAppointmentsController() {
        self.homeController?.presentBookingController()
    }
    
    @objc private func didTapRefur() {
        let refurVC = RefurAFriendController()
        self.present(refurVC, animated: true)
    }
    
    @objc func handleNotificationsController() {
        let notificationVC = YourNotificationController()
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc func handleTourTruckButton() {
        print("Handle tour")
    }
    
    @objc private func didTapViewAllAppointments() {
        homeController?.switchTabs(tabIndex: 2)
    }
    
    @objc private func didTapViewAllServices() {
        homeController?.switchTabs(tabIndex: 1)
    }
}





























