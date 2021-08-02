//
//  NewDogOne.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/28/21.
//

import Foundation
import UIKit

class NewDogOne : UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
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
    
    var progressBar : UIView = {
        
        let hc = UIView()
        hc.translatesAutoresizingMaskIntoConstraints = false
        hc.backgroundColor = .red
        hc.isUserInteractionEnabled = false
        
       return hc
    }()
    
    lazy var cancelButton : UIButton = {
        
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
        dcl.addTarget(self, action: #selector(self.handleBackButton), for: .touchUpInside)

        return dcl
    }()
    
    let basicDetailsLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Basic Details"
        nl.font = UIFont(name: dsHeaderFont, size: 23)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    lazy var profileImageViewContainer : UILabel = {
        
        let pv = UILabel()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = coreWhiteColor
        pv.isUserInteractionEnabled = true
        pv.clipsToBounds = false
        pv.layer.masksToBounds = true
        pv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        pv.layer.shadowOpacity = 0.05
        pv.layer.shadowOffset = CGSize(width: 2, height: 3)
        pv.layer.shadowRadius = 9
        pv.layer.shouldRasterize = false
        pv.textAlignment = .center
        pv.font = UIFont.fontAwesome(ofSize: 24, style: .solid)
        pv.text = String.fontAwesomeIcon(name: .camera)
        pv.textColor = dsFlatBlack.withAlphaComponent(0.4)
        
        return pv
    }()
    
    lazy var profileImageView : UIImageView = {

        let pv = UIImageView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = .clear
        pv.contentMode = .scaleAspectFill
        pv.isUserInteractionEnabled = true
        pv.layer.masksToBounds = true
        pv.clipsToBounds = true
        return pv
    }()
    
    
    lazy var nameTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
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
    
    lazy var breedTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Breed", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
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
    
    lazy var ageTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Age", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
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
    
    let genderLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Gender"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    let maleButton : UIButton = {
        
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
        dcl.layer.cornerRadius = 14
        
        dcl.setTitle("Male", for: .normal)
        dcl.titleLabel?.textColor = coreOrangeColor
        dcl.tintColor = coreOrangeColor
        dcl.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
        
        return dcl
    }()
    
    let femaleButton : UIButton = {
        
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
        dcl.layer.cornerRadius = 14
        
        dcl.setTitle("Female", for: .normal)
        dcl.titleLabel?.textColor = coreOrangeColor
        dcl.tintColor = dsFlatBlack.withAlphaComponent(0.4)
        dcl.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
        
        return dcl
    }()
    
    let sizeLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Size"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    let weightSmallButton : UIButton = {
        
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
        dcl.layer.cornerRadius = 14
        dcl.titleLabel?.numberOfLines = 2
        dcl.titleLabel?.textAlignment = .center

        dcl.setTitle("Small\n<15kg", for: .normal)
        dcl.titleLabel?.textColor = coreOrangeColor
        dcl.tintColor = coreOrangeColor
        dcl.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
        
        return dcl
    }()
    
    let weightMediumButton : UIButton = {
        
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
        dcl.layer.cornerRadius = 14
        dcl.titleLabel?.numberOfLines = 2
        dcl.titleLabel?.textAlignment = .center

        dcl.setTitle("Medium\n15-25kg", for: .normal)
        dcl.titleLabel?.textColor = coreOrangeColor
        dcl.tintColor = dsFlatBlack.withAlphaComponent(0.4)
        dcl.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
        
        return dcl
    }()
    
    let weightLargeButton : UIButton = {
        
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
        dcl.layer.cornerRadius = 14
        dcl.titleLabel?.numberOfLines = 2
        dcl.titleLabel?.textAlignment = .center

        dcl.setTitle("Large\n26-35kg", for: .normal)
        dcl.titleLabel?.textColor = coreOrangeColor
        dcl.tintColor = dsFlatBlack.withAlphaComponent(0.4)
        dcl.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
        
        return dcl
    }()
    
    let weightExtraLargeButton : UIButton = {
        
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
        dcl.layer.cornerRadius = 14
        
        dcl.setTitle("X-Large\n>35kg", for: .normal)
        dcl.titleLabel?.textColor = coreOrangeColor
        dcl.titleLabel?.numberOfLines = 2
        dcl.titleLabel?.textAlignment = .center
        dcl.tintColor = dsFlatBlack.withAlphaComponent(0.4)
        dcl.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
        
        return dcl
    }()
    
    let groomingFrequencyLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Grooming Frequency"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = dsFlatBlack
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    let fourWeeksButton : UIButton = {
        
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
        dcl.layer.cornerRadius = 14
        
        dcl.setTitle("4 weeks", for: .normal)
        dcl.titleLabel?.textColor = coreOrangeColor
        dcl.tintColor = coreOrangeColor
        dcl.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
        
        return dcl
    }()
    
    let eightWeeksButton : UIButton = {
        
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
        dcl.layer.cornerRadius = 14
        
        dcl.setTitle("8 weeks", for: .normal)
        dcl.titleLabel?.textColor = coreOrangeColor
        dcl.tintColor = dsFlatBlack.withAlphaComponent(0.4)
        dcl.titleLabel?.font = UIFont(name: dsHeaderFont, size: 18)
        
        return dcl
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
       return hbo
    }()
    
    let headerBarTwo : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = coreWhiteColor
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
    
    let informationButton : UIButton = {
        
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
        
        return dcl
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

        self.stackView.addArrangedSubview(self.headerBarOne)
        self.stackView.addArrangedSubview(self.headerBarTwo)
        self.stackView.addArrangedSubview(self.headerBarThree)
        self.stackView.addArrangedSubview(self.headerBarFour)
        
        self.scrollView.addSubview(self.headerContainer)
        self.scrollView.addSubview(self.cancelButton)
        self.scrollView.addSubview(self.progressBar)
        self.scrollView.addSubview(self.basicDetailsLabel)
        self.scrollView.addSubview(self.profileImageViewContainer)
        self.scrollView.addSubview(self.profileImageView)

        self.scrollView.addSubview(self.nameTextField)
        self.scrollView.addSubview(self.breedTextField)
        self.scrollView.addSubview(self.ageTextField)

        self.scrollView.addSubview(self.genderLabel)
        
        self.scrollView.addSubview(self.maleButton)
        self.scrollView.addSubview(self.femaleButton)
        
        self.scrollView.addSubview(self.sizeLabel)
        
        self.scrollView.addSubview(self.weightSmallButton)
        self.scrollView.addSubview(self.weightMediumButton)
        
        self.scrollView.addSubview(self.weightLargeButton)
        self.scrollView.addSubview(self.weightExtraLargeButton)

        self.scrollView.addSubview(self.groomingFrequencyLabel)

        self.scrollView.addSubview(self.fourWeeksButton)
        self.scrollView.addSubview(self.eightWeeksButton)
        
        self.scrollView.addSubview(self.nextButton)
        self.scrollView.addSubview(self.informationButton)

        self.view.addSubview(timeCover)

        
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
        
        self.basicDetailsLabel.topAnchor.constraint(equalTo: self.headerContainer.bottomAnchor, constant: 30).isActive = true
        self.basicDetailsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.basicDetailsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.basicDetailsLabel.sizeToFit()
        
        self.profileImageViewContainer.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 13).isActive = true
        self.profileImageViewContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.profileImageViewContainer.heightAnchor.constraint(equalToConstant: 83).isActive = true
        self.profileImageViewContainer.widthAnchor.constraint(equalToConstant: 83).isActive = true
        self.profileImageViewContainer.layer.cornerRadius = 83/2
        
        self.profileImageView.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 13).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 83).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 83).isActive = true
        self.profileImageView.layer.cornerRadius = 83/2
        
        self.nameTextField.topAnchor.constraint(equalTo: self.profileImageViewContainer.bottomAnchor, constant: 25).isActive = true
        self.nameTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.nameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.nameTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.breedTextField.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 20).isActive = true
        self.breedTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.breedTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.breedTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.ageTextField.topAnchor.constraint(equalTo: self.breedTextField.bottomAnchor, constant: 20).isActive = true
        self.ageTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.ageTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.ageTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.genderLabel.topAnchor.constraint(equalTo: self.ageTextField.bottomAnchor, constant: 30).isActive = true
        self.genderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.genderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.genderLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.maleButton.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -8).isActive = true
        self.maleButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.maleButton.topAnchor.constraint(equalTo: self.genderLabel.bottomAnchor, constant: 20).isActive = true
        self.maleButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.femaleButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 8).isActive = true
        self.femaleButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.femaleButton.topAnchor.constraint(equalTo: self.genderLabel.bottomAnchor, constant: 20).isActive = true
        self.femaleButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.sizeLabel.topAnchor.constraint(equalTo: self.femaleButton.bottomAnchor, constant: 30).isActive = true
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
        
        self.groomingFrequencyLabel.topAnchor.constraint(equalTo: self.weightExtraLargeButton.bottomAnchor, constant: 30).isActive = true
        self.groomingFrequencyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.groomingFrequencyLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.groomingFrequencyLabel.sizeToFit()
        
        self.informationButton.centerYAnchor.constraint(equalTo: self.groomingFrequencyLabel.centerYAnchor, constant: 0).isActive = true
        self.informationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.informationButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.informationButton.widthAnchor.constraint(equalToConstant: 20).isActive = true

        self.fourWeeksButton.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -8).isActive = true
        self.fourWeeksButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.fourWeeksButton.topAnchor.constraint(equalTo: self.groomingFrequencyLabel.bottomAnchor, constant: 20).isActive = true
        self.fourWeeksButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.eightWeeksButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 8).isActive = true
        self.eightWeeksButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.eightWeeksButton.topAnchor.constraint(equalTo: self.groomingFrequencyLabel.bottomAnchor, constant: 20).isActive = true
        self.eightWeeksButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.nextButton.topAnchor.constraint(equalTo: self.fourWeeksButton.bottomAnchor, constant: 40).isActive = true
        self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.timeCover.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.timeCover.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.timeCover.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.timeCover.heightAnchor.constraint(equalToConstant: globalStatusBarHeight).isActive = true
        
    }
    
    @objc func handleBackButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNextButton() {
        let newDogTwo = NewDogTwo()
        newDogTwo.modalPresentationStyle = .fullScreen
        newDogTwo.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(newDogTwo, animated: true)
    }
}
