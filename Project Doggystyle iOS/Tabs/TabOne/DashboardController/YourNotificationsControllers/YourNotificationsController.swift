//
//  NotificationController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/2/21.
//

import Foundation
import UIKit


class YourNotificationController : UIViewController {
    
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
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Your Notifications"
        hl.font = UIFont(name: dsHeaderFont, size: 32)
        hl.numberOfLines = 2
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        
        return hl
    }()
    
    lazy var selectorSwitch : NotificationsSelector = {
        
        let ss = NotificationsSelector()
        ss.translatesAutoresizingMaskIntoConstraints = false
        ss.yourNotificationController = self
        
        return ss
        
    }()
    
    lazy var yourNotificationsCollectionView : YourNotificationsCollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let rpc = YourNotificationsCollectionView(frame: .zero, collectionViewLayout: layout)
        rpc.yourNotificationsController = self
        
       return rpc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.selectorSwitch)
        self.view.addSubview(self.yourNotificationsCollectionView)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 11).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.headerLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 53).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.headerLabel.sizeToFit()
        
        self.selectorSwitch.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 15).isActive = true
        self.selectorSwitch.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.selectorSwitch.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.selectorSwitch.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        self.yourNotificationsCollectionView.topAnchor.constraint(equalTo: self.selectorSwitch.bottomAnchor, constant: 20).isActive = true
        self.yourNotificationsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.yourNotificationsCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.yourNotificationsCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
