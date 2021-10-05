//
//  AppointmentTwo.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/22/21.
//

import UIKit
import Foundation

class AppointmentTwo : UIViewController, UIScrollViewDelegate, CustomAlertCallBackProtocol {
    
    lazy var scrollView : UIScrollView = {
        
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = coreBackgroundWhite
        sv.isScrollEnabled = false
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 1.0
        sv.bounces = true
        sv.bouncesZoom = true
        sv.isHidden = false
        sv.delegate = self
        sv.contentMode = .scaleAspectFit
        sv.isUserInteractionEnabled = true
        sv.delaysContentTouches = false
        return sv
        
    }()
    
    lazy var stackView : UIStackView = {
        
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        
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
        hbo.backgroundColor = circleGrey
        return hbo
    }()
    
    let headerBarFour : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = circleGrey
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
        nl.text = "Date & Time"
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
    
    lazy var fourWeeksButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("4 weeks", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 2
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dividerGrey
        cbf.backgroundColor = coreWhiteColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreBlackColor
        cbf.titleLabel?.textAlignment = .center
        cbf.tag = 1
        cbf.layer.borderWidth = 0.5
        cbf.layer.borderColor = coreOrangeColor.cgColor
        
        cbf.layer.shadowColor = coreOrangeColor.cgColor
        cbf.layer.shadowOpacity = 0.35
        cbf.layer.shadowOffset = CGSize(width: 0, height: 0)
        cbf.layer.shadowRadius = 4
        cbf.layer.shouldRasterize = false
        
        
        cbf.addTarget(self, action: #selector(self.handleGroomingFrequency), for: .touchUpInside)
        
        return cbf
    }()
    
    lazy var eightWeeksButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("8 weeks", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 2
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dividerGrey
        cbf.backgroundColor = dividerGrey
        cbf.layer.cornerRadius = 15
        cbf.tintColor = coreBlackColor
        cbf.titleLabel?.textAlignment = .center
        cbf.tag = 2
        cbf.layer.borderWidth = 0.5
        cbf.layer.masksToBounds = false
        cbf.layer.borderColor = UIColor .clear.cgColor
        
        cbf.layer.shadowColor = coreOrangeColor.cgColor
        cbf.layer.shadowOpacity = 0.35
        cbf.layer.shadowOffset = CGSize(width: 0, height: 0)
        cbf.layer.shadowRadius = 0
        cbf.layer.shouldRasterize = false
        
        cbf.addTarget(self, action: #selector(self.handleGroomingFrequency), for: .touchUpInside)
        return cbf
    }()
    
    let groomingFrequency : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Grooming Frequency"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var informationButton : UIButton = {
        
        let dcl = UIButton(type: .system)
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = coreWhiteColor
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = true
        dcl.clipsToBounds = false
        dcl.layer.masksToBounds = false
        dcl.layer.shadowColor = coreBlackColor.cgColor
        dcl.layer.shadowOpacity = 0.05
        dcl.layer.shadowOffset = CGSize(width: 2, height: 3)
        dcl.layer.shadowRadius = 9
        dcl.layer.shouldRasterize = false
        dcl.layer.cornerRadius = 15
        dcl.titleLabel?.textColor = coreBlackColor
        dcl.tintColor = coreBlackColor
        dcl.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        dcl.setTitle(String.fontAwesomeIcon(name: .infoCircle), for: .normal)
        dcl.addTarget(self, action: #selector(self.handleInformationButton), for: .touchUpInside)
        
        return dcl
    }()
    
    let topDescriptionLevel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "This was the grooming frequency you selected when creating your doggy’s profile."
        nl.font = UIFont(name: rubikRegular, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        
        return nl
    }()
    
    let dateBeginLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Date to begin grooming cycle"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        
        return nl
    }()
    
    lazy var selectionContainerOne : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = coreWhiteColor
        co.layer.masksToBounds = true
        co.layer.cornerRadius = 15
        co.tag = 1
        co.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleSelection(sender:))))
        
        return co
    }()
    
    let selectionContainerTwo : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = coreWhiteColor
        co.layer.masksToBounds = true
        co.layer.cornerRadius = 15
        co.tag = 2
        
        return co
    }()
    
    let containerOneCircleView : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = coreWhiteColor
        co.layer.masksToBounds = true
        co.layer.cornerRadius = 15
        co.layer.borderWidth = 4
        co.layer.borderColor = circleGrey.cgColor
        co.layer.cornerRadius = 29/2
        
        return co
    }()
    
    let containerTwoCircleView : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = coreWhiteColor
        co.layer.masksToBounds = true
        co.layer.cornerRadius = 15
        co.layer.borderWidth = 4
        co.layer.borderColor = circleGrey.cgColor
        co.layer.cornerRadius = 29/2
        
        return co
    }()
    
    let containerOneLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Backend date pull: 1"
        nl.font = UIFont(name: rubikMedium, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        
        return nl
    }()
    
    let containerTwoLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Backend date pull: 2"
        nl.font = UIFont(name: rubikMedium, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        
        return nl
    }()
    
    let twoDateLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Why am I only seeing two dates?"
        nl.font = UIFont(name: rubikMedium, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        
        return nl
    }()
    
    let bottomDescriptionLevel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Doggystyle is a recurring grooming service which services on a 4-week cycle."
        nl.font = UIFont(name: rubikRegular, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        
        return nl
    }()
    
    lazy var appointmentTwoContainer : AppointmentTwoContainer = {
        
        let atc = AppointmentTwoContainer()
        atc.appointmentTwo = self
        atc.isHidden = true
        return atc
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.scrollView.keyboardDismissMode = .interactive
        self.addViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func addViews() {
        
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.headerBarOne)
        self.stackView.addArrangedSubview(self.headerBarTwo)
        self.stackView.addArrangedSubview(self.headerBarThree)
        self.stackView.addArrangedSubview(self.headerBarFour)
        
        self.scrollView.addSubview(self.headerContainer)
        self.scrollView.addSubview(self.cancelButton)
        self.scrollView.addSubview(self.xButton)
        self.scrollView.addSubview(self.basicDetailsLabel)
        self.scrollView.addSubview(self.groomingFrequency)
        self.scrollView.addSubview(self.informationButton)
        
        self.scrollView.addSubview(self.fourWeeksButton)
        self.scrollView.addSubview(self.eightWeeksButton)
        self.scrollView.addSubview(self.topDescriptionLevel)
        self.scrollView.addSubview(self.dateBeginLabel)
        
        self.scrollView.addSubview(self.selectionContainerOne)
        self.selectionContainerOne.addSubview(self.containerOneCircleView)
        self.selectionContainerOne.addSubview(self.containerOneLabel)
        
        self.scrollView.addSubview(self.selectionContainerTwo)
        self.selectionContainerTwo.addSubview(self.containerTwoCircleView)
        self.selectionContainerTwo.addSubview(self.containerTwoLabel)
        
        self.scrollView.addSubview(self.twoDateLabel)
        self.scrollView.addSubview(self.bottomDescriptionLevel)
        self.scrollView.addSubview(self.appointmentTwoContainer)
        
        self.view.addSubview(timeCover)
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        let screenHeight = UIScreen.main.bounds.height
        
        switch screenHeight {
        
        //MANUAL CONFIGURATION - REFACTOR FOR UNNIVERSAL FITMENT
        case 926 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.13)
        case 896 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.14)
        case 844 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.27)
        case 812 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.27)
        case 736 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.34)
        case 667 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.47)
        case 568 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.47)
        case 480 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.47)
            
        default : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.5)
            
        }
        
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
        
        self.headerContainer.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 25).isActive = true
        self.headerContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.headerContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.headerContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.cancelButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: -20).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.headerContainer.leftAnchor, constant: 11).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.cancelButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.xButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: -20).isActive = true
        self.xButton.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -11).isActive = true
        self.xButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.xButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.basicDetailsLabel.topAnchor.constraint(equalTo: self.cancelButton.bottomAnchor, constant: 25).isActive = true
        self.basicDetailsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.basicDetailsLabel.sizeToFit()
        
        self.stackView.centerYAnchor.constraint(equalTo: self.basicDetailsLabel.centerYAnchor, constant: 0).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -30).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        self.stackView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.groomingFrequency.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 30).isActive = true
        self.groomingFrequency.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.groomingFrequency.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.groomingFrequency.sizeToFit()
        
        self.informationButton.centerYAnchor.constraint(equalTo: self.groomingFrequency.centerYAnchor, constant: 0).isActive = true
        self.informationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.informationButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.informationButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.fourWeeksButton.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -8).isActive = true
        self.fourWeeksButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.fourWeeksButton.topAnchor.constraint(equalTo: self.groomingFrequency.bottomAnchor, constant: 20).isActive = true
        self.fourWeeksButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.eightWeeksButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 8).isActive = true
        self.eightWeeksButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.eightWeeksButton.topAnchor.constraint(equalTo: self.groomingFrequency.bottomAnchor, constant: 20).isActive = true
        self.eightWeeksButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.topDescriptionLevel.topAnchor.constraint(equalTo: self.fourWeeksButton.bottomAnchor, constant: 20).isActive = true
        self.topDescriptionLevel.leftAnchor.constraint(equalTo: self.fourWeeksButton.leftAnchor, constant: 0).isActive = true
        self.topDescriptionLevel.rightAnchor.constraint(equalTo: self.eightWeeksButton.rightAnchor, constant: 0).isActive = true
        self.topDescriptionLevel.sizeToFit()
        
        self.dateBeginLabel.topAnchor.constraint(equalTo: self.topDescriptionLevel.bottomAnchor, constant: 30).isActive = true
        self.dateBeginLabel.leftAnchor.constraint(equalTo: self.topDescriptionLevel.leftAnchor, constant: 0).isActive = true
        self.dateBeginLabel.rightAnchor.constraint(equalTo: self.topDescriptionLevel.rightAnchor, constant: 0).isActive = true
        self.dateBeginLabel.sizeToFit()
        
        self.selectionContainerOne.topAnchor.constraint(equalTo: self.dateBeginLabel.bottomAnchor, constant: 20).isActive = true
        self.selectionContainerOne.leftAnchor.constraint(equalTo: self.dateBeginLabel.leftAnchor, constant: 0).isActive = true
        self.selectionContainerOne.rightAnchor.constraint(equalTo: self.dateBeginLabel.rightAnchor, constant: 0).isActive = true
        self.selectionContainerOne.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        self.selectionContainerTwo.topAnchor.constraint(equalTo: self.selectionContainerOne.bottomAnchor, constant: 20).isActive = true
        self.selectionContainerTwo.leftAnchor.constraint(equalTo: self.dateBeginLabel.leftAnchor, constant: 0).isActive = true
        self.selectionContainerTwo.rightAnchor.constraint(equalTo: self.dateBeginLabel.rightAnchor, constant: 0).isActive = true
        self.selectionContainerTwo.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        self.containerOneCircleView.centerYAnchor.constraint(equalTo: self.selectionContainerOne.centerYAnchor, constant: 0).isActive = true
        self.containerOneCircleView.leftAnchor.constraint(equalTo: self.selectionContainerOne.leftAnchor, constant: 17).isActive = true
        self.containerOneCircleView.heightAnchor.constraint(equalToConstant: 29).isActive = true
        self.containerOneCircleView.widthAnchor.constraint(equalToConstant: 29).isActive = true
        
        self.containerTwoCircleView.centerYAnchor.constraint(equalTo: self.selectionContainerTwo.centerYAnchor, constant: 0).isActive = true
        self.containerTwoCircleView.leftAnchor.constraint(equalTo: self.selectionContainerTwo.leftAnchor, constant: 17).isActive = true
        self.containerTwoCircleView.heightAnchor.constraint(equalToConstant: 29).isActive = true
        self.containerTwoCircleView.widthAnchor.constraint(equalToConstant: 29).isActive = true
        
        self.containerOneLabel.leftAnchor.constraint(equalTo: self.containerOneCircleView.rightAnchor, constant: 10).isActive = true
        self.containerOneLabel.rightAnchor.constraint(equalTo: self.selectionContainerOne.rightAnchor, constant: -30).isActive = true
        self.containerOneLabel.topAnchor.constraint(equalTo: self.selectionContainerOne.topAnchor, constant: 0).isActive = true
        self.containerOneLabel.bottomAnchor.constraint(equalTo: self.selectionContainerOne.bottomAnchor, constant: 0).isActive = true
        
        self.containerTwoLabel.leftAnchor.constraint(equalTo: self.containerTwoCircleView.rightAnchor, constant: 10).isActive = true
        self.containerTwoLabel.rightAnchor.constraint(equalTo: self.selectionContainerTwo.rightAnchor, constant: -30).isActive = true
        self.containerTwoLabel.topAnchor.constraint(equalTo: self.selectionContainerTwo.topAnchor, constant: 0).isActive = true
        self.containerTwoLabel.bottomAnchor.constraint(equalTo: self.selectionContainerTwo.bottomAnchor, constant: 0).isActive = true
        
        self.twoDateLabel.topAnchor.constraint(equalTo: self.selectionContainerTwo.bottomAnchor, constant: 30).isActive = true
        self.twoDateLabel.leftAnchor.constraint(equalTo: self.selectionContainerTwo.leftAnchor, constant: 0).isActive = true
        self.twoDateLabel.rightAnchor.constraint(equalTo: self.selectionContainerTwo.rightAnchor, constant: 0).isActive = true
        self.twoDateLabel.sizeToFit()
        
        self.bottomDescriptionLevel.topAnchor.constraint(equalTo: self.twoDateLabel.bottomAnchor, constant: 10).isActive = true
        self.bottomDescriptionLevel.leftAnchor.constraint(equalTo: self.fourWeeksButton.leftAnchor, constant: 0).isActive = true
        self.bottomDescriptionLevel.rightAnchor.constraint(equalTo: self.eightWeeksButton.rightAnchor, constant: 0).isActive = true
        self.bottomDescriptionLevel.sizeToFit()
        
        self.appointmentTwoContainer.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 30).isActive = true
        self.appointmentTwoContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.appointmentTwoContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.appointmentTwoContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
    @objc func handleGroomingFrequency(sender : UIButton) {
        
        UIDevice.vibrateLight()
        
        switch sender.tag {
        
        case 1:
            
            self.fourWeeksButton.backgroundColor = coreWhiteColor
            self.fourWeeksButton.layer.borderColor = coreOrangeColor.cgColor
            self.fourWeeksButton.layer.shadowRadius = 4
            
            self.eightWeeksButton.backgroundColor = dividerGrey
            self.eightWeeksButton.layer.borderColor = UIColor .clear.cgColor
            self.eightWeeksButton.layer.shadowRadius = 0
            
        case 2:
            
            self.fourWeeksButton.backgroundColor = dividerGrey
            self.fourWeeksButton.layer.shadowRadius = 0
            self.fourWeeksButton.layer.borderColor = UIColor .clear.cgColor
            
            self.eightWeeksButton.backgroundColor = coreWhiteColor
            self.eightWeeksButton.layer.borderColor = coreOrangeColor.cgColor
            self.eightWeeksButton.layer.shadowRadius = 4
            
        default: print("Only 2 buttons here")
            
        }
    }
    
    @objc func handleInformationButton() {
        
        self.handleCustomPopUpAlert(title: "FREQUENCY", message: "grooming frequency description goes here", passedButtons: [Statics.OK])
    }
    
    
    @objc func handleSelection(sender : UITapGestureRecognizer) {
        
        self.appointmentTwoContainer.isHidden = false
        
    }
    
    @objc func handleCustomPopUpAlert(title : String, message : String, passedButtons: [String]) {
        
        let alert = AlertController()
        alert.passedTitle = title
        alert.passedMmessage = message
        alert.passedButtonSelections = passedButtons
        alert.customAlertCallBackProtocol = self
        
        alert.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    func onSelectionPassBack(buttonTitleForSwitchStatement type: String) {
        
        switch type {
        
        case Statics.OK: print(Statics.OK)
            
        default: print("Should not hit")
            
        }
    }
    
    @objc func handleCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNextButton() {
        
        UIDevice.vibrateLight()
        
        let appointmentThree = AppointmentThree()
        appointmentThree.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(appointmentThree, animated: true)
        
    }
}
