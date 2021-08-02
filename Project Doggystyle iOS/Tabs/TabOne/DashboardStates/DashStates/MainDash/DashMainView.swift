//
//  DashMainView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/1/21.
//

import Foundation
import UIKit


class DashMainView : UIView {
    
    var dashboardController : DashboardViewController?
    
    lazy var registeredPetCollection : RegisteredPetCollection = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let rpc = RegisteredPetCollection(frame: .zero, collectionViewLayout: layout)
        rpc.dashMainView = self
        
       return rpc
    }()
    
    lazy var mainDashCollectionView : MainDashboardCollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let rpc = MainDashboardCollectionView(frame: .zero, collectionViewLayout: layout)
        rpc.dashMainView = self
        
       return rpc
    }()
    
    
    lazy var selectorSwitch : SelectorSwitch = {
        
        let ss = SelectorSwitch()
        ss.translatesAutoresizingMaskIntoConstraints = false
       return ss
        
    }()
    
    lazy var bookNowButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Book now", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 18
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreWhiteColor
        cbf.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cbf.layer.shadowOpacity = 0.5
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 4
        cbf.layer.shouldRasterize = false
        
        return cbf
        
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.registeredPetCollection)
        self.addSubview(self.selectorSwitch)
        self.addSubview(self.mainDashCollectionView)
        self.addSubview(self.bookNowButton)

        self.registeredPetCollection.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.registeredPetCollection.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.registeredPetCollection.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.registeredPetCollection.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.selectorSwitch.topAnchor.constraint(equalTo: self.registeredPetCollection.bottomAnchor, constant: 15).isActive = true
        self.selectorSwitch.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.selectorSwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.selectorSwitch.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        self.mainDashCollectionView.topAnchor.constraint(equalTo: self.selectorSwitch.bottomAnchor, constant: 8).isActive = true
        self.mainDashCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.mainDashCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.mainDashCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.bookNowButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100).isActive = true
        self.bookNowButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.bookNowButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.bookNowButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
