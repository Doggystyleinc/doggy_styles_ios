//
//  EmptyStateOne.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/28/21.
//

import Foundation
import UIKit

class EmptyStateOne : UIView {
    
    var dashboardController : DashboardViewController?
    
    let welcomeContainer : UIView = {
        
        let wc = UIView()
        wc.translatesAutoresizingMaskIntoConstraints = false
        wc.backgroundColor = coreOrangeColor
        wc.isUserInteractionEnabled = true
        wc.layer.masksToBounds = true
        wc.layer.cornerRadius = 20
        
        return wc
    }()
    
    let welcomeSubContainer : UIView = {
        
        let wc = UIView()
        wc.translatesAutoresizingMaskIntoConstraints = false
        wc.backgroundColor = coreWhiteColor
        wc.isUserInteractionEnabled = true
        wc.layer.masksToBounds = true
        wc.layer.cornerRadius = 20
        wc.clipsToBounds = false
        wc.layer.masksToBounds = false
        wc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        wc.layer.shadowOpacity = 0.05
        wc.layer.shadowOffset = CGSize(width: 2, height: 3)
        wc.layer.shadowRadius = 9
        wc.layer.shouldRasterize = false
        return wc
        
    }()
    
    lazy var welcomeContainerCreateDoggyprofileButton : UIButton = {
        
        let wcc = UIButton(type: .system)
        wcc.translatesAutoresizingMaskIntoConstraints = false
        wcc.backgroundColor = coreWhiteColor
        wcc.isUserInteractionEnabled = true
        wcc.layer.masksToBounds = true
        let image = UIImage(named: "doggy_empty_state_one")?.withRenderingMode(.alwaysOriginal)
        wcc.setBackgroundImage(image, for: .normal)
        wcc.imageView?.contentMode = .scaleAspectFill
        wcc.contentMode = .scaleAspectFill
        wcc.addTarget(self.dashboardController, action: #selector(self.dashboardController?.handleNewDogFlow), for: .touchUpInside)
        return wcc
    }()
    
    let welcomeContainerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Create your\nDoggy’s profile"
        hl.font = UIFont(name: dsHeaderFont, size: 18)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = coreWhiteColor
        
        return hl
    }()
    
    let headerLabelEmptyStateOne : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Want Doggystyle in your neighborhood sooner?"
        hl.font = UIFont(name: dsSubHeaderFont, size: 18)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = coreBlackColor
        hl.textAlignment = .center
        
