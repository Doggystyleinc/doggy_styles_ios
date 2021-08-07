//
//  NewDogFour.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/6/21.
//

import UIKit
import Foundation

class NewDogFour : UIViewController, UIScrollViewDelegate {
    
    lazy var scrollView : UIScrollView = {
        
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = coreBackgroundWhite
        sv.isScrollEnabled = true
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
        nl.text = "<name> details"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
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
    
    let bottomTimeCover : UIView = {
        
        let tc = UIView()
        tc.translatesAutoresizingMaskIntoConstraints = false
        tc.backgroundColor = coreBackgroundWhite.withAlphaComponent(0.5)
        
        return tc
    }()
   
    var containerOne : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = .clear
        
       return co
    }()
    
    var containerTwo : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = .clear
        
       return co
    }()
    
    var containerThree : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = .clear
        
       return co
    }()
    
    let medicalConditionsLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Medical Conditions?"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    lazy var medicalNoButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("No", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 2
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dividerGrey
        cbf.backgroundColor = dividerGrey.withAlphaComponent(0.2)
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = dividerGrey
        cbf.titleLabel?.textAlignment = .center
        
        return cbf
        
    }()
    
    lazy var medicalYesButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Yes", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 2
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dividerGrey
        cbf.backgroundColor = dividerGrey.withAlphaComponent(0.2)
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = dividerGrey
        cbf.titleLabel?.textAlignment = .center
        
        return cbf
        
    }()
    
    let behaviorConcernsLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Any behavioural concerns?"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    lazy var behaviorNoButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("No", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 2
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dividerGrey
        cbf.backgroundColor = dividerGrey.withAlphaComponent(0.2)
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = dividerGrey
        cbf.titleLabel?.textAlignment = .center
        
        return cbf
        
    }()
    
    lazy var behaviorYesButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Yes", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 2
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dividerGrey
        cbf.backgroundColor = dividerGrey.withAlphaComponent(0.2)
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = dividerGrey
        cbf.titleLabel?.textAlignment = .center
        
        return cbf
        
    }()
    
    let vaccineLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Vaccine card?"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    lazy var vaccineUploadButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Tap to upload", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 2
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dividerGrey
        cbf.backgroundColor = dividerGrey.withAlphaComponent(0.2)
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = dividerGrey
        cbf.titleLabel?.textAlignment = .center
        
        return cbf
        
    }()
    
    lazy var expiryDateButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Expiry (MM/YY)", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsSubHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 2
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dividerGrey
        cbf.backgroundColor = dividerGrey.withAlphaComponent(0.2)
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = dividerGrey
        cbf.titleLabel?.textAlignment = .left
        
        return cbf
        
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
    }
    
    func addViews() {
        
        self.view.addSubview(timeCover)
        self.view.addSubview(bottomTimeCover)
        
        self.view.addSubview(scrollView)
        self.view.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.headerBarOne)
        self.stackView.addArrangedSubview(self.headerBarTwo)
        self.stackView.addArrangedSubview(self.headerBarThree)
        self.stackView.addArrangedSubview(self.headerBarFour)
        
        self.scrollView.addSubview(self.headerContainer)
        self.scrollView.addSubview(self.cancelButton)
        self.scrollView.addSubview(self.basicDetailsLabel)

        self.scrollView.addSubview(containerOne)
        self.scrollView.addSubview(containerTwo)
        self.scrollView.addSubview(containerThree)

        self.containerOne.addSubview(self.medicalConditionsLabel)
        self.containerOne.addSubview(self.medicalNoButton)
        self.containerOne.addSubview(self.medicalYesButton)
        
        self.containerTwo.addSubview(self.behaviorConcernsLabel)
        self.containerTwo.addSubview(self.behaviorNoButton)
        self.containerTwo.addSubview(self.behaviorYesButton)
        
        self.containerThree.addSubview(self.vaccineLabel)
        self.containerThree.addSubview(self.vaccineUploadButton)
        self.containerThree.addSubview(self.expiryDateButton)
        self.containerThree.addSubview(self.nextButton)

        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.5)
        
        let screenHeight = UIScreen.main.bounds.height
        print("screen height is: \(screenHeight)")
        
        switch screenHeight {
        
        //MANUAL CONFIGURATION - REFACTOR FOR UNNIVERSAL FITMENT
        case 926 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.13)
        case 896 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.14)
        case 844 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.01)
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
        
        self.headerContainer.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
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
        
        self.timeCover.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.timeCover.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.timeCover.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.timeCover.heightAnchor.constraint(equalToConstant: globalStatusBarHeight).isActive = true
        
        self.bottomTimeCover.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.bottomTimeCover.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.bottomTimeCover.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.bottomTimeCover.heightAnchor.constraint(equalToConstant: globalStatusBarHeight).isActive = true
        
        self.containerOne.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 18).isActive = true
        self.containerOne.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.containerOne.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.containerOne.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 6).isActive = true
        
        self.containerTwo.topAnchor.constraint(equalTo: self.containerOne.bottomAnchor, constant: 0).isActive = true
        self.containerTwo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.containerTwo.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.containerTwo.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 6).isActive = true
        
        self.containerThree.topAnchor.constraint(equalTo: self.containerTwo.bottomAnchor, constant: 0).isActive = true
        self.containerThree.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.containerThree.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.containerThree.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.medicalConditionsLabel.topAnchor.constraint(equalTo: self.containerOne.topAnchor, constant: 10).isActive = true
        self.medicalConditionsLabel.leftAnchor.constraint(equalTo: self.containerOne.leftAnchor, constant: 30).isActive = true
        self.medicalConditionsLabel.rightAnchor.constraint(equalTo: self.containerOne.rightAnchor, constant: -30).isActive = true
        self.medicalConditionsLabel.sizeToFit()

        self.medicalNoButton.leftAnchor.constraint(equalTo: self.containerOne.leftAnchor, constant: 30).isActive = true
        self.medicalNoButton.topAnchor.constraint(equalTo: self.medicalConditionsLabel.bottomAnchor, constant: 20).isActive = true
        self.medicalNoButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.medicalNoButton.rightAnchor.constraint(equalTo: self.containerOne.centerXAnchor, constant: -8).isActive = true
        
        self.medicalYesButton.rightAnchor.constraint(equalTo: self.containerOne.rightAnchor, constant: -30).isActive = true
        self.medicalYesButton.topAnchor.constraint(equalTo: self.medicalConditionsLabel.bottomAnchor, constant: 20).isActive = true
        self.medicalYesButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.medicalYesButton.leftAnchor.constraint(equalTo: self.containerOne.centerXAnchor, constant: 8).isActive = true
        
        self.behaviorConcernsLabel.topAnchor.constraint(equalTo: self.containerTwo.topAnchor, constant: 10).isActive = true
        self.behaviorConcernsLabel.leftAnchor.constraint(equalTo: self.containerTwo.leftAnchor, constant: 30).isActive = true
        self.behaviorConcernsLabel.rightAnchor.constraint(equalTo: self.containerTwo.rightAnchor, constant: -30).isActive = true
        self.behaviorConcernsLabel.sizeToFit()

        self.behaviorNoButton.leftAnchor.constraint(equalTo: self.containerTwo.leftAnchor, constant: 30).isActive = true
        self.behaviorNoButton.topAnchor.constraint(equalTo: self.behaviorConcernsLabel.bottomAnchor, constant: 20).isActive = true
        self.behaviorNoButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.behaviorNoButton.rightAnchor.constraint(equalTo: self.containerTwo.centerXAnchor, constant: -8).isActive = true
        
        self.behaviorYesButton.rightAnchor.constraint(equalTo: self.containerTwo.rightAnchor, constant: -30).isActive = true
        self.behaviorYesButton.topAnchor.constraint(equalTo: self.behaviorConcernsLabel.bottomAnchor, constant: 20).isActive = true
        self.behaviorYesButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.behaviorYesButton.leftAnchor.constraint(equalTo: self.containerTwo.centerXAnchor, constant: 8).isActive = true
        
        self.vaccineLabel.topAnchor.constraint(equalTo: self.containerThree.topAnchor, constant: 10).isActive = true
        self.vaccineLabel.leftAnchor.constraint(equalTo: self.containerThree.leftAnchor, constant: 30).isActive = true
        self.vaccineLabel.rightAnchor.constraint(equalTo: self.containerThree.rightAnchor, constant: -30).isActive = true
        self.vaccineLabel.sizeToFit()
        
        self.vaccineUploadButton.leftAnchor.constraint(equalTo: self.containerThree.leftAnchor, constant: 30).isActive = true
        self.vaccineUploadButton.topAnchor.constraint(equalTo: self.vaccineLabel.bottomAnchor, constant: 20).isActive = true
        self.vaccineUploadButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.vaccineUploadButton.rightAnchor.constraint(equalTo: self.containerThree.rightAnchor, constant: -30).isActive = true
        
        self.expiryDateButton.leftAnchor.constraint(equalTo: self.containerThree.leftAnchor, constant: 30).isActive = true
        self.expiryDateButton.topAnchor.constraint(equalTo: self.vaccineUploadButton.bottomAnchor, constant: 20).isActive = true
        self.expiryDateButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.expiryDateButton.rightAnchor.constraint(equalTo: self.containerThree.rightAnchor, constant: -30).isActive = true
        
        self.nextButton.bottomAnchor.constraint(equalTo: self.containerThree.bottomAnchor, constant: -20).isActive = true
        self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNextButton() {
        
        let newDogFive = NewDogFive()
        newDogFive.modalPresentationStyle = .fullScreen
        newDogFive.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(newDogFive, animated: true)
        
    }
}
