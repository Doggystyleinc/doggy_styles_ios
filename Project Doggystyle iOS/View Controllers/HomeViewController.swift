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
        
        let configHome = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        
        let tabOneIcon = UIImage(systemName: "house", withConfiguration: configHome)?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        let tabOneFillIcon = UIImage(systemName: "house", withConfiguration: configHome)?.withTintColor(.orange).withRenderingMode(.alwaysOriginal)
        
        let tabOne = UINavigationController(rootViewController: self.dashboardController)
        self.dashboardController.homeController = self
        tabOne.navigationBar.isHidden = true
        tabOne.tabBarItem = UITabBarItem(title: nil, image: tabOneIcon, selectedImage: tabOneFillIcon)
        
        
        let tabTwoIcon = UIImage(systemName: "doc", withConfiguration: configHome)?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        let tabTwoFillIcon = UIImage(systemName: "doc.fill", withConfiguration: configHome)?.withTintColor(.orange).withRenderingMode(.alwaysOriginal)
        
        let tabTwo = UINavigationController(rootViewController: self.secondaryController)
        self.secondaryController.homeController = self
        tabTwo.navigationBar.isHidden = true
        tabTwo.tabBarItem = UITabBarItem(title: nil, image: tabTwoIcon, selectedImage: tabTwoFillIcon)
        
        let tabThreeIcon = UIImage(systemName: "bookmark", withConfiguration: configHome)?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        let tabThreeFillIcon = UIImage(systemName: "bookmark.fill", withConfiguration: configHome)?.withTintColor(.orange).withRenderingMode(.alwaysOriginal)
        
        let tabThree = UINavigationController(rootViewController: self.thirdController)
        self.thirdController.homeController = self
        tabThree.navigationBar.isHidden = true
        tabThree.tabBarItem = UITabBarItem(title: nil, image: tabThreeIcon, selectedImage: tabThreeFillIcon)
        
        let tabFourIcon = UIImage(systemName: "gearshape", withConfiguration: configHome)?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        let tabFourFillIcon = UIImage(systemName: "gearshape.fill", withConfiguration: configHome)?.withTintColor(.orange).withRenderingMode(.alwaysOriginal)
        
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
