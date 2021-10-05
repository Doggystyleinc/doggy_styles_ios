//
//  EmptyStateTwo.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/1/21.
//

import Foundation
import UIKit

class EmptyStateTwo : UIView {
    
    var dashboardController : DashboardViewController?
    
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
    
    let newUserLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "New to Doggystyle?"
        hl.font = UIFont(name: dsSubHeaderFont, size: 20)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .center
        hl.textColor = coreBlackColor
        
        return hl
    }()
    
    lazy var tourButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Tour the doggystyle truck!", for: UIControl.State.normal)
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
        cbf.addTarget(self.dashboardController, action: #selector(self.dashboardController?.handleTourTruckButton), for: UIControl.Event.touchUpInside)
        
        return cbf
        
    }()
    
    let dogOrangeShadow : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFit
        vi.isUserInteractionEnabled = false
        let image = UIImage(named: "orange_shadow_image")?.withRenderingMode(.alwaysOriginal)
        vi.image = image
        vi.backgroundColor = .clear
        vi.clipsToBounds = true
        vi.layer.masksToBounds = true
        
        return vi
    }()
    
    let dogImage : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFit
        vi.isUserInteractionEnabled = false
        let image = UIImage(named: "doggy_empty_state_two")?.withRenderingMode(.alwaysOriginal)
        vi.image = image
        vi.backgroundColor = .clear
        vi.clipsToBounds = true
        vi.layer.masksToBounds = true
        
        return vi
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.welcomeSubContainer)
        self.addSubview(self.newUserLabel)
        self.addSubview(self.tourButton)
        self.addSubview(self.dogOrangeShadow)
        self.addSubview(self.dogImage)
        
        self.welcomeSubContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.welcomeSubContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.welcomeSubContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.welcomeSubContainer.heightAnchor.constraint(equalToConstant: 378).isActive = true
        
        self.newUserLabel.topAnchor.constraint(equalTo: self.welcomeSubContainer.topAnchor, constant: 40).isActive = true
        self.newUserLabel.leftAnchor.constraint(equalTo: self.welcomeSubContainer.leftAnchor, constant: 30).isActive = true
        self.newUserLabel.rightAnchor.constraint(equalTo: self.welcomeSubContainer.rightAnchor, constant: -30).isActive = true
        self.newUserLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.tourButton.bottomAnchor.constraint(equalTo: self.welcomeSubContainer.bottomAnchor, constant: -20).isActive = true
        self.tourButton.leftAnchor.constraint(equalTo: self.welcomeSubContainer.leftAnchor, constant: 17).isActive = true
        self.tourButton.rightAnchor.constraint(equalTo: self.welcomeSubContainer.rightAnchor, constant: -17).isActive = true
        self.tourButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.dogOrangeShadow.topAnchor.constraint(equalTo: self.newUserLabel.bottomAnchor, constant: 20).isActive = true
        self.dogOrangeShadow.leftAnchor.constraint(equalTo: self.welcomeSubContainer.leftAnchor, constant: 0).isActive = true
        self.dogOrangeShadow.rightAnchor.constraint(equalTo: self.welcomeSubContainer.rightAnchor, constant: 0).isActive = true
        self.dogOrangeShadow.bottomAnchor.constraint(equalTo: self.tourButton.topAnchor, constant: 40).isActive = true
        
        self.dogImage.topAnchor.constraint(equalTo: self.newUserLabel.bottomAnchor, constant: 20).isActive = true
        self.dogImage.leftAnchor.constraint(equalTo: self.welcomeSubContainer.leftAnchor, constant: 15).isActive = true
        self.dogImage.rightAnchor.constraint(equalTo: self.welcomeSubContainer.rightAnchor, constant: 0).isActive = true
        self.dogImage.bottomAnchor.constraint(equalTo: self.tourButton.topAnchor, constant: 0).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
