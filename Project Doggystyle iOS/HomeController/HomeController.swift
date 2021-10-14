//
//  HomeViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/3/21.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

class HomeViewController: UITabBarController, CLLocationManagerDelegate, CustomAlertCallBackProtocol {
    
    private let dashboardController = DashboardViewController(),
                appointmentController = AppointmentsViewController(),
                profileController = ProfileController(),
                servicesController = ServicesController()
    
    let storageRef = Storage.storage().reference(),
        databaseRef = Database.database().reference(),
        locationManager = CLLocationManager()
    
    lazy var flagView : NoServiceFlag = {
        
        let fv = NoServiceFlag()
        fv.homeViewController = self
        
        return fv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .dsViewBackground
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.addViews()
        self.configureTabIcons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleServiceSatisfied), name: NSNotification.Name(Statics.HANDLE_SERVICE_SATISFIED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleServiceUnsatisfied), name: NSNotification.Name(Statics.HANDLE_SERVICE_UNSATISIFED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkForLocationServices), name: NSNotification.Name(Statics.RUN_LOCATION_CHECKER), object: nil)
        
        //MARK: - EXTENSION - CHECKS FOR SERVICE AND THROWS A NO SERVICE FLAG IS SERVICE IS DOWN
        NetworkMonitor.shared.startMonitoring()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.checkForLocationServices()
    }
    
    private func addViews() {
        
        self.tabBar.backgroundColor = coreWhiteColor
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        
    }
    
    func switchTabs(tabIndex : Int) {
        self.selectedIndex = tabIndex
    }
    
    @objc func handleServiceSatisfied() {
        self.flagView.cancelFlagView()
    }
    @objc func handleServiceUnsatisfied() {
        self.flagView.callFlagWindow()
    }
    
    private func configureTabIcons() {
        //MARK: - First Tab
        let tabOneIcon = UIImage(named: "Home Icon")?.withTintColor(.deselectedTab).withRenderingMode(.alwaysOriginal)
        let tabOneFillIcon = UIImage(named: "Home Icon")?.withTintColor(.dsOrange).withRenderingMode(.alwaysOriginal)
        
        let tabOne = UINavigationController(rootViewController: dashboardController)
        dashboardController.homeController = self
        tabOne.navigationBar.isHidden = true
        tabOne.tabBarItem = UITabBarItem(title: nil, image: tabOneIcon, selectedImage: tabOneFillIcon)
        
        //MARK: - Second Tab
        let tabTwoIcon = UIImage(named: "Services Icon")?.withTintColor(.deselectedTab).withRenderingMode(.alwaysOriginal)
        let tabTwoFillIcon = UIImage(named: "Services Icon")?.withTintColor(.dsOrange).withRenderingMode(.alwaysOriginal)
        
        let tabTwo = UINavigationController(rootViewController: servicesController)
        servicesController.homeController = self
        tabTwo.navigationBar.isHidden = true
        tabTwo.tabBarItem = UITabBarItem(title: nil, image: tabTwoIcon, selectedImage: tabTwoFillIcon)
        
        //MARK: - Third Tab
        let tabThreeIcon = UIImage(named: "Appointments Icon")?.withTintColor(.deselectedTab).withRenderingMode(.alwaysOriginal)
        let tabThreeFillIcon = UIImage(named: "Appointments Icon")?.withTintColor(.dsOrange).withRenderingMode(.alwaysOriginal)
        
        let tabThree = UINavigationController(rootViewController: appointmentController)
        appointmentController.homeController = self
        tabThree.navigationBar.isHidden = true
        tabThree.tabBarItem = UITabBarItem(title: nil, image: tabThreeIcon, selectedImage: tabThreeFillIcon)
        
        //MARK: - Fourth Tab
        let tabFourIcon = UIImage(named: "Profile Icon")?.withTintColor(.deselectedTab).withRenderingMode(.alwaysOriginal)
        let tabFourFillIcon = UIImage(named: "Profile Icon")?.withTintColor(.dsOrange).withRenderingMode(.alwaysOriginal)
        
        let tabFour = UINavigationController(rootViewController: profileController)
        profileController.homeController = self
        tabFour.navigationBar.isHidden = true
        tabFour.tabBarItem = UITabBarItem(title: nil, image: tabFourIcon, selectedImage: tabFourFillIcon)
        
        self.viewControllers = [tabOne, tabTwo, tabThree, tabFour]
        self.switchTabs(tabIndex: 0)
    }
    
    func uploadProfileImage(imageToUpload : UIImage, completion : @escaping (_ isComplete : Bool) -> ()) {
        
        guard let userUid = Auth.auth().currentUser?.uid else {return}
        guard let imageDataToUpload = imageToUpload.jpegData(compressionQuality: 0.15) else {return}
        
        let randomString = NSUUID().uuidString
        let imageRef = self.storageRef.child("imageSubmissions").child(userUid).child(randomString)
        
        imageRef.putData(imageDataToUpload, metadata: nil) { (metaDataPass, error) in
            
            if error != nil {
                completion(false);
                return
            }
            
            imageRef.downloadURL(completion: { (urlGRab, error) in
                
                if error != nil {
                    completion(false);
                    return
                }
                
                if let uploadUrl = urlGRab?.absoluteString {
                    
                    let values : [String : Any] = ["users_profile_image_url" : uploadUrl]
                    let refUploadPath = self.databaseRef.child("all_users").child(userUid)
                    
                    userProfileStruct.users_profile_image_url = uploadUrl
                    
                    refUploadPath.updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if error != nil {
                            completion(false);
                            return
                        } else {
                            completion(true);
                        }
                    })
                }
            })
        }
    }
    
    @objc func checkForLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch self.locationManager.authorizationStatus {
            
            case .authorizedAlways, .authorizedWhenInUse:
                
                self.dashboardController.broadcastingColorCircle.backgroundColor = coreGreenColor
                LocationBroadcaster.shared.runBroadcaster()
            default:
                
                self.handleCustomPopUpAlert(title: "LOCATION SERVICES", message: "To use the Doggystyle application, Location Services is required to let the groomers know when you’ll arrive.", passedButtons: [Statics.GOT_IT])
                self.dashboardController.broadcastingColorCircle.backgroundColor = coreRedColor
            }
        } else {
            self.dashboardController.broadcastingColorCircle.backgroundColor = coreRedColor
        }
    }
    
    @objc func handleCustomPopUpAlert(title : String, message : String, passedButtons: [String]) {
        
        let alert = AlertController()
        alert.passedTitle = title
        alert.passedMmessage = message
        alert.passedButtonSelections = passedButtons
        alert.customAlertCallBackProtocol = self
        alert.passedIconName = .mapPin
        alert.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    func onSelectionPassBack(buttonTitleForSwitchStatement type: String) {
        
        switch type {
        
        case Statics.GOT_IT:
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("in the settings with a flag of: \(success)")
                })
            }
            
        default: print("Should not hit")
            
        }
    }
    
    func handleAddNewDogFlow() {
        
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
    
    func presentBookingController() {
        
        let bookingController = AppointmentOne()
        bookingController.doggyProfileDataSource = globalPetDataSource
        let nav = UINavigationController(rootViewController: bookingController)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
}
