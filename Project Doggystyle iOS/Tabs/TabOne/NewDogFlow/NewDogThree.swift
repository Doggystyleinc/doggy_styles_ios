//
//  NewDogThree.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/28/21.
//

import Foundation
import UIKit

class NewDogThree : UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    lazy var scrollView : UIScrollView = {
        
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .white
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 2.0
        sv.bounces = true
        sv.bouncesZoom = true
        sv.isHidden = false
        sv.delegate = self
        sv.contentMode = .scaleAspectFit
        sv.isUserInteractionEnabled = true
        sv.delaysContentTouches = false
        sv.backgroundColor = .clear
        sv.isScrollEnabled = true
        sv.isUserInteractionEnabled = true
        sv.delaysContentTouches = true
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
    
    let cancelButton : UIButton = {
        
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
        dcl.titleLabel?.textColor = coreOrangeColor
        dcl.tintColor = coreOrangeColor
        dcl.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        dcl.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
        
        return dcl
    }()
    
    let headerBarOne : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreOrangeColor
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
        hbo.backgroundColor = coreWhiteColor
       return hbo
    }()
    
    let timeCover : UIView = {
        
        let tc = UIView()
        tc.translatesAutoresizingMaskIntoConstraints = false
        tc.backgroundColor = coreBackgroundWhite
        
       return tc
    }()
    
    let additionalInfoLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Additional Info"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    let selectDoggyDeliveryTypeLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Select doggy delivery type"
        nl.font = UIFont(name: dsSubHeaderFont, size: 21)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    let toggleOneView : UIView = {
        
        let tov = UIView()
        tov.translatesAutoresizingMaskIntoConstraints = false
        tov.backgroundColor = coreWhiteColor
        tov.clipsToBounds = false
        tov.layer.masksToBounds = false
        tov.layer.shadowColor = coreBlackColor.cgColor
        tov.layer.shadowOpacity = 0.2
        tov.layer.shadowOffset = CGSize(width: 0, height: 0)
        tov.layer.shadowRadius = 3
        tov.layer.shouldRasterize = false
        
       return tov
    }()
    
    let toggleTwoView : UIView = {
        
        let tov = UIView()
        tov.translatesAutoresizingMaskIntoConstraints = false
        tov.backgroundColor = coreWhiteColor
        tov.clipsToBounds = false
        tov.layer.masksToBounds = false
        tov.layer.shadowColor = coreBlackColor.cgColor
        tov.layer.shadowOpacity = 0.2
        tov.layer.shadowOffset = CGSize(width: 0, height: 0)
        tov.layer.shadowRadius = 3
        tov.layer.shouldRasterize = false
        
       return tov
    }()
    
    let valetPickupLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Valet pick up and drop off"
        nl.font = UIFont(name: dsSubHeaderFont, size: 16)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    let ownerPickupLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Owner pick up and drop off"
        nl.font = UIFont(name: dsSubHeaderFont, size: 16)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    lazy var suiteTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Suite #", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
        etfc.attributedPlaceholder = placeholder
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: dsSubHeaderFont, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .alphabet
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 10
        etfc.leftViewMode = .always
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        return etfc
        
    }()
    
    lazy var buzzerTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Buzzer code", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
        etfc.attributedPlaceholder = placeholder
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: dsSubHeaderFont, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .alphabet
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 10
        etfc.leftViewMode = .always
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        return etfc
        
    }()
    
    let additionalNotesTextView : UITextView = {
        
        let tv = UITextView()
        tv.backgroundColor = coreWhiteColor
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.clipsToBounds = false
        tv.layer.masksToBounds = false
        tv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        tv.layer.shadowOpacity = 0.05
        tv.layer.shadowOffset = CGSize(width: 2, height: 3)
        tv.layer.shadowRadius = 9
        tv.layer.shouldRasterize = false
        tv.text = "   Additional notes (optional)"
        tv.font = UIFont(name: dsSubHeaderFont, size: 18)
        tv.layer.cornerRadius = 10
        tv.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
       return tv
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
        
        return cbf
        
    }()
    
    lazy var backButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Back", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = .clear
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreBlackColor
        
        return cbf
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        self.scrollView.keyboardDismissMode = .interactive

    }
    
    func addViews() {
        
        
        self.view.addSubview(scrollView)
        self.view.addSubview(self.stackView)
        self.view.addSubview(timeCover)

        self.stackView.addArrangedSubview(self.headerBarOne)
        self.stackView.addArrangedSubview(self.headerBarTwo)
        self.stackView.addArrangedSubview(self.headerBarThree)
        self.stackView.addArrangedSubview(self.headerBarFour)
        
        self.scrollView.addSubview(self.headerContainer)
        self.scrollView.addSubview(self.cancelButton)
        
        self.scrollView.addSubview(self.additionalInfoLabel)
        self.scrollView.addSubview(self.selectDoggyDeliveryTypeLabel)
        
        self.scrollView.addSubview(self.toggleOneView)
        self.scrollView.addSubview(self.toggleTwoView)
        
        self.scrollView.addSubview(self.valetPickupLabel)
        self.scrollView.addSubview(self.ownerPickupLabel)
        
        self.scrollView.addSubview(self.suiteTextField)
        self.scrollView.addSubview(self.buzzerTextField)
        
        self.scrollView.addSubview(self.additionalNotesTextView)
        
        self.scrollView.addSubview(self.nextButton)
        self.scrollView.addSubview(self.backButton)


        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.05)
        
        self.headerBarOne.widthAnchor.constraint(equalToConstant: self.view.frame.width / 5.0).isActive = true
        self.headerBarOne.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        self.headerBarTwo.widthAnchor.constraint(equalToConstant: self.view.frame.width / 5.0).isActive = true
        self.headerBarTwo.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        self.headerBarThree.widthAnchor.constraint(equalToConstant: self.view.frame.width / 5.0).isActive = true
        self.headerBarThree.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        self.headerBarFour.widthAnchor.constraint(equalToConstant: self.view.frame.width / 5.0).isActive = true
        self.headerBarFour.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        self.headerContainer.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        self.headerContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.headerContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.headerContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.cancelButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: 0).isActive = true
        self.cancelButton.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -30).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 53).isActive = true
        self.cancelButton.widthAnchor.constraint(equalToConstant: 53).isActive = true
        
        self.stackView.topAnchor.constraint(equalTo: self.headerContainer.bottomAnchor, constant: 0).isActive = true
        self.stackView.leftAnchor.constraint(equalTo: self.headerContainer.leftAnchor, constant: 30).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -30).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        self.timeCover.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.timeCover.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.timeCover.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.timeCover.heightAnchor.constraint(equalToConstant: globalStatusBarHeight).isActive = true
        
        self.additionalInfoLabel.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 30).isActive = true
        self.additionalInfoLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.additionalInfoLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.additionalInfoLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.selectDoggyDeliveryTypeLabel.topAnchor.constraint(equalTo: self.additionalInfoLabel.bottomAnchor, constant: 23).isActive = true
        self.selectDoggyDeliveryTypeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.selectDoggyDeliveryTypeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.selectDoggyDeliveryTypeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.toggleOneView.topAnchor.constraint(equalTo: self.selectDoggyDeliveryTypeLabel.bottomAnchor, constant: 25).isActive = true
        self.toggleOneView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.toggleOneView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        self.toggleOneView.widthAnchor.constraint(equalToConstant: 27).isActive = true
        self.toggleOneView.layer.cornerRadius = 27/2
        
        self.toggleTwoView.topAnchor.constraint(equalTo: self.toggleOneView.bottomAnchor, constant: 25).isActive = true
        self.toggleTwoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.toggleTwoView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        self.toggleTwoView.widthAnchor.constraint(equalToConstant: 27).isActive = true
        self.toggleTwoView.layer.cornerRadius = 27/2

        self.valetPickupLabel.centerYAnchor.constraint(equalTo: self.toggleOneView.centerYAnchor, constant: 0).isActive = true
        self.valetPickupLabel.leftAnchor.constraint(equalTo: self.toggleOneView.rightAnchor, constant: 10).isActive = true
        self.valetPickupLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.valetPickupLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.ownerPickupLabel.centerYAnchor.constraint(equalTo: self.toggleTwoView.centerYAnchor, constant: 0).isActive = true
        self.ownerPickupLabel.leftAnchor.constraint(equalTo: self.toggleTwoView.rightAnchor, constant: 10).isActive = true
        self.ownerPickupLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.ownerPickupLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.suiteTextField.topAnchor.constraint(equalTo: self.ownerPickupLabel.bottomAnchor, constant: 28).isActive = true
        self.suiteTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.suiteTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.suiteTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.buzzerTextField.topAnchor.constraint(equalTo: self.suiteTextField.bottomAnchor, constant: 20).isActive = true
        self.buzzerTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.buzzerTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.buzzerTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.additionalNotesTextView.topAnchor.constraint(equalTo: self.buzzerTextField.bottomAnchor, constant: 20).isActive = true
        self.additionalNotesTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.additionalNotesTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.additionalNotesTextView.heightAnchor.constraint(equalToConstant: 144).isActive = true
        
        self.nextButton.topAnchor.constraint(equalTo: self.additionalNotesTextView.bottomAnchor, constant: 26).isActive = true
        self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.backButton.topAnchor.constraint(equalTo: self.nextButton.bottomAnchor, constant: 30).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.backButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.backButton.sizeToFit()
        
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNextButton() {
        let newDogFive = NewDogFive()
        let nav = UINavigationController(rootViewController: newDogFive)
        self.navigationController?.pushViewController(nav, animated: true)
    }
}