        return hl
    }()
    
    lazy var refurFriendButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Re-fur a friend", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 14
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreWhiteColor
        cbf.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cbf.layer.shadowOpacity = 0.05
        cbf.layer.shadowOffset = CGSize(width: 2, height: 3)
        cbf.layer.shadowRadius = 9
        cbf.layer.shouldRasterize = false
        cbf.addTarget(self.dashboardController, action: #selector(self.dashboardController?.handleReferAFriendButton), for: UIControl.Event.touchUpInside)
        
        return cbf
        
    }()
    
    let emptyStateOneContainer : UIView = {
        
        let es = UIView()
        es.backgroundColor = .clear
        es.isUserInteractionEnabled = true
        es.translatesAutoresizingMaskIntoConstraints = false
        
        return es
    }()
    
    let vehicleImage : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFit
        vi.isUserInteractionEnabled = false
        let image = UIImage(named: "vehicle_image")?.withRenderingMode(.alwaysOriginal)
        vi.image = image
        
        return vi
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addViews()
    }
    
    func addViews() {
        
        //MARK:- BEGIN Empty State One
        self.addSubview(self.emptyStateOneContainer)
        self.addSubview(self.welcomeContainer)
        self.addSubview(self.welcomeSubContainer)
        
        self.welcomeContainer.addSubview(self.welcomeContainerCreateDoggyprofileButton)
        self.welcomeContainer.addSubview(self.welcomeContainerLabel)
        self.welcomeSubContainer.addSubview(self.headerLabelEmptyStateOne)
        self.welcomeSubContainer.addSubview(self.refurFriendButton)
        self.welcomeSubContainer.addSubview(self.vehicleImage)
        //MARK:- END Empty State One
        
        //MARK: - EMPTY STATE ONE BEGIN
        self.emptyStateOneContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.emptyStateOneContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -90).isActive = true
        self.emptyStateOneContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.emptyStateOneContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        self.welcomeContainer.topAnchor.constraint(equalTo: self.emptyStateOneContainer.topAnchor, constant: 15).isActive = true
        self.welcomeContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.welcomeContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.welcomeContainer.heightAnchor.constraint(equalToConstant: 153).isActive = true
        
        self.welcomeSubContainer.topAnchor.constraint(equalTo: self.welcomeContainer.bottomAnchor, constant: 23).isActive = true
        self.welcomeSubContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.welcomeSubContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.welcomeSubContainer.bottomAnchor.constraint(equalTo: self.emptyStateOneContainer.bottomAnchor, constant: -30).isActive = true
        
        self.welcomeContainerCreateDoggyprofileButton.leftAnchor.constraint(equalTo: self.welcomeContainer.leftAnchor, constant: 30).isActive = true
        self.welcomeContainerCreateDoggyprofileButton.topAnchor.constraint(equalTo: self.welcomeContainer.topAnchor, constant: 28).isActive = true
        self.welcomeContainerCreateDoggyprofileButton.heightAnchor.constraint(equalToConstant: 98).isActive = true
        self.welcomeContainerCreateDoggyprofileButton.widthAnchor.constraint(equalToConstant: 98).isActive = true
        self.welcomeContainerCreateDoggyprofileButton.layer.cornerRadius = 98/2
        
        self.welcomeContainerLabel.leftAnchor.constraint(equalTo: self.welcomeContainerCreateDoggyprofileButton.rightAnchor, constant: 15).isActive = true
        self.welcomeContainerLabel.rightAnchor.constraint(equalTo: self.welcomeContainer.rightAnchor, constant: -10).isActive = true
        self.welcomeContainerLabel.topAnchor.constraint(equalTo: self.welcomeContainer.topAnchor, constant: 5).isActive = true
        self.welcomeContainerLabel.bottomAnchor.constraint(equalTo: self.welcomeContainer.bottomAnchor, constant: -5).isActive = true
        
        self.headerLabelEmptyStateOne.topAnchor.constraint(equalTo: self.welcomeSubContainer.topAnchor, constant: 30).isActive = true
        self.headerLabelEmptyStateOne.leftAnchor.constraint(equalTo: self.welcomeSubContainer.leftAnchor, constant: 40).isActive = true
        self.headerLabelEmptyStateOne.rightAnchor.constraint(equalTo: self.welcomeSubContainer.rightAnchor, constant: -40).isActive = true
        self.headerLabelEmptyStateOne.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.refurFriendButton.bottomAnchor.constraint(equalTo: self.welcomeSubContainer.bottomAnchor, constant: -20).isActive = true
        self.refurFriendButton.leftAnchor.constraint(equalTo: self.welcomeSubContainer.leftAnchor, constant: 30).isActive = true
        self.refurFriendButton.rightAnchor.constraint(equalTo: self.welcomeSubContainer.rightAnchor, constant: -30).isActive = true
        self.refurFriendButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.vehicleImage.bottomAnchor.constraint(equalTo: self.refurFriendButton.topAnchor, constant: -8).isActive = true
        self.vehicleImage.leftAnchor.constraint(equalTo: self.welcomeSubContainer.leftAnchor, constant: 18).isActive = true
        self.vehicleImage.rightAnchor.constraint(equalTo: self.welcomeSubContainer.rightAnchor, constant: -18).isActive = true
        self.vehicleImage.topAnchor.constraint(equalTo: self.headerLabelEmptyStateOne.bottomAnchor, constant: 8).isActive = true
        //MARK: - EMPTY STATE ONE END
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
