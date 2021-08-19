//
//  HomeViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/3/21.
//

import UIKit
import Firebase

final class HomeViewController: UITabBarController {
    
    private let dashboardController = DashboardViewController()
    private let appointmentController = AppointmentsViewController()
    private let profileController = ProfileController()
    private let servicesController = ServicesController()
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabVC()
        configureTabIcons()
        
    }
}

//MARK: - Configure Controller
extension HomeViewController {
    private func configureTabVC() {
        self.view.backgroundColor = .dsViewBackground
        self.tabBar.backgroundColor = .white
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
    }
}

//MARK: - Helpers
extension HomeViewController {
    func switchTabs(tabIndex : Int) {
        self.selectedIndex = tabIndex
    }
    
    private func configureTabIcons() {
        //First Tab
        let tabOneIcon = UIImage(named: "Home Icon")?.withTintColor(.deselectedTab).withRenderingMode(.alwaysOriginal)
        let tabOneFillIcon = UIImage(named: "Home Icon")?.withTintColor(.dsOrange).withRenderingMode(.alwaysOriginal)
        
        let tabOne = UINavigationController(rootViewController: dashboardController)
        dashboardController.homeController = self
        tabOne.navigationBar.isHidden = true
        tabOne.tabBarItem = UITabBarItem(title: nil, image: tabOneIcon, selectedImage: tabOneFillIcon)
        
        //Second Tab
        let tabTwoIcon = UIImage(named: "Services Icon")?.withTintColor(.deselectedTab).withRenderingMode(.alwaysOriginal)
        let tabTwoFillIcon = UIImage(named: "Services Icon")?.withTintColor(.dsOrange).withRenderingMode(.alwaysOriginal)
        
        let tabTwo = UINavigationController(rootViewController: servicesController)
        servicesController.homeController = self
        tabTwo.navigationBar.isHidden = true
        tabTwo.tabBarItem = UITabBarItem(title: nil, image: tabTwoIcon, selectedImage: tabTwoFillIcon)
        
        //Third Tab
        let tabThreeIcon = UIImage(named: "Appointments Icon")?.withTintColor(.deselectedTab).withRenderingMode(.alwaysOriginal)
        let tabThreeFillIcon = UIImage(named: "Appointments Icon")?.withTintColor(.dsOrange).withRenderingMode(.alwaysOriginal)
        
        let tabThree = UINavigationController(rootViewController: appointmentController)
        appointmentController.homeController = self
        tabThree.navigationBar.isHidden = true
        tabThree.tabBarItem = UITabBarItem(title: nil, image: tabThreeIcon, selectedImage: tabThreeFillIcon)
        
        //Fourth Tab
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
                    
                    let values : [String : Any] = ["profile_image_url" : uploadUrl]
                    let refUploadPath = self.databaseRef.child("all_users").child(userUid)
                    
                    userProfileStruct.profile_image_url = uploadUrl
                    
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
    
    func presentBookingController() {
        print("two")

        let bookingController = AppointmentOne()
        let nav = UINavigationController(rootViewController: bookingController)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
}
