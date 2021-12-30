//
//  NewDogTwo.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/28/21.
//

import Foundation
import UIKit

class NewDogTwo : UIViewController, UITextFieldDelegate, UIScrollViewDelegate, CustomAlertCallBackProtocol {
    
    lazy var stackView : UIStackView = {
        
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        
        return sv
    }()
    
    var headerContainer : UIView = {
        
        let hc = UIView()
        hc.translatesAutoresizingMaskIntoConstraints = false
        hc.backgroundColor = .clear
        hc.isUserInteractionEnabled = false
        
        return hc
    }()
    
    lazy var cancelButton : UIButton = {
        
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
    
    let basicDetailsLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = ""
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var nextButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Next", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.addTarget(self, action: #selector(self.handleNextButton), for: .touchUpInside)
        
        return cbf
        
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
    
    let sizeLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Size"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
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
    
    lazy var weightSmallButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Small\n<15 lbs", for: UIControl.State.normal)
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
        
        cbf.layer.borderWidth = 1
        cbf.layer.borderColor = coreOrangeColor.cgColor
        cbf.layer.shadowColor = coreOrangeColor.cgColor
        cbf.layer.shadowOpacity = 0.35
        cbf.layer.shadowOffset = CGSize(width: 0, height: 0)
        cbf.layer.shadowRadius = 4
        cbf.layer.shouldRasterize = false
        
        cbf.addTarget(self, action: #selector(self.handleSizeSelection), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var weightMediumButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Medium\n15 - 25 lbs", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 2
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dividerGrey
        cbf.backgroundColor = dividerGrey
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreBlackColor
        cbf.titleLabel?.textAlignment = .center
        cbf.tag = 2
        
        cbf.layer.borderWidth = 1
        cbf.layer.borderColor = UIColor .clear.cgColor
        cbf.layer.shadowColor = coreOrangeColor.cgColor
        cbf.layer.shadowOpacity = 0.35
        cbf.layer.shadowOffset = CGSize(width: 0, height: 0)
        cbf.layer.shadowRadius = 0
        cbf.layer.shouldRasterize = false
        
        cbf.addTarget(self, action: #selector(self.handleSizeSelection), for: .touchUpInside)
        
        
        return cbf
        
    }()
    
    lazy var weightLargeButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Large\n26 - 35 lbs", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 2
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dividerGrey
        cbf.backgroundColor = dividerGrey
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreBlackColor
        cbf.titleLabel?.textAlignment = .center
        cbf.tag = 3
        cbf.layer.borderWidth = 1
        cbf.layer.borderColor = UIColor .clear.cgColor
        
        cbf.layer.shadowColor = coreOrangeColor.cgColor
        cbf.layer.shadowOpacity = 0.35
        cbf.layer.shadowOffset = CGSize(width: 0, height: 0)
        cbf.layer.shadowRadius = 0
        cbf.layer.shouldRasterize = false
        
        cbf.addTarget(self, action: #selector(self.handleSizeSelection), for: .touchUpInside)
        
        
        return cbf
        
    }()
    
    lazy var weightExtraLargeButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("X-Large\n> 35 lbs", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 2
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dividerGrey
        cbf.backgroundColor = dividerGrey
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = false
        cbf.tintColor = coreBlackColor
        cbf.titleLabel?.textAlignment = .center
        cbf.tag = 4
        cbf.layer.borderWidth = 1
        cbf.layer.borderColor = UIColor .clear.cgColor
        
        cbf.layer.shadowColor = coreOrangeColor.cgColor
        cbf.layer.shadowOpacity = 0.35
        cbf.layer.shadowOffset = CGSize(width: 0, height: 0)
        cbf.layer.shadowRadius = 0
        cbf.layer.shouldRasterize = false
        
        cbf.addTarget(self, action: #selector(self.handleSizeSelection), for: .touchUpInside)
        
        return cbf
        
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
        cbf.layer.borderWidth = 1
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
        cbf.layer.borderWidth = 1
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let dogsName = globalNewDogBuilder.dogBuilderName ?? "Dog"
        self.basicDetailsLabel.text = "\(dogsName)'s basics"
        
        globalNewDogBuilder.dogBuilderSize = .small
        globalNewDogBuilder.dogBuilderGroomingFrequency = .fourWeeks
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.headerBarOne)
        self.stackView.addArrangedSubview(self.headerBarTwo)
        self.stackView.addArrangedSubview(self.headerBarThree)
        self.stackView.addArrangedSubview(self.headerBarFour)
        
        self.view.addSubview(self.headerContainer)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.basicDetailsLabel)
        self.view.addSubview(self.sizeLabel)
        self.view.addSubview(self.nextButton)
        
        self.view.addSubview(self.weightSmallButton)
        self.view.addSubview(self.weightMediumButton)
        self.view.addSubview(self.weightLargeButton)
        self.view.addSubview(self.weightExtraLargeButton)
        
        self.view.addSubview(self.groomingFrequency)
        self.view.addSubview(self.informationButton)
        self.view.addSubview(self.fourWeeksButton)
        self.view.addSubview(self.eightWeeksButton)
        
        self.view.addSubview(timeCover)
        
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
        
        self.headerContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.headerContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.headerContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.headerContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.cancelButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: 0).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.headerContainer.leftAnchor, constant: 11).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.cancelButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.basicDetailsLabel.topAnchor.constraint(equalTo: self.cancelButton.bottomAnchor, constant: 25).isActive = true
        self.basicDetailsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.basicDetailsLabel.sizeToFit()
        
