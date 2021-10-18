//
//  NotificationManagement.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/18/21.
//

import Foundation
import UIKit

class NotificationManagement : UIViewController {
    
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
    
    let earnLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Notification Settings"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    lazy var notificationCollectionView : NotificationCollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let ncv = NotificationCollectionView(frame: .zero, collectionViewLayout: layout)
        ncv.notificationManagement = self
        
       return ncv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.earnLabel)
        self.view.addSubview(self.notificationCollectionView)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.earnLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 23).isActive = true
        self.earnLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.earnLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.earnLabel.sizeToFit()
        
        self.notificationCollectionView.topAnchor.constraint(equalTo: self.earnLabel.bottomAnchor, constant: 20).isActive = true
        self.notificationCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.notificationCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.notificationCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

    }
    
    @objc func handleBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
