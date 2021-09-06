//
//  AvailableAptScreen.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 9/6/21.
//

import Foundation
import UIKit


class AvailableAptScreen : UIViewController {
    
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

    let luckyDayLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Today is your lucky day"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let luckyDaySubHeaderLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "An appointment has become available in your area. Your doggy will receive the services you selected when booking your appointments. Click below to book."
        nl.font = UIFont(name: rubikRegular, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.numberOfLines = -1
        
        return nl
    }()
    
    let aptDetailsLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Appointment Details"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.numberOfLines = -1
        
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
        cbf.isHidden = true
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
    
    let selectDogForAptLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Select dog for appointment"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.numberOfLines = -1
        
        return nl
    }()
    
    let stylistLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Doggystylist:"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = dsGreyMedium
        nl.textAlignment = .left
        
        return nl
    }()
    
    let finalStylistLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Jessica M"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .right
        nl.adjustsFontSizeToFitWidth = true

        return nl
    }()
    
    let dateLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Date:"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = dsGreyMedium
        nl.textAlignment = .left
        
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
    
    let timeLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Time:"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = dsGreyMedium
        nl.textAlignment = .left
        
        return nl
    }()
    
    let finalTimeLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Approx 12:30 PM"
        nl.font = UIFont(name: rubikRegular, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .right
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var bookAptButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Book Appointment", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 12
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.isHidden = false
        cbf.addTarget(self, action: #selector(self.handleCancelButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var availableAptCollection : AvailableAptCollection = {
        
        let layout = UICollectionViewFlowLayout()
        let cbc = AvailableAptCollection(frame: .zero, collectionViewLayout: layout)
        cbc.availableAptScreen = self
        
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
        self.view.addSubview(self.luckyDayLabel)
        self.view.addSubview(self.timeCover)
        self.view.addSubview(self.luckyDaySubHeaderLabel)
        self.view.addSubview(self.aptDetailsLabel)
        
        self.view.addSubview(self.appointmentDetailsContainer)
        self.view.addSubview(self.selectDogForAptLabel)
        
        self.appointmentDetailsContainer.addSubview(self.stylistLabel)
        self.appointmentDetailsContainer.addSubview(self.finalStylistLabel)

        self.appointmentDetailsContainer.addSubview(self.dateLabel)
        self.appointmentDetailsContainer.addSubview(self.finalDateLabel)
        
        self.appointmentDetailsContainer.addSubview(self.timeLabel)
        self.appointmentDetailsContainer.addSubview(self.finalTimeLabel)
        
        self.view.addSubview(self.bookAptButton)
        
        self.view.addSubview(self.availableAptCollection)

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
        
        self.luckyDayLabel.topAnchor.constraint(equalTo: self.cancelButton.bottomAnchor, constant: 25).isActive = true
        self.luckyDayLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.luckyDayLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.luckyDayLabel.sizeToFit()
        
        self.xButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: -20).isActive = true
        self.xButton.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -11).isActive = true
        self.xButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.xButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.stackView.centerYAnchor.constraint(equalTo: self.luckyDayLabel.centerYAnchor, constant: 0).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -30).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        self.stackView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.luckyDaySubHeaderLabel.topAnchor.constraint(equalTo: self.luckyDayLabel.bottomAnchor, constant: 15).isActive = true
        self.luckyDaySubHeaderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.luckyDaySubHeaderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.luckyDaySubHeaderLabel.sizeToFit()
        
        self.aptDetailsLabel.topAnchor.constraint(equalTo: self.luckyDaySubHeaderLabel.bottomAnchor, constant: 15).isActive = true
        self.aptDetailsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.aptDetailsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.aptDetailsLabel.sizeToFit()
        
        self.appointmentDetailsContainer.topAnchor.constraint(equalTo: self.aptDetailsLabel.bottomAnchor, constant: 15).isActive = true
        self.appointmentDetailsContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.appointmentDetailsContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.appointmentDetailsContainer.heightAnchor.constraint(equalToConstant: 158).isActive = true
        
        self.selectDogForAptLabel.topAnchor.constraint(equalTo: self.appointmentDetailsContainer.bottomAnchor, constant: 20).isActive = true
        self.selectDogForAptLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.selectDogForAptLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.selectDogForAptLabel.sizeToFit()
        
        self.stylistLabel.leftAnchor.constraint(equalTo: self.appointmentDetailsContainer.leftAnchor, constant: 27).isActive = true
        self.stylistLabel.topAnchor.constraint(equalTo: self.appointmentDetailsContainer.topAnchor, constant: 21).isActive = true
        self.stylistLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.stylistLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
        
        self.finalStylistLabel.rightAnchor.constraint(equalTo: self.appointmentDetailsContainer.rightAnchor, constant: -30).isActive = true
        self.finalStylistLabel.leftAnchor.constraint(equalTo: self.stylistLabel.rightAnchor, constant: 20).isActive = true
        self.finalStylistLabel.centerYAnchor.constraint(equalTo: self.stylistLabel.centerYAnchor, constant: 0).isActive = true
        self.finalStylistLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.dateLabel.leftAnchor.constraint(equalTo: self.appointmentDetailsContainer.leftAnchor, constant: 27).isActive = true
        self.dateLabel.topAnchor.constraint(equalTo: self.finalStylistLabel.bottomAnchor, constant: 26).isActive = true
        self.dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.dateLabel.widthAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.finalDateLabel.rightAnchor.constraint(equalTo: self.appointmentDetailsContainer.rightAnchor, constant: -30).isActive = true
        self.finalDateLabel.leftAnchor.constraint(equalTo: self.dateLabel.rightAnchor, constant: 20).isActive = true
        self.finalDateLabel.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor, constant: 0).isActive = true
        self.finalDateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.timeLabel.leftAnchor.constraint(equalTo: self.appointmentDetailsContainer.leftAnchor, constant: 27).isActive = true
        self.timeLabel.topAnchor.constraint(equalTo: self.finalDateLabel.bottomAnchor, constant: 26).isActive = true
        self.timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.timeLabel.widthAnchor.constraint(equalToConstant: 55).isActive = true

        self.finalTimeLabel.rightAnchor.constraint(equalTo: self.appointmentDetailsContainer.rightAnchor, constant: -30).isActive = true
        self.finalTimeLabel.leftAnchor.constraint(equalTo: self.timeLabel.rightAnchor, constant: 20).isActive = true
        self.finalTimeLabel.centerYAnchor.constraint(equalTo: self.timeLabel.centerYAnchor, constant: 0).isActive = true
        self.finalTimeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.bookAptButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -27).isActive = true
        self.bookAptButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.bookAptButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.bookAptButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.availableAptCollection.topAnchor.constraint(equalTo: self.selectDogForAptLabel.bottomAnchor, constant: 15).isActive = true
        self.availableAptCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.availableAptCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.availableAptCollection.bottomAnchor.constraint(equalTo: self.bookAptButton.topAnchor, constant: -15).isActive = true

    }
    
    @objc func handleCancelButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
