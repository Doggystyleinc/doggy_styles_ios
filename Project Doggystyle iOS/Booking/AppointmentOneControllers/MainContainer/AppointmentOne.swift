//
//  AppointmentOne.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/19/21.
//

import Foundation
import UIKit

class AppointmentOne : UIViewController,  UITextFieldDelegate, UIScrollViewDelegate {
    
    enum StateSelection {
        case FullPackage
        case CustomPackage
    }
    
    var currentState = StateSelection.FullPackage,
        doggyProfileDataSource = [DoggyProfileDataSource](),
        selectedProfileDataSource = [DoggyProfileDataSource](),
        canSelectMainPackage : Bool = false,
        isAllDogsTheSameSize : Bool = true,
        sameDogWeightSelectSize : String?,
        mainContainerConstraint : NSLayoutConstraint?
    
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
        hbo.backgroundColor = circleGrey
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
        nl.text = "Select Doggy(ies)"
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
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
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
    
    lazy var petAppointmentCollection : PetAppointmentsCollection = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let rpc = PetAppointmentsCollection(frame: .zero, collectionViewLayout: layout)
        rpc.appointmentOne = self
        
        return rpc
    }()
    
    lazy var selectServicesCollection : SelectServicesCollection = {
        
        let rpc = SelectServicesCollection(frame: .zero, style: .plain)
        rpc.appointmentOne = self
        
        return rpc
    }()
    
    lazy var servicesDropDownCollection : ServicesDropDownCollection = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let rpc = ServicesDropDownCollection(frame: .zero, collectionViewLayout: layout)
        rpc.appointmentOne = self
        rpc.isHidden = true
        
        return rpc
    }()
    
    lazy var customServicesDropDownCollection : CustomServicesDropDownCollection = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let rpc = CustomServicesDropDownCollection(frame: .zero, collectionViewLayout: layout)
        rpc.appointmentOne = self
        rpc.isHidden = true
        
        return rpc
    }()
    
    let selectServicesLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Select Service"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let addOnsLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Add Ons"
        hl.font = UIFont(name: dsHeaderFont, size: 24)
        hl.textColor = coreBlackColor
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.isUserInteractionEnabled = false
        hl.isHidden = true
        
        return hl
    }()
    
    lazy var mainContainerFP : FullPackageContainer = {
        
        let layout = UICollectionViewFlowLayout()
        let mcfp = FullPackageContainer(frame: .zero, collectionViewLayout: layout)
        mcfp.appointmentOne = self
        mcfp.isHidden = true
        
        return mcfp
    }()
    
    lazy var mainContainerCP : UIButton = {
        
        let cv = UIButton(type : .system)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = coreWhiteColor
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        cv.layer.shadowColor = coreOrangeColor.cgColor
        cv.layer.shadowOpacity = 0.4
        cv.layer.shadowOffset = CGSize(width: 0, height: 0)
        cv.layer.shadowRadius = 4
        cv.layer.shouldRasterize = false
        cv.layer.cornerRadius = 15
        cv.layer.borderColor = coreOrangeColor.cgColor
        cv.layer.borderWidth = 0.5
        cv.isHidden = true
        cv.addTarget(self, action: #selector(self.handleMainContainerTaps), for: .touchUpInside)
        
        return cv
        
    }()
    
    let iconImageViewCP : UIButton = {
        
        let iv = UIButton(type: .system)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = coreOrangeColor
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 20
        iv.isUserInteractionEnabled = false
        iv.tintColor = coreWhiteColor
        iv.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
        iv.setTitle(String.fontAwesomeIcon(name: .bath), for: .normal)
        
        return iv
    }()
    
    let headerLabelCP : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Custom Package"
        hl.font = UIFont(name: rubikMedium, size: 18)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.isUserInteractionEnabled = false
        
        return hl
    }()
    
    let costLabelCP : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "-"
        hl.font = UIFont(name: rubikRegular, size: 16)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.isUserInteractionEnabled = false
        
        return hl
    }()
    
    lazy var nextButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Next", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.layer.cornerRadius = 12
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.backgroundColor = coreOrangeColor
        cbf.isHidden = true
        cbf.addTarget(self, action: #selector(self.handleNextButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        
        self.addViews()
        self.callPetsCollection()
        self.scrollView.keyboardDismissMode = .interactive
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func addViews() {
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
        self.scrollView.addSubview(self.petAppointmentCollection)
        
        self.stackView.addArrangedSubview(self.headerBarOne)
        self.stackView.addArrangedSubview(self.headerBarTwo)
        self.stackView.addArrangedSubview(self.headerBarThree)
        self.stackView.addArrangedSubview(self.headerBarFour)
        
        self.scrollView.addSubview(self.headerContainer)
        self.scrollView.addSubview(self.cancelButton)
        self.scrollView.addSubview(self.xButton)
        self.scrollView.addSubview(self.basicDetailsLabel)
        self.scrollView.addSubview(self.selectServicesLabel)
        self.scrollView.addSubview(self.selectServicesCollection)
        
        self.view.addSubview(timeCover)
        
        //MARK: - FULL PACKAGE
        self.scrollView.addSubview(self.mainContainerFP)
        
        //MARK: - CUSTOM PACKAGE
        self.scrollView.addSubview(self.mainContainerCP)
        self.mainContainerCP.addSubview(self.iconImageViewCP)
        self.mainContainerCP.addSubview(self.costLabelCP)
        self.mainContainerCP.addSubview(self.headerLabelCP)
        
        self.scrollView.addSubview(addOnsLabel)
        self.scrollView.addSubview(servicesDropDownCollection)
        self.scrollView.addSubview(customServicesDropDownCollection)
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        self.view.addSubview(self.nextButton)
        
        let screenHeight = UIScreen.main.bounds.height
        
        switch screenHeight {
        
        //MARK: - MANUAL CONFIGURATION - REFACTOR FOR UNNIVERSAL FITMENT
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
        
        self.petAppointmentCollection.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 32).isActive = true
        self.petAppointmentCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.petAppointmentCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.petAppointmentCollection.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.selectServicesLabel.topAnchor.constraint(equalTo: self.petAppointmentCollection.bottomAnchor, constant: 30).isActive = true
        self.selectServicesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.selectServicesLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.selectServicesLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        self.selectServicesCollection.topAnchor.constraint(equalTo: self.selectServicesLabel.bottomAnchor, constant: 25).isActive = true
        self.selectServicesCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.selectServicesCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.selectServicesCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.mainContainerFP.topAnchor.constraint(equalTo: self.selectServicesLabel.bottomAnchor, constant: 16).isActive = true
        self.mainContainerFP.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.mainContainerFP.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.mainContainerConstraint = self.mainContainerFP.heightAnchor.constraint(equalToConstant: 80)
        self.mainContainerConstraint?.isActive = true
        
        self.mainContainerCP.topAnchor.constraint(equalTo: self.selectServicesLabel.bottomAnchor, constant: 30).isActive = true
        self.mainContainerCP.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.mainContainerCP.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.mainContainerCP.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.iconImageViewCP.leftAnchor.constraint(equalTo: self.mainContainerCP.leftAnchor, constant: 25).isActive = true
        self.iconImageViewCP.topAnchor.constraint(equalTo: self.mainContainerCP.topAnchor, constant: 20).isActive = true
        self.iconImageViewCP.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.iconImageViewCP.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.costLabelCP.rightAnchor.constraint(equalTo: self.mainContainerCP.rightAnchor, constant: -25).isActive = true
        self.costLabelCP.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.costLabelCP.centerYAnchor.constraint(equalTo: self.iconImageViewCP.centerYAnchor).isActive = true
        self.costLabelCP.bottomAnchor.constraint(equalTo: self.mainContainerFP.bottomAnchor, constant: 0).isActive = true
        
        self.headerLabelCP.leftAnchor.constraint(equalTo: self.iconImageViewCP.rightAnchor, constant: 10).isActive = true
        self.headerLabelCP.rightAnchor.constraint(equalTo: self.costLabelCP.leftAnchor, constant: -10).isActive = true
        self.headerLabelCP.centerYAnchor.constraint(equalTo: self.iconImageViewCP.centerYAnchor).isActive = true
        self.headerLabelCP.bottomAnchor.constraint(equalTo: self.mainContainerCP.bottomAnchor).isActive = true
        
        self.addOnsLabel.topAnchor.constraint(equalTo: self.mainContainerFP.bottomAnchor, constant: 30).isActive = true
        self.addOnsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.addOnsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.addOnsLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        self.servicesDropDownCollection.topAnchor.constraint(equalTo: self.addOnsLabel.bottomAnchor, constant: 20).isActive = true
        self.servicesDropDownCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.servicesDropDownCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.servicesDropDownCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.customServicesDropDownCollection.topAnchor.constraint(equalTo: self.addOnsLabel.bottomAnchor, constant: 20).isActive = true
        self.customServicesDropDownCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.customServicesDropDownCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.customServicesDropDownCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -39).isActive = true
        self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    func shouldExpandMainContainerFP(shouldExpand : Bool) {
        
        if self.isAllDogsTheSameSize == true {
            
            UIView.animate(withDuration: 0.25) {
                
                self.mainContainerConstraint?.constant = 80
                self.view.layoutIfNeeded()
                self.view.superview?.layoutIfNeeded()
            }
            return
        }
        
        if shouldExpand {
            
            UIView.animate(withDuration: 0.25) {
                
                let currentCount = self.selectedProfileDataSource.count
                let height = currentCount * 40
                self.mainContainerConstraint?.constant = CGFloat(height) + 90
                self.view.layoutIfNeeded()
                self.view.superview?.layoutIfNeeded()
                
            }
            
        } else {
            
            UIView.animate(withDuration: 0.25) {
                
                self.mainContainerConstraint?.constant = 80
                self.view.layoutIfNeeded()
                self.view.superview?.layoutIfNeeded()
                
            }
        }
    }
    
    @objc func handlePackageSelection(packageSelection : String) {
        
        self.selectServicesCollection.isHidden = true
        
        switch packageSelection {
        
        case "Full Package" :
            self.currentState = .FullPackage
            self.handleFullPackage()
        case "Custom Package" :
            self.currentState = .CustomPackage
            self.handleCustomPackage()
            
        default: print("default for package selection")
            
        }
    }
    
    func handleFullPackage() {
        
        self.scrollView.isScrollEnabled = true
        self.mainContainerFP.isHidden = false
        self.mainContainerCP.isHidden = true
        self.selectServicesCollection.isHidden = true
        self.addOnsLabel.isHidden = false
        self.addOnsLabel.text = "Add Ons"
        self.servicesDropDownCollection.isHidden = false
        self.customServicesDropDownCollection.isHidden = true
        self.nextButton.isHidden = false
        self.scrollView.scrollToBottom()
        self.shouldExpandMainContainerFP(shouldExpand: true)
        
    }
    
    func handleCustomPackage() {
        
        self.scrollView.isScrollEnabled = true
        self.mainContainerFP.isHidden = true
        self.mainContainerCP.isHidden = false
        self.selectServicesCollection.isHidden = true
        self.addOnsLabel.isHidden = false
        self.addOnsLabel.text = "Build Custom Service"
        self.servicesDropDownCollection.isHidden = true
        self.customServicesDropDownCollection.isHidden = false
        self.nextButton.isHidden = false
        self.scrollView.scrollToBottom()
        
    }
    
    @objc func handleMainContainerTaps() {
        
        self.mainContainerFP.isHidden = true
        self.mainContainerCP.isHidden = true
        self.selectServicesCollection.isHidden = false
        self.addOnsLabel.isHidden = true
        self.servicesDropDownCollection.isHidden = true
        self.customServicesDropDownCollection.isHidden = true
        self.scrollView.isScrollEnabled = false
        self.scrollView.scrollToTop()
        self.nextButton.isHidden = true
        
    }
    
    @objc func callPetsCollection() {
        
        var datasourceReplica = self.doggyProfileDataSource
        let post = DoggyProfileDataSource(json: ["dog":"dog"])
        datasourceReplica.insert(post, at: 0)
        
        self.petAppointmentCollection.doggyProfileDataSource = datasourceReplica
        
        DispatchQueue.main.async {
            self.petAppointmentCollection.reloadData()
        }
    }
    
    @objc func handleNextButton() {
        
        UIDevice.vibrateLight()
        
        let appointmentTwo = AppointmentTwo()
        appointmentTwo.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(appointmentTwo, animated: true)
        
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
