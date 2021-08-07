//
//  NewDogEntry.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/1/21.
//

import Foundation
import UIKit

class NewDogEntry : UIViewController {
    
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
    
    lazy var confirmButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Create doggy profile", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 18
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.addTarget(self, action: #selector(self.handleCreateDoggyProfile), for: .touchUpInside)
        
        return cbf
        
    }()
    
    let dogImage : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFit
        vi.isUserInteractionEnabled = false
        let image = UIImage(named: "doggy_profile_image")?.withRenderingMode(.alwaysOriginal)
        vi.image = image
        
       return vi
    }()
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Yes, doggies need\nprofiles too."
        hl.font = UIFont(name: dsHeaderFont, size: 32)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        
        return hl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.confirmButton)
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.dogImage)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 11).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.headerLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 90).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.confirmButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -110).isActive = true
        self.confirmButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.confirmButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.confirmButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.dogImage.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 20).isActive = true
        self.dogImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.dogImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.dogImage.bottomAnchor.constraint(equalTo: self.confirmButton.topAnchor, constant: 90).isActive = true
        
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCreateDoggyProfile() {
        let newDogOne = NewDogOne()
        newDogOne.modalPresentationStyle = .fullScreen
        newDogOne.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(newDogOne, animated: true)
    }
}
