//
//  HomeViewController.swift
//  Project Doggystyle
//
//  Created by Stanley Miller on 5/3/21.
//

import UIKit
import Firebase

final class HomeViewController: UITabBarController {
    private let databaseRef = Database.database().reference()
    private let dashboardController = DashboardViewController()
    private let secondaryController = SecondaryViewController()
    private let thirdController = ThirdViewController()
    private let fourthController = FourthViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabVC()
    }
}

//MARK: - Configure Controller
extension HomeViewController {
    private func configureTabVC() {
        self.view.backgroundColor = .white
        self.tabBar.backgroundColor = .white
        self.tabBar.backgroundImage = UIImage()
        
        let tabOneIcon = UIImage(named: "Home Icon")
        let tabOneFillIcon = UIImage(named: "Home Icon")?.withTintColor(.dsOrange).withRenderingMode(.alwaysOriginal)
        
        let tabOne = UINavigationController(rootViewController: self.dashboardController)
        tabOne.navigationBar.isHidden = true
        tabOne.tabBarItem = UITabBarItem(title: nil, image: tabOneIcon, selectedImage: tabOneFillIcon)
        
        
        let tabTwoIcon = UIImage(named: "Services Icon")
        let tabTwoFillIcon = UIImage(named: "Services Icon")?.withTintColor(.dsOrange).withRenderingMode(.alwaysOriginal)
        
        let tabTwo = UINavigationController(rootViewController: self.secondaryController)
        self.secondaryController.homeController = self
        tabTwo.navigationBar.isHidden = true
        tabTwo.tabBarItem = UITabBarItem(title: nil, image: tabTwoIcon, selectedImage: tabTwoFillIcon)
        
        let tabThreeIcon = UIImage(named: "Appointments Icon")
        let tabThreeFillIcon = UIImage(named: "Appointments Icon")?.withTintColor(.dsOrange).withRenderingMode(.alwaysOriginal)
        
        let tabThree = UINavigationController(rootViewController: self.thirdController)
        self.thirdController.homeController = self
        tabThree.navigationBar.isHidden = true
        tabThree.tabBarItem = UITabBarItem(title: nil, image: tabThreeIcon, selectedImage: tabThreeFillIcon)
        
        let tabFourIcon = UIImage(named: "Profile Icon")
        let tabFourFillIcon = UIImage(named: "Profile Icon")?.withTintColor(.dsOrange).withRenderingMode(.alwaysOriginal)
        
        let tabFour = UINavigationController(rootViewController: self.fourthController)
        self.fourthController.homeController = self
        tabFour.navigationBar.isHidden = true
        tabFour.tabBarItem = UITabBarItem(title: nil, image: tabFourIcon, selectedImage: tabFourFillIcon)
        
        self.viewControllers = [tabOne, tabTwo, tabThree, tabFour]
        self.switchTabs(tabIndex: 0)
    }
}

//MARK: - Helpers
extension HomeViewController {
    private func switchTabs(tabIndex : Int) {
        self.selectedIndex = tabIndex
    }
}
