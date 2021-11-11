//
//  GroomerConfirmation.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/11/21.
//

import Foundation
import UIKit


class GroomerConfirmation : UIViewController {
    
    var isFlagShip : Bool = false
    
    let headerLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "Your grooming cycle has been successfully booked! "
        thl.font = UIFont(name: dsHeaderFont, size: 18)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let subHeaderLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "You’ll see the upcoming appointments on your dashboard. We’re excited to meet and pamper your doggy!"
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreBlackColor
        return thl
        
    }()
    
    lazy var dashboardButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Go to dashboard", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.addTarget(self, action: #selector(self.handleGoToDashboard), for: .touchUpInside)
        
        return cbf
        
    }()
    
    let centeredImage : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFill
        dcl.isUserInteractionEnabled = false
        let image = UIImage(named: "adorable_dog_icon")?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    //MARK: - DECISON MAKER SINCE WE WILL HAVE TWO STATES, ONE FOR THE FLAGSHIP AND THE OTHER FOR THE GROOMING TRUCKS
    func fillValues() {
        
        if self.isFlagShip {
            
        } else {
            
        }
    }
    
    func addViews() {
        
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.subHeaderLabel)
        self.view.addSubview(self.centeredImage)
        self.view.addSubview(self.dashboardButton)

        self.headerLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 167).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.headerLabel.sizeToFit()
        
        self.subHeaderLabel.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 15).isActive = true
        self.subHeaderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.subHeaderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.subHeaderLabel.sizeToFit()
        
        self.dashboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -170).isActive = true
        self.dashboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.dashboardButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.dashboardButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.centeredImage.topAnchor.constraint(equalTo: self.subHeaderLabel.bottomAnchor, constant: 0).isActive = true
        self.centeredImage.bottomAnchor.constraint(equalTo: self.dashboardButton.topAnchor, constant: 10).isActive = true
        self.centeredImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        self.centeredImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true

    }
    
    @objc func handleGoToDashboard() {
        print("dash entry")
    }
}
