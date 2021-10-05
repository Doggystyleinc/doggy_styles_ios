//
//  ConfirmBookingController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 9/3/21.
//

import UIKit
import Foundation

class ConfirmBookingController : UIViewController {
    
    lazy var stackView : UIStackView = {
        
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.isHidden = true
        
        return sv
    }()
    
    let headerBarOne : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
        hbo.layer.masksToBounds = true
        
        return hbo
    }()
    
    let headerBarTwo : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
        return hbo
    }()
    
    let headerBarThree : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
        return hbo
    }()
    
    let headerBarFour : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
        return hbo
    }()
    
    let timeCover : UIView = {
        
        let tc = UIView()
        tc.translatesAutoresizingMaskIntoConstraints = false
        tc.backgroundColor = coreBackgroundWhite
        
        return tc
    }()
    
    let basicDetailsLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Confirm Booking"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var cancelButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = UIColor.dsOrange
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        cbf.isHidden = false
        cbf.addTarget(self, action: #selector(self.handleCancelButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    lazy var xButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
        cbf.setTitleColor(dsRedColor, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    var headerContainer : UIView = {
        
        let hc = UIView()
        hc.translatesAutoresizingMaskIntoConstraints = false
        hc.backgroundColor = .clear
        hc.isUserInteractionEnabled = false
        
        return hc
    }()
    
    var appointmentDetailsContainer : UIView = {
        
        let adc = UIView()
        adc.translatesAutoresizingMaskIntoConstraints = false
        adc.backgroundColor = coreWhiteColor
        adc.clipsToBounds = false
        adc.layer.masksToBounds = false
        adc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        adc.layer.shadowOpacity = 0.05
        adc.layer.shadowOffset = CGSize(width: 2, height: 3)
        adc.layer.shadowRadius = 9
        adc.layer.shouldRasterize = false
        adc.layer.cornerRadius = 15
        
        return adc
    }()
    
    
    let appointmentDetailsLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Appointment Details"
        nl.font = UIFont(name: rubikBold, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var pencilIcon : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        cbf.setTitleColor(coreOrangeColor, for: .normal)
        return cbf
        
    }()
    
    let dateLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Date:"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = dsGreyMedium
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let pickupLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Pickup:"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = dsGreyMedium
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let finalDateLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Tuesday Dec 1, 2021"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .right
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let finalPickupLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Valet Pickup"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .right
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var confirmBookingCollection : ConfirmBookingCollection = {
        
        let layout = UICollectionViewFlowLayout()
        let cbc = ConfirmBookingCollection(frame: .zero, collectionViewLayout: layout)
        cbc.confirmBookingController = self
        
        return cbc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.headerBarOne)
        self.stackView.addArrangedSubview(self.headerBarTwo)
        self.stackView.addArrangedSubview(self.headerBarThree)
        self.stackView.addArrangedSubview(self.headerBarFour)
        
        self.view.addSubview(self.headerContainer)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.xButton)
        self.view.addSubview(self.basicDetailsLabel)
        self.view.addSubview(self.timeCover)
        
        self.view.addSubview(self.confirmBookingCollection)
        
        self.confirmBookingCollection.addSubview(self.appointmentDetailsContainer)
        
        self.appointmentDetailsContainer.addSubview(self.appointmentDetailsLabel)
        self.appointmentDetailsContainer.addSubview(self.pencilIcon)
        
        self.appointmentDetailsContainer.addSubview(self.dateLabel)
        self.appointmentDetailsContainer.addSubview(self.pickupLabel)
        
        self.appointmentDetailsContainer.addSubview(self.finalDateLabel)
        self.appointmentDetailsContainer.addSubview(self.finalPickupLabel)
        
        self.view.addSubview(confirmBookingCollection)
        
        self.headerBarOne.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarOne.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarOne.layer.cornerRadius = 4.5
        
        self.headerBarTwo.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarTwo.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarTwo.layer.cornerRadius = 4.5
        
        self.headerBarThree.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarThree.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarThree.layer.cornerRadius = 4.5
        
        self.headerBarFour.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarFour.heightAnchor.constraint(equalToConstant: 9).isActive = true
        self.headerBarFour.layer.cornerRadius = 4.5
        
        self.headerContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        self.headerContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.headerContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.headerContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.cancelButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: -20).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.headerContainer.leftAnchor, constant: 11).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.cancelButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.basicDetailsLabel.topAnchor.constraint(equalTo: self.cancelButton.bottomAnchor, constant: 25).isActive = true
        self.basicDetailsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.basicDetailsLabel.sizeToFit()
        
        self.xButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: -20).isActive = true
        self.xButton.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -11).isActive = true
        self.xButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.xButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.stackView.centerYAnchor.constraint(equalTo: self.basicDetailsLabel.centerYAnchor, constant: 0).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -30).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        self.stackView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.confirmBookingCollection.topAnchor.constraint(equalTo: self.headerContainer.bottomAnchor, constant: 50).isActive = true
        self.confirmBookingCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.confirmBookingCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.confirmBookingCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.appointmentDetailsContainer.bottomAnchor.constraint(equalTo: self.confirmBookingCollection.topAnchor, constant: -20).isActive = true
        self.appointmentDetailsContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.appointmentDetailsContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.appointmentDetailsContainer.heightAnchor.constraint(equalToConstant: 158).isActive = true
        
        self.pencilIcon.topAnchor.constraint(equalTo: self.appointmentDetailsContainer.topAnchor, constant: 25).isActive = true
        self.pencilIcon.rightAnchor.constraint(equalTo: self.appointmentDetailsContainer.rightAnchor, constant: -20).isActive = true
        self.pencilIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        self.pencilIcon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.appointmentDetailsLabel.leftAnchor.constraint(equalTo: self.appointmentDetailsContainer.leftAnchor, constant: 27).isActive = true
        self.appointmentDetailsLabel.rightAnchor.constraint(equalTo: self.pencilIcon.leftAnchor, constant: -20).isActive = true
        self.appointmentDetailsLabel.centerYAnchor.constraint(equalTo: self.pencilIcon.centerYAnchor, constant: 0).isActive = true
        self.appointmentDetailsLabel.sizeToFit()
        
        self.dateLabel.leftAnchor.constraint(equalTo: self.appointmentDetailsContainer.leftAnchor, constant: 27).isActive = true
        self.dateLabel.topAnchor.constraint(equalTo: self.appointmentDetailsLabel.bottomAnchor, constant: 26).isActive = true
        self.dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.dateLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.pickupLabel.leftAnchor.constraint(equalTo: self.appointmentDetailsContainer.leftAnchor, constant: 27).isActive = true
        self.pickupLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 21).isActive = true
        self.pickupLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pickupLabel.widthAnchor.constraint(equalToConstant: 65).isActive = true
        
        self.finalDateLabel.rightAnchor.constraint(equalTo: self.appointmentDetailsContainer.rightAnchor, constant: -30).isActive = true
        self.finalDateLabel.leftAnchor.constraint(equalTo: self.dateLabel.rightAnchor, constant: 20).isActive = true
        self.finalDateLabel.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor, constant: 0).isActive = true
        self.finalDateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.finalPickupLabel.rightAnchor.constraint(equalTo: self.appointmentDetailsContainer.rightAnchor, constant: -30).isActive = true
        self.finalPickupLabel.leftAnchor.constraint(equalTo: self.pickupLabel.rightAnchor, constant: 20).isActive = true
        self.finalPickupLabel.centerYAnchor.constraint(equalTo: self.pickupLabel.centerYAnchor, constant: 0).isActive = true
        self.finalPickupLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    @objc func handleEndAptDecisionController() {
        
        UIDevice.vibrateLight()
        
        let unavailableAptController = UnavailableAptController()
        unavailableAptController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(unavailableAptController, animated: true)
        
    }
    
    @objc func handleCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
