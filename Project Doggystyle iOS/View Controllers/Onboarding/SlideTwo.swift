//
//  SlideTwo.swift
//  DSGroomer
//
//  Created by Charlie Arcodia on 5/30/21.
//

import UIKit
import Foundation
import Lottie

class SlideTwo: UIViewController, CAAnimationDelegate {
    var tutorialClass : WelcomePageController?
    
    private let orangeContainer : UIView = {
        let oc = UIView()
        oc.translatesAutoresizingMaskIntoConstraints = false
        oc.backgroundColor = .dsOrange
        oc.isUserInteractionEnabled = false
        return oc
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViews()
    }
    
    private func addViews() {
        self.view.addSubview(self.orangeContainer)
        self.orangeContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.orangeContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.orangeContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.orangeContainer.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 70).isActive = true
    }
}
