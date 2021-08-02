//
//  NewDogFive.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/28/21.
//

import Foundation
import UIKit

class NewDogFive : UIViewController {
    
    lazy var checkLabel : UILabel = {
        
        let pv = UILabel()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = .clear
        pv.isUserInteractionEnabled = true
        pv.clipsToBounds = false
        pv.layer.masksToBounds = true
        pv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        pv.layer.shadowOpacity = 0.05
        pv.layer.shadowOffset = CGSize(width: 2, height: 3)
        pv.layer.shadowRadius = 9
        pv.layer.shouldRasterize = false
        pv.textAlignment = .center
        pv.font = UIFont.fontAwesome(ofSize: 60, style: .solid)
        pv.text = String.fontAwesomeIcon(name: .checkCircle)
        pv.textColor = coreOrangeColor
        
        return pv
    }()
    
    let profileLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Rex's Profile Created"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .center
        nl.numberOfLines = 1
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    let profileSubHeaderLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Lorem ipsum dolor sit amet,\nconsecteur adipiscing."
        nl.font = UIFont(name: dsHeaderFont, size: 16)
        nl.textColor = dsFlatBlack.withAlphaComponent(0.4)
        nl.textAlignment = .center
        nl.numberOfLines = 3
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    lazy var continueButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Continue", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.addTarget(self, action: #selector(self.handleContinueButton), for: .touchUpInside)

        return cbf
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
    }
    
    func addViews() {
        
        self.view.addSubview(self.checkLabel)
        self.view.addSubview(self.profileLabel)
        self.view.addSubview(self.profileSubHeaderLabel)
        self.view.addSubview(self.continueButton)

        self.checkLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -110).isActive = true
        self.checkLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.checkLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.checkLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.profileLabel.topAnchor.constraint(equalTo: self.checkLabel.bottomAnchor, constant: 22).isActive = true
        self.profileLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.profileLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.profileLabel.sizeToFit()
        
        self.profileSubHeaderLabel.topAnchor.constraint(equalTo: self.profileLabel.bottomAnchor, constant: 14).isActive = true
        self.profileSubHeaderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.profileSubHeaderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.profileSubHeaderLabel.sizeToFit()
        
        self.continueButton.topAnchor.constraint(equalTo: self.profileSubHeaderLabel.bottomAnchor, constant: 50).isActive = true
        self.continueButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.continueButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.continueButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    @objc func handleContinueButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
