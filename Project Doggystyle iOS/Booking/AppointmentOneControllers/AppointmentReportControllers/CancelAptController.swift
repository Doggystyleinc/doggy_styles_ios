//
//  CancelAptController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/11/21.
//

import Foundation
import UIKit


class CancelAptController : UIViewController {
    
    lazy var xButton : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
        cbf.setTitleColor(dsRedColor, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleXButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let headerLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Cancel Appointment"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let subHeaderLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "We’re sorry you have to cancel, we’ll miss you. Feel free to simply cancel or reschedule for another time below. "
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreBlackColor
        return thl
        
    }()
    
    lazy var cancelButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Cancel this appointment", for: UIControl.State.normal)
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
    
    lazy var cancelRecurringApts : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Cancel recurring appointments", for: UIControl.State.normal)
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
        let image = UIImage(named: "")?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
   
    func addViews() {
        
        self.view.addSubview(self.xButton)

        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.subHeaderLabel)
        self.view.addSubview(self.centeredImage)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.cancelRecurringApts)
        
        self.xButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 66).isActive = true
        self.xButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -22).isActive = true
        self.xButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.xButton.widthAnchor.constraint(equalToConstant: 44).isActive = true

        self.headerLabel.topAnchor.constraint(equalTo: self.xButton.bottomAnchor, constant: 75).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.headerLabel.sizeToFit()
        
        self.subHeaderLabel.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 15).isActive = true
        self.subHeaderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.subHeaderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.subHeaderLabel.sizeToFit()
        
        self.cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -170).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.cancelButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.cancelRecurringApts.topAnchor.constraint(equalTo: self.cancelButton.bottomAnchor, constant: 10).isActive = true
        self.cancelRecurringApts.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.cancelRecurringApts.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.cancelRecurringApts.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.centeredImage.topAnchor.constraint(equalTo: self.subHeaderLabel.bottomAnchor, constant: 0).isActive = true
        self.centeredImage.bottomAnchor.constraint(equalTo: self.cancelButton.topAnchor, constant: 10).isActive = true
        self.centeredImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        self.centeredImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true

    }
    
    @objc func handleXButton() {
        
    }
    
    @objc func handleGoToDashboard() {
        print("dash entry")
    }
}
