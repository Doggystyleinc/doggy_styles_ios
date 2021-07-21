//
//  SlideOne.swift
//  DSGroomer
//
//  Created by Charlie Arcodia on 5/30/21.
//

import UIKit
import Foundation

class SlideOne: UIViewController {
    
    var tutorialClass : WelcomePageController?
    
    private let virtualTourViewer : UIView = {
        
        let vtv = UIView()
        vtv.backgroundColor = .white.withAlphaComponent(0.2)
        vtv.translatesAutoresizingMaskIntoConstraints = false
        vtv.isUserInteractionEnabled = true
        vtv.layer.cornerRadius = 12
        vtv.layer.masksToBounds = true
        
        return vtv
        
    }()
    
    private let subHeaderLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "Some filler text for the virtual viewer will go here for two lines"
        thl.font = UIFont.poppinsRegular(size: 15)
        thl.numberOfLines = 2
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = .white.withAlphaComponent(0.5)
        
        return thl
        
    }()
    
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
        
//        self.view.addSubview(self.orangeContainer)
        self.view.addSubview(self.virtualTourViewer)
        self.view.addSubview(self.subHeaderLabel)

//        self.orangeContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
//        self.orangeContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
//        self.orangeContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
//        self.orangeContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 1.7).isActive = true
//        
        self.virtualTourViewer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        self.virtualTourViewer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        self.virtualTourViewer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        self.virtualTourViewer.height(280)
        
        self.subHeaderLabel.topAnchor.constraint(equalTo: self.virtualTourViewer.bottomAnchor, constant: 10).isActive = true
        self.subHeaderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        self.subHeaderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        self.subHeaderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
}
