//
//  SupportChatController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/13/21.
//

import Foundation
import UIKit

class SupportChatController : UIViewController {
    
    lazy var backButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreOrangeColor
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Chatting with <name>"
        hl.font = UIFont(name: dsHeaderFont, size: 24)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = dsFlatBlack
        
        return hl
    }()
    
    let subHeaderLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Grooming <ref=#9475>"
        hl.font = UIFont(name: rubikMedium, size: 18)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.textColor = dsFlatBlack
        
        return hl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.subHeaderLabel)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 17).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 11).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.headerLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 30).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.headerLabel.sizeToFit()
        
        self.subHeaderLabel.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 8).isActive = true
        self.subHeaderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.subHeaderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.subHeaderLabel.sizeToFit()
        
        
        
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
