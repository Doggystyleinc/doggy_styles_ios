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
    
    let headerViewCell : UIView = {
        
        let hvc = UIView()
        hvc.translatesAutoresizingMaskIntoConstraints = false
        hvc.backgroundColor = coreWhiteColor
        hvc.isUserInteractionEnabled = true
        hvc.clipsToBounds = false
        hvc.layer.masksToBounds = false
        hvc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        hvc.layer.shadowOpacity = 0.05
        hvc.layer.shadowOffset = CGSize(width: 2, height: 3)
        hvc.layer.shadowRadius = 9
        hvc.layer.shouldRasterize = false
        hvc.layer.cornerRadius = 15

        return hvc
    }()
    
    let bodyViewCell : UIView = {
        
        let hvc = UIView()
        hvc.translatesAutoresizingMaskIntoConstraints = false
        hvc.backgroundColor = coreWhiteColor
        hvc.isUserInteractionEnabled = true
        hvc.clipsToBounds = false
        hvc.layer.masksToBounds = false
        hvc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        hvc.layer.shadowOpacity = 0.05
        hvc.layer.shadowOffset = CGSize(width: 2, height: 3)
        hvc.layer.shadowRadius = 9
        hvc.layer.shouldRasterize = false
        hvc.layer.cornerRadius = 15
        return hvc
    }()
    
    let footerViewCell : UIView = {
        
        let hvc = UIView()
        hvc.translatesAutoresizingMaskIntoConstraints = false
        hvc.backgroundColor = coreWhiteColor
        hvc.isUserInteractionEnabled = true
        hvc.clipsToBounds = false
        hvc.layer.masksToBounds = false
        hvc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        hvc.layer.shadowOpacity = 0.05
        hvc.layer.shadowOffset = CGSize(width: 2, height: 3)
        hvc.layer.shadowRadius = 9
        hvc.layer.shouldRasterize = false
        hvc.layer.cornerRadius = 15
        return hvc
    }()
    
    let allowNotificationsLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Allow push notifications"
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreBlackColor
        return thl
        
    }()
    
    lazy var allowNotificationsSwitch : UISwitch = {
        
        let bs = UISwitch()
        bs.translatesAutoresizingMaskIntoConstraints = false
        bs.tintColor = UIColor .lightGray
        bs.thumbTintColor = UIColor .white
        bs.setOn(true, animated: false)
        bs.isUserInteractionEnabled = true
        bs.addTarget(self, action: #selector(self.handleToggle), for: .touchUpInside)
        return bs
        
    }()
    
    let alertMeLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Alert me:"
        thl.font = UIFont(name: rubikBold, size: 18)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreOrangeColor
        return thl
        
    }()
    
    let otherNotificationsLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Other Notification Types"
        thl.font = UIFont(name: rubikBold, size: 18)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreOrangeColor
        return thl
        
    }()
    
    let smsLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "SMS"
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreBlackColor
        return thl
        
    }()
    
    lazy var smsArrow : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreBlackColor
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .arrowRight), for: .normal)
        cbf.addTarget(self, action: #selector(self.handleSMSAlerts), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    lazy var notificationAlertsCollectionView : NotificationAlertsCollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let nalv = NotificationAlertsCollectionView(frame: .zero, collectionViewLayout: layout)
        nalv.translatesAutoresizingMaskIntoConstraints = false
        nalv.notificationManagement = self

       return nalv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
        self.allowNotificationsSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.earnLabel)
        self.view.addSubview(self.headerViewCell)
        self.view.addSubview(self.bodyViewCell)
        self.view.addSubview(self.footerViewCell)
        
        self.headerViewCell.addSubview(self.allowNotificationsSwitch)
        self.headerViewCell.addSubview(self.allowNotificationsLabel)
        
        self.bodyViewCell.addSubview(self.alertMeLabel)
        self.bodyViewCell.addSubview(self.notificationAlertsCollectionView)

        self.footerViewCell.addSubview(self.otherNotificationsLabel)
        self.footerViewCell.addSubview(self.smsLabel)
        self.footerViewCell.addSubview(self.smsArrow)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.earnLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 18).isActive = true
        self.earnLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.earnLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.earnLabel.sizeToFit()
        
        self.headerViewCell.topAnchor.constraint(equalTo: self.earnLabel.bottomAnchor, constant: 28).isActive = true
        self.headerViewCell.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.headerViewCell.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.headerViewCell.heightAnchor.constraint(equalToConstant: 68).isActive = true
        
        self.bodyViewCell.topAnchor.constraint(equalTo: self.headerViewCell.bottomAnchor, constant: 20).isActive = true
        self.bodyViewCell.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.bodyViewCell.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.bodyViewCell.heightAnchor.constraint(equalToConstant: 290).isActive = true
        
        self.footerViewCell.topAnchor.constraint(equalTo: self.bodyViewCell.bottomAnchor, constant: 20).isActive = true
        self.footerViewCell.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.footerViewCell.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.footerViewCell.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.allowNotificationsSwitch.centerYAnchor.constraint(equalTo: self.headerViewCell.centerYAnchor, constant: 0).isActive = true
        self.allowNotificationsSwitch.rightAnchor.constraint(equalTo: self.headerViewCell.rightAnchor, constant: -20).isActive = true
        
        self.allowNotificationsLabel.centerYAnchor.constraint(equalTo: self.headerViewCell.centerYAnchor, constant: 0).isActive = true
        self.allowNotificationsLabel.leftAnchor.constraint(equalTo: self.headerViewCell.leftAnchor, constant: 20).isActive = true
        self.allowNotificationsLabel.rightAnchor.constraint(equalTo: self.allowNotificationsSwitch.leftAnchor, constant: -20).isActive = true
        self.allowNotificationsLabel.sizeToFit()
        
        self.alertMeLabel.topAnchor.constraint(equalTo: self.bodyViewCell.topAnchor, constant: 23).isActive = true
        self.alertMeLabel.leftAnchor.constraint(equalTo: self.bodyViewCell.leftAnchor, constant: 20).isActive = true
        self.alertMeLabel.sizeToFit()
        
        self.otherNotificationsLabel.topAnchor.constraint(equalTo: self.footerViewCell.topAnchor, constant: 23).isActive = true
        self.otherNotificationsLabel.leftAnchor.constraint(equalTo: self.footerViewCell.leftAnchor, constant: 20).isActive = true
        self.otherNotificationsLabel.sizeToFit()
        
        self.smsArrow.rightAnchor.constraint(equalTo: self.footerViewCell.rightAnchor, constant: -20).isActive = true
        self.smsArrow.topAnchor.constraint(equalTo: self.otherNotificationsLabel.bottomAnchor, constant: 15).isActive = true
        self.smsArrow.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.smsArrow.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.smsLabel.leftAnchor.constraint(equalTo: self.footerViewCell.leftAnchor, constant: 20).isActive = true
        self.smsLabel.centerYAnchor.constraint(equalTo: self.smsArrow.centerYAnchor, constant: 0).isActive = true
        self.smsLabel.rightAnchor.constraint(equalTo: self.smsArrow.leftAnchor, constant: -10).isActive = true
        self.smsLabel.sizeToFit()
        
        self.notificationAlertsCollectionView.topAnchor.constraint(equalTo: self.alertMeLabel.bottomAnchor, constant: 20).isActive = true
        self.notificationAlertsCollectionView.leftAnchor.constraint(equalTo: self.bodyViewCell.leftAnchor, constant: 0).isActive = true
        self.notificationAlertsCollectionView.rightAnchor.constraint(equalTo: self.bodyViewCell.rightAnchor, constant: 0).isActive = true
        self.notificationAlertsCollectionView.bottomAnchor.constraint(equalTo: self.bodyViewCell.bottomAnchor, constant: -20).isActive = true

    }
    
    @objc func handleToggle(sender : UISwitch) {
        
    }
    
    @objc func handleSMSAlerts() {
        
    }
    
    @objc func handleBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
