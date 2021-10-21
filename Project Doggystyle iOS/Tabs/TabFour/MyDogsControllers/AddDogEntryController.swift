//
//  AddDogEntryController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/13/21.
//

import Foundation
import UIKit


class AddDogEntryController : UIViewController {
    
    lazy var backButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = UIColor.dsOrange
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let myDoggiesLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "My Doggies"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    lazy var addyourPupButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Add your pup", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.addTarget(self, action: #selector(self.handleAddPupButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    let pupImage : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = false
        let image = UIImage(named: "add_dog_image_profile")?.withRenderingMode(.alwaysOriginal)
        dcl.image = image
        
        return dcl
    }()
    
    let descriptionLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Hey human, I\nsee you haven’t\nadded any of\nyour doggies\nyet. Add your\ndoggy here!"
        thl.font = UIFont(name: rubikMedium, size: 20)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.myDoggiesLabel)
        self.view.addSubview(self.addyourPupButton)
        self.view.addSubview(self.pupImage)
        self.view.addSubview(self.descriptionLabel)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.myDoggiesLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 43).isActive = true
        self.myDoggiesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.myDoggiesLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.myDoggiesLabel.sizeToFit()
        
        self.addyourPupButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -120).isActive = true
        self.addyourPupButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.addyourPupButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.addyourPupButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.pupImage.topAnchor.constraint(equalTo: self.myDoggiesLabel.bottomAnchor, constant: 20).isActive = true
        self.pupImage.bottomAnchor.constraint(equalTo: self.addyourPupButton.topAnchor, constant: -20).isActive = true
        self.pupImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -10).isActive = true
        self.pupImage.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2.1).isActive = true
       
        self.descriptionLabel.topAnchor.constraint(equalTo: self.pupImage.topAnchor, constant: 0).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.pupImage.rightAnchor, constant: 10).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -35).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(equalTo: self.pupImage.bottomAnchor, constant: 0).isActive = true

    }
    
    @objc func handleAddPupButton() {
        
        self.navigationController?.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Statics.CALL_ADD_NEW_PUP), object: self)
        })
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
