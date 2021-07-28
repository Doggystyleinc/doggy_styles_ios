//
//  NewDogTwo.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/28/21.
//

import Foundation
import UIKit

class NewDogTwo : UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
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
        hbo.backgroundColor = coreWhiteColor
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
    
    let foodAndMedicalLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Food & Medical"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    let favoriteTreatLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Favorite treat / food"
        nl.font = UIFont(name: dsSubHeaderFont, size: 21)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    lazy var searchTreatTextField : TextFieldWithImage = {
        
        let etfc = TextFieldWithImage()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.placeholder = "Search by keyword"
        etfc.textAlignment = .left
        etfc.backgroundColor = coreWhiteColor
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: dsSubHeaderFont, size: 15)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.layer.cornerRadius = 10
        etfc.layer.masksToBounds = false
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.1
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        
        let image = UIImage(named: "search_glass")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 9, height: 9)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        etfc.leftView = imageView
        etfc.leftViewMode = .always
        
        return etfc
        
    }()
    
    
    let medicalConditionsLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Medical conditions?"
        nl.font = UIFont(name: dsSubHeaderFont, size: 21)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    
     let noMedicalButton : UIButton = {
         
         let dcl = UIButton(type: .system)
         dcl.translatesAutoresizingMaskIntoConstraints = false
         dcl.backgroundColor = dsButtonLightGrey
         dcl.contentMode = .scaleAspectFit
         dcl.isUserInteractionEnabled = true
         dcl.clipsToBounds = false
         dcl.layer.masksToBounds = false
         dcl.layer.shadowColor = coreBlackColor.cgColor
         dcl.layer.shadowOpacity = 0.05
         dcl.layer.shadowOffset = CGSize(width: 2, height: 3)
         dcl.layer.shadowRadius = 9
         dcl.layer.shouldRasterize = false
         dcl.layer.cornerRadius = 14
         
         dcl.setTitle("No", for: .normal)
         dcl.titleLabel?.textColor = coreOrangeColor
         dcl.tintColor = coreOrangeColor
         dcl.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
         
         return dcl
     }()
     
     let yesMedicalButton : UIButton = {
         
         let dcl = UIButton(type: .system)
         dcl.translatesAutoresizingMaskIntoConstraints = false
         dcl.backgroundColor = dsButtonLightGrey
         dcl.contentMode = .scaleAspectFit
         dcl.isUserInteractionEnabled = true
         dcl.clipsToBounds = false
         dcl.layer.masksToBounds = false
         dcl.layer.shadowColor = coreBlackColor.cgColor
         dcl.layer.shadowOpacity = 0.05
         dcl.layer.shadowOffset = CGSize(width: 2, height: 3)
         dcl.layer.shadowRadius = 9
         dcl.layer.shouldRasterize = false
         dcl.layer.cornerRadius = 14
         
         dcl.setTitle("Yes", for: .normal)
         dcl.titleLabel?.textColor = coreOrangeColor
         dcl.tintColor = dsFlatBlack.withAlphaComponent(0.4)
         dcl.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
         
         return dcl
     }()
    
    let behavioralConcerns : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Any behavioural concerns?"
        nl.font = UIFont(name: dsSubHeaderFont, size: 21)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    let noBehaviorButton : UIButton = {
        
        let dcl = UIButton(type: .system)
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = dsButtonLightGrey
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = true
        dcl.clipsToBounds = false
        dcl.layer.masksToBounds = false
        dcl.layer.shadowColor = coreBlackColor.cgColor
        dcl.layer.shadowOpacity = 0.05
        dcl.layer.shadowOffset = CGSize(width: 2, height: 3)
        dcl.layer.shadowRadius = 9
        dcl.layer.shouldRasterize = false
        dcl.layer.cornerRadius = 14
        
        dcl.setTitle("No", for: .normal)
        dcl.titleLabel?.textColor = coreOrangeColor
        dcl.tintColor = coreOrangeColor
        dcl.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
        
        return dcl
    }()
    
    let yesBehaviorButton : UIButton = {
        
        let dcl = UIButton(type: .system)
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = dsButtonLightGrey
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = true
        dcl.clipsToBounds = false
        dcl.layer.masksToBounds = false
        dcl.layer.shadowColor = coreBlackColor.cgColor
        dcl.layer.shadowOpacity = 0.05
        dcl.layer.shadowOffset = CGSize(width: 2, height: 3)
        dcl.layer.shadowRadius = 9
        dcl.layer.shouldRasterize = false
        dcl.layer.cornerRadius = 14
        
        dcl.setTitle("Yes", for: .normal)
        dcl.titleLabel?.textColor = coreOrangeColor
        dcl.tintColor = dsFlatBlack.withAlphaComponent(0.4)
        dcl.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
        
        return dcl
    }()
    
    let vaccineCardLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Vaccine card"
        nl.font = UIFont(name: dsSubHeaderFont, size: 21)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    lazy var tapToUploadVaccineButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Tap to upload", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dsFlatBlack.withAlphaComponent(0.4)
        cbf.backgroundColor = dsButtonLightGrey
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = dsFlatBlack.withAlphaComponent(0.4)
        
        return cbf
    }()
    
    lazy var expiryTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Expiry (MM/YY)", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
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
    
    let otherDocumentationLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Other documentation (optional)"
        nl.font = UIFont(name: dsSubHeaderFont, size: 21)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    lazy var tapToUploadOtherDocumentationButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Tap to upload", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dsFlatBlack.withAlphaComponent(0.4)
        cbf.backgroundColor = dsButtonLightGrey
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = dsFlatBlack.withAlphaComponent(0.4)
        
        return cbf
    }()
    
    lazy var documentTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Document name", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
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
        
        self.scrollView.addSubview(self.foodAndMedicalLabel)
        self.scrollView.addSubview(self.favoriteTreatLabel)
        self.scrollView.addSubview(self.searchTreatTextField)
        
        self.scrollView.addSubview(self.medicalConditionsLabel)
        self.scrollView.addSubview(self.noMedicalButton)
        self.scrollView.addSubview(self.yesMedicalButton)

        self.scrollView.addSubview(self.behavioralConcerns)
        self.scrollView.addSubview(self.noBehaviorButton)
        self.scrollView.addSubview(self.yesBehaviorButton)
        
        self.scrollView.addSubview(self.vaccineCardLabel)
        self.scrollView.addSubview(self.tapToUploadVaccineButton)

        self.scrollView.addSubview(self.expiryTextField)
        self.scrollView.addSubview(self.otherDocumentationLabel)
        self.scrollView.addSubview(self.tapToUploadOtherDocumentationButton)
        self.scrollView.addSubview(self.documentTextField)
        
        self.scrollView.addSubview(self.nextButton)
        self.scrollView.addSubview(self.backButton)
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.5)
        
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
        
        self.foodAndMedicalLabel.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 30).isActive = true
        self.foodAndMedicalLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.foodAndMedicalLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.foodAndMedicalLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.favoriteTreatLabel.topAnchor.constraint(equalTo: self.foodAndMedicalLabel.bottomAnchor, constant: 23).isActive = true
        self.favoriteTreatLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.favoriteTreatLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.favoriteTreatLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.searchTreatTextField.topAnchor.constraint(equalTo: self.favoriteTreatLabel.bottomAnchor, constant: 20).isActive = true
        self.searchTreatTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.searchTreatTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.searchTreatTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.medicalConditionsLabel.topAnchor.constraint(equalTo: self.searchTreatTextField.bottomAnchor, constant: 30).isActive = true
        self.medicalConditionsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.medicalConditionsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.medicalConditionsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.noMedicalButton.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -8).isActive = true
        self.noMedicalButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.noMedicalButton.topAnchor.constraint(equalTo: self.medicalConditionsLabel.bottomAnchor, constant: 20).isActive = true
        self.noMedicalButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.yesMedicalButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 8).isActive = true
        self.yesMedicalButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.yesMedicalButton.topAnchor.constraint(equalTo: self.medicalConditionsLabel.bottomAnchor, constant: 20).isActive = true
        self.yesMedicalButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.behavioralConcerns.topAnchor.constraint(equalTo: self.yesMedicalButton.bottomAnchor, constant: 25).isActive = true
        self.behavioralConcerns.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.behavioralConcerns.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.behavioralConcerns.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.noBehaviorButton.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -8).isActive = true
        self.noBehaviorButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.noBehaviorButton.topAnchor.constraint(equalTo: self.behavioralConcerns.bottomAnchor, constant: 20).isActive = true
        self.noBehaviorButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.yesBehaviorButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 8).isActive = true
        self.yesBehaviorButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.yesBehaviorButton.topAnchor.constraint(equalTo: self.behavioralConcerns.bottomAnchor, constant: 20).isActive = true
        self.yesBehaviorButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.vaccineCardLabel.topAnchor.constraint(equalTo: self.yesBehaviorButton.bottomAnchor, constant: 25).isActive = true
        self.vaccineCardLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.vaccineCardLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.vaccineCardLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.tapToUploadVaccineButton.topAnchor.constraint(equalTo: self.vaccineCardLabel.bottomAnchor, constant: 20).isActive = true
        self.tapToUploadVaccineButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.tapToUploadVaccineButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.tapToUploadVaccineButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.expiryTextField.topAnchor.constraint(equalTo: self.tapToUploadVaccineButton.bottomAnchor, constant: 20).isActive = true
        self.expiryTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.expiryTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.expiryTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.otherDocumentationLabel.topAnchor.constraint(equalTo: self.expiryTextField.bottomAnchor, constant: 25).isActive = true
        self.otherDocumentationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.otherDocumentationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.otherDocumentationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.tapToUploadOtherDocumentationButton.topAnchor.constraint(equalTo: self.otherDocumentationLabel.bottomAnchor, constant: 20).isActive = true
        self.tapToUploadOtherDocumentationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.tapToUploadOtherDocumentationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.tapToUploadOtherDocumentationButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.documentTextField.topAnchor.constraint(equalTo: self.tapToUploadOtherDocumentationButton.bottomAnchor, constant: 20).isActive = true
        self.documentTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.documentTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.documentTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.nextButton.topAnchor.constraint(equalTo: self.documentTextField.bottomAnchor, constant: 40).isActive = true
        self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.backButton.topAnchor.constraint(equalTo: self.nextButton.bottomAnchor, constant: 30).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.backButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.backButton.sizeToFit()
        
    }
    
    func customAlertController() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { res in
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { res in
        }
        
        let documentAction = UIAlertAction(title: "Document", style: .default) { res in
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { res in
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(documentAction)
        alertController.addAction(cancelAction)
        
        alertController.view.tintColor = coreBlackColor
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNextButton() {
        let newDogThree = NewDogThree()
        let nav = UINavigationController(rootViewController: newDogThree)
        self.navigationController?.pushViewController(nav, animated: true)
    }
}