        self.stackView.centerYAnchor.constraint(equalTo: self.basicDetailsLabel.centerYAnchor, constant: 0).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -30).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        self.stackView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.timeCover.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.timeCover.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.timeCover.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.timeCover.heightAnchor.constraint(equalToConstant: globalStatusBarHeight).isActive = true
        
        self.sizeLabel.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 30).isActive = true
        self.sizeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.sizeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.sizeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.weightSmallButton.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -8).isActive = true
        self.weightSmallButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.weightSmallButton.topAnchor.constraint(equalTo: self.sizeLabel.bottomAnchor, constant: 10).isActive = true
        self.weightSmallButton.heightAnchor.constraint(equalToConstant: 92).isActive = true
        
        self.weightMediumButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 8).isActive = true
        self.weightMediumButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.weightMediumButton.topAnchor.constraint(equalTo: self.sizeLabel.bottomAnchor, constant: 10).isActive = true
        self.weightMediumButton.heightAnchor.constraint(equalToConstant: 92).isActive = true
        
        self.weightLargeButton.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -8).isActive = true
        self.weightLargeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.weightLargeButton.topAnchor.constraint(equalTo: self.weightMediumButton.bottomAnchor, constant: 16).isActive = true
        self.weightLargeButton.heightAnchor.constraint(equalToConstant: 92).isActive = true
        
        self.weightExtraLargeButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 8).isActive = true
        self.weightExtraLargeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.weightExtraLargeButton.topAnchor.constraint(equalTo: self.weightMediumButton.bottomAnchor, constant: 16).isActive = true
        self.weightExtraLargeButton.heightAnchor.constraint(equalToConstant: 92).isActive = true
        
        self.groomingFrequency.topAnchor.constraint(equalTo: self.weightExtraLargeButton.bottomAnchor, constant: 30).isActive = true
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
        self.fourWeeksButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.eightWeeksButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 8).isActive = true
        self.eightWeeksButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.eightWeeksButton.topAnchor.constraint(equalTo: self.groomingFrequency.bottomAnchor, constant: 20).isActive = true
        self.eightWeeksButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
    }
    
    @objc func handleGroomingFrequency(sender : UIButton) {
        
        UIDevice.vibrateLight()
        
        switch sender.tag {
        
        case 1:
            
            globalNewDogBuilder.dogBuilderGroomingFrequency = .fourWeeks
            
            self.fourWeeksButton.backgroundColor = coreWhiteColor
            self.fourWeeksButton.layer.borderColor = coreOrangeColor.cgColor
            self.fourWeeksButton.layer.shadowRadius = 4
            
            self.eightWeeksButton.backgroundColor = dividerGrey
            self.eightWeeksButton.layer.borderColor = UIColor .clear.cgColor
            self.eightWeeksButton.layer.shadowRadius = 0
            
        case 2:
            
            globalNewDogBuilder.dogBuilderGroomingFrequency = .eightWeeks
            
            self.fourWeeksButton.backgroundColor = dividerGrey
            self.fourWeeksButton.layer.shadowRadius = 0
            self.fourWeeksButton.layer.borderColor = UIColor .clear.cgColor
            
            self.eightWeeksButton.backgroundColor = coreWhiteColor
            self.eightWeeksButton.layer.borderColor = coreOrangeColor.cgColor
            self.eightWeeksButton.layer.shadowRadius = 4
            
        default: print("Only 2 buttons here")
            
        }
    }
    
    @objc func handleSizeSelection(sender : UIButton) {
        
        UIDevice.vibrateLight()
        
        switch sender.tag {
        
        case 1:
            
            globalNewDogBuilder.dogBuilderSize = .small
            
            self.weightSmallButton.backgroundColor = coreWhiteColor
            self.weightSmallButton.layer.borderColor = coreOrangeColor.cgColor
            self.weightSmallButton.layer.shadowRadius = 4
            
            self.weightMediumButton.backgroundColor = dividerGrey
            self.weightMediumButton.layer.borderColor = UIColor .clear.cgColor
            self.weightMediumButton.layer.shadowRadius = 0
            
            self.weightLargeButton.backgroundColor = dividerGrey
            self.weightLargeButton.layer.borderColor = UIColor .clear.cgColor
            self.weightLargeButton.layer.shadowRadius = 0
            
            self.weightExtraLargeButton.backgroundColor = dividerGrey
            self.weightExtraLargeButton.layer.borderColor = UIColor .clear.cgColor
            self.weightExtraLargeButton.layer.shadowRadius = 0
            
        case 2:
            
            globalNewDogBuilder.dogBuilderSize = .medium
            
            self.weightSmallButton.backgroundColor = dividerGrey
            self.weightSmallButton.layer.borderColor = UIColor .clear.cgColor
            self.weightSmallButton.layer.shadowRadius = 0
            
            self.weightMediumButton.backgroundColor = coreWhiteColor
            self.weightMediumButton.layer.borderColor = coreOrangeColor.cgColor
            self.weightMediumButton.layer.shadowRadius = 4
            
            self.weightLargeButton.backgroundColor = dividerGrey
            self.weightLargeButton.layer.borderColor = UIColor .clear.cgColor
            self.weightLargeButton.layer.shadowRadius = 0
            
            self.weightExtraLargeButton.backgroundColor = dividerGrey
            self.weightExtraLargeButton.layer.borderColor = UIColor .clear.cgColor
            self.weightExtraLargeButton.layer.shadowRadius = 0
            
        case 3:
            
            globalNewDogBuilder.dogBuilderSize = .large
            
            self.weightSmallButton.backgroundColor = dividerGrey
            self.weightSmallButton.layer.borderColor = UIColor .clear.cgColor
            self.weightSmallButton.layer.shadowRadius = 0
            
            self.weightMediumButton.backgroundColor = dividerGrey
            self.weightMediumButton.layer.borderColor = UIColor .clear.cgColor
            self.weightMediumButton.layer.shadowRadius = 0
            
            self.weightLargeButton.backgroundColor = coreWhiteColor
            self.weightLargeButton.layer.borderColor = coreOrangeColor.cgColor
            self.weightLargeButton.layer.shadowRadius = 4
            
            self.weightExtraLargeButton.backgroundColor = dividerGrey
            self.weightExtraLargeButton.layer.borderColor = UIColor .clear.cgColor
            self.weightExtraLargeButton.layer.shadowRadius = 0
            
        case 4:
            
            globalNewDogBuilder.dogBuilderSize = .xlarge
            
            self.weightSmallButton.backgroundColor = dividerGrey
            self.weightSmallButton.layer.borderColor = UIColor .clear.cgColor
            self.weightSmallButton.layer.shadowRadius = 0
            
            self.weightMediumButton.backgroundColor = dividerGrey
            self.weightMediumButton.layer.borderColor = UIColor .clear.cgColor
            self.weightMediumButton.layer.shadowRadius = 0
            
            self.weightLargeButton.backgroundColor = dividerGrey
            self.weightLargeButton.layer.borderColor = UIColor .clear.cgColor
            self.weightLargeButton.layer.shadowRadius = 0
            
            self.weightExtraLargeButton.backgroundColor = coreWhiteColor
            self.weightExtraLargeButton.layer.borderColor = coreOrangeColor.cgColor
            self.weightExtraLargeButton.layer.shadowRadius = 4
            
        default: print("only 4 buttons, this will never hit")
            
        }
    }
    
    @objc func handleInformationButton() {
        
        self.handleCustomPopUpAlert(title: "FREQUENCY", message: "Please select how often you would like to have your pup groomed. You can choose every 4 weeks or every 8 weeks.", passedButtons: [Statics.OK])
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
    
    @objc func handleBackButton() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNextButton() {
        
        UIDevice.vibrateLight()
        
        let newDogTwo = NewDogThree()
        newDogTwo.modalPresentationStyle = .fullScreen
        newDogTwo.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(newDogTwo, animated: true)
        
    }
}
