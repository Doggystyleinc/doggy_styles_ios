//
//  NewDogFour.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/6/21.
//

import UIKit
import Foundation

class NewDogFour : UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    var selectedImage : UIImage?,
        medicalDifference : CGFloat = 0.0,
        behaviorDifference : CGFloat = 0.0,
        fileDifference : CGFloat = 0.0,
        containerTwoTopConstraint : NSLayoutConstraint?,
        containerThreeTopConstraint : NSLayoutConstraint?,
        adjustmentDifference : CGFloat = 25.0,
        offSetDifference : CGFloat = 70.0
    
    lazy var scrollView : UIScrollView = {
        
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = coreBackgroundWhite
        sv.isScrollEnabled = true
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 1.0
        sv.bouncesZoom = false
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
        cbf.backgroundColor = coreWhiteColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreOrangeColor
        cbf.titleLabel?.textAlignment = .center
        cbf.tag = 1
        cbf.addTarget(self, action: #selector(self.handleMedicalConditionSelection(sender:)), for: .touchUpInside)
        
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
        cbf.tag = 2
        cbf.addTarget(self, action: #selector(self.handleMedicalConditionSelection(sender:)), for: .touchUpInside)
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
        cbf.backgroundColor = coreWhiteColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreOrangeColor
        cbf.titleLabel?.textAlignment = .center
        cbf.tag = 1
        cbf.addTarget(self, action: #selector(self.handleBehavioralConcernsSelection(sender:)), for: .touchUpInside)
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
        cbf.tag = 2
        cbf.addTarget(self, action: #selector(self.handleBehavioralConcernsSelection(sender:)), for: .touchUpInside)
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
        cbf.layer.borderWidth = 1.0
        cbf.layer.borderColor = UIColor.clear.cgColor
        cbf.addTarget(self, action: #selector(self.customAlertDecision), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var selectedVaccineButton: UITextField = {
        
        let etfc = UITextField()
        let placeholder = NSAttributedString(string: "...", attributes: [NSAttributedString.Key.foregroundColor: dividerGrey])
        etfc.attributedPlaceholder = placeholder
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikRegular, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .alphabet
        etfc.leftViewMode = .always
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isSecureTextEntry = false
        etfc.isHidden = true
        etfc.alpha = 1
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 10
        etfc.textAlignment = .left
        etfc.setRightPaddingPoints(50)
        
        return etfc
        
    }()
    
    lazy var vaccineIconButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreRedColor
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 17, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .timesCircle), for: .normal)
        cbf.isUserInteractionEnabled = true
        cbf.addTarget(self, action: #selector(self.handleXIcon), for: .touchUpInside)
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
    
    let filePhotoImage : UIImageView = {
        
        let fph = UIImageView()
        fph.backgroundColor = coreWhiteColor
        fph.translatesAutoresizingMaskIntoConstraints = false
        fph.contentMode = .scaleAspectFill
        fph.isUserInteractionEnabled = false
        fph.layer.masksToBounds = true
        fph.layer.cornerRadius = 10
        fph.isHidden = true
        
        return fph
    }()
    
    
    
    lazy var medicalConditionTextField: UITextField = {
        
        let etfc = UITextField()
        let placeholder = NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor: dividerGrey])
        etfc.attributedPlaceholder = placeholder
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikRegular, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .alphabet
        etfc.leftViewMode = .always
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isSecureTextEntry = false
        etfc.isHidden = false
        etfc.alpha = 0
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 10
        etfc.setRightPaddingPoints(50)
        
        return etfc
        
    }()
    
    lazy var pencilIconButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreOrangeColor
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 17, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        cbf.isUserInteractionEnabled = false
        return cbf
        
    }()
    
    lazy var behavioralConditionTextField: UITextField = {
        
        let etfc = UITextField()
        let placeholder = NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor: dividerGrey])
        etfc.attributedPlaceholder = placeholder
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikRegular, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .alphabet
        etfc.leftViewMode = .always
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isSecureTextEntry = false
        etfc.isHidden = false
        etfc.alpha = 0
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 10
        etfc.setRightPaddingPoints(50)
        
        return etfc
        
    }()
    
    lazy var behaviorPencilIconButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreOrangeColor
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 17, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        cbf.isUserInteractionEnabled = false
        return cbf
        
    }()
    
    var buttonContainer : UIView = {
        
        let bc = UIView()
        bc.translatesAutoresizingMaskIntoConstraints = false
        bc.backgroundColor = coreBackgroundWhite
        
       return bc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
        globalNewDogBuilder.dogBuilderHasMedicalConditions = false
        globalNewDogBuilder.dogBuilderHasBehaviouralConditions = false
        
        let dogsName = globalNewDogBuilder.dogBuilderName ?? "Dog"
        self.basicDetailsLabel.text = "\(dogsName)'s Foodz"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let dogsName = globalNewDogBuilder.dogBuilderName ?? "Dog"
        self.basicDetailsLabel.text = "\(dogsName)'s details"
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.selectedVaccineButton.endEditing(true)
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
        self.scrollView.addSubview(self.medicalConditionTextField)
        self.medicalConditionTextField.addSubview(self.pencilIconButton)
        
        self.containerTwo.addSubview(self.behaviorConcernsLabel)
        self.containerTwo.addSubview(self.behaviorNoButton)
        self.containerTwo.addSubview(self.behaviorYesButton)
        
        self.scrollView.addSubview(self.behavioralConditionTextField)
        self.behavioralConditionTextField.addSubview(self.behaviorPencilIconButton)
        
        self.containerThree.addSubview(self.vaccineLabel)
        self.containerThree.addSubview(self.vaccineUploadButton)
        self.containerThree.addSubview(self.filePhotoImage)
        
        self.scrollView.addSubview(self.selectedVaccineButton)
        self.selectedVaccineButton.addSubview(self.vaccineIconButton)

        self.scrollView.addSubview(self.nextButton)

        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
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
        
        self.containerTwoTopConstraint = self.containerTwo.topAnchor.constraint(equalTo: self.containerOne.bottomAnchor, constant: 0)
        self.containerTwoTopConstraint?.isActive = true
        
        self.containerTwo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.containerTwo.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.containerTwo.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 6).isActive = true
        
        self.containerThreeTopConstraint = self.containerThree.topAnchor.constraint(equalTo: self.containerTwo.bottomAnchor, constant: 0)
        self.containerThreeTopConstraint?.isActive = true
        
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
        
        self.vaccineLabel.topAnchor.constraint(equalTo: self.containerThree.topAnchor, constant: 18).isActive = true
        self.vaccineLabel.leftAnchor.constraint(equalTo: self.containerThree.leftAnchor, constant: 30).isActive = true
        self.vaccineLabel.rightAnchor.constraint(equalTo: self.containerThree.rightAnchor, constant: -30).isActive = true
        self.vaccineLabel.sizeToFit()
        
        self.vaccineUploadButton.leftAnchor.constraint(equalTo: self.containerThree.leftAnchor, constant: 30).isActive = true
        self.vaccineUploadButton.topAnchor.constraint(equalTo: self.vaccineLabel.bottomAnchor, constant: 20).isActive = true
        self.vaccineUploadButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.vaccineUploadButton.rightAnchor.constraint(equalTo: self.containerThree.rightAnchor, constant: -30).isActive = true
      
        self.filePhotoImage.rightAnchor.constraint(equalTo: self.vaccineUploadButton.rightAnchor, constant: -6).isActive = true
        self.filePhotoImage.centerYAnchor.constraint(equalTo: self.vaccineUploadButton.centerYAnchor, constant: 0).isActive = true
        self.filePhotoImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.filePhotoImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.medicalConditionTextField.topAnchor.constraint(equalTo: self.medicalNoButton.bottomAnchor, constant: 20).isActive = true
        self.medicalConditionTextField.leftAnchor.constraint(equalTo: self.medicalNoButton.leftAnchor, constant: 0).isActive = true
        self.medicalConditionTextField.rightAnchor.constraint(equalTo: self.medicalYesButton.rightAnchor, constant: 0).isActive = true
        self.medicalConditionTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.pencilIconButton.centerYAnchor.constraint(equalTo: self.medicalConditionTextField.centerYAnchor, constant: 0).isActive = true
        self.pencilIconButton.rightAnchor.constraint(equalTo: self.medicalConditionTextField.rightAnchor, constant: -12).isActive = true
        self.pencilIconButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.pencilIconButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.behavioralConditionTextField.topAnchor.constraint(equalTo: self.behaviorNoButton.bottomAnchor, constant: 20).isActive = true
        self.behavioralConditionTextField.leftAnchor.constraint(equalTo: self.behaviorNoButton.leftAnchor, constant: 0).isActive = true
        self.behavioralConditionTextField.rightAnchor.constraint(equalTo: self.behaviorYesButton.rightAnchor, constant: 0).isActive = true
        self.behavioralConditionTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.behaviorPencilIconButton.centerYAnchor.constraint(equalTo: self.behavioralConditionTextField.centerYAnchor, constant: 0).isActive = true
        self.behaviorPencilIconButton.rightAnchor.constraint(equalTo: self.behavioralConditionTextField.rightAnchor, constant: -12).isActive = true
        self.behaviorPencilIconButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.behaviorPencilIconButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.selectedVaccineButton.topAnchor.constraint(equalTo: self.vaccineUploadButton.bottomAnchor, constant: 20).isActive = true
        self.selectedVaccineButton.leftAnchor.constraint(equalTo: self.containerThree.leftAnchor, constant: 30).isActive = true
        self.selectedVaccineButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.selectedVaccineButton.rightAnchor.constraint(equalTo: self.containerThree.rightAnchor, constant: -30).isActive = true
        
        self.vaccineIconButton.centerYAnchor.constraint(equalTo: self.selectedVaccineButton.centerYAnchor, constant: 0).isActive = true
        self.vaccineIconButton.rightAnchor.constraint(equalTo: self.selectedVaccineButton.rightAnchor, constant: -7).isActive = true
        self.vaccineIconButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.vaccineIconButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.nextButton.topAnchor.constraint(equalTo: self.selectedVaccineButton.bottomAnchor, constant: 20).isActive = true
        self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    @objc func handleXIcon() {
        
        self.selectedVaccineButton.isHidden = true
        self.selectedVaccineButton.text = ""

        globalNewDogBuilder.dogBuilderHasUploadedVaccineCard = false
        globalNewDogBuilder.dogBuilderHasUploadedVaccineImage = UIImage()
        globalNewDogBuilder.dogBuilderHasUploadedVaccineFilePath = "nil"
        
    }
    
    func resetContentView() {
        
        self.view.layoutIfNeeded()
        
        let screenHeight = UIScreen.main.bounds.height
        
        switch screenHeight {
        
        //MANUAL CONFIGURATION - REFACTOR FOR UNNIVERSAL FITMENT
        case 926 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.height) + self.medicalDifference + self.behaviorDifference + fileDifference)
        case 896 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.height) + self.medicalDifference + self.behaviorDifference + fileDifference)
        case 844 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.height) + self.medicalDifference + self.behaviorDifference + fileDifference)
        case 812 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.height) + self.medicalDifference + self.behaviorDifference + fileDifference)
        case 736 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.height) + self.medicalDifference + self.behaviorDifference + fileDifference)
        case 667 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.height) + self.medicalDifference + self.behaviorDifference + fileDifference)
        case 568 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.height) + self.medicalDifference + self.behaviorDifference + fileDifference)
        case 480 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.height) + self.medicalDifference + self.behaviorDifference + fileDifference)
            
        default : scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.height) + self.medicalDifference + self.behaviorDifference + fileDifference)
            
        }
    }
    
    func resignation() {
        
        self.scrollView.scrollToTop()
        self.medicalConditionTextField.resignFirstResponder()
        self.behavioralConditionTextField.resignFirstResponder()
        self.resetContentView()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignation()
        return false
    }
    
    @objc func handleMedicalConditionSelection(sender : UIButton) {
        
        UIDevice.vibrateLight()
        
        switch sender.tag {
        
        case 1:
            
            UIView.animate(withDuration: 0.15) {
                self.containerTwoTopConstraint?.constant = 0
                self.medicalConditionTextField.alpha = 0
                self.view.layoutIfNeeded()
            }
            
            self.medicalConditionTextField.resignFirstResponder()
            self.medicalDifference = 0.0
            self.resetContentView()
            
            globalNewDogBuilder.dogBuilderHasMedicalConditions = false
            
            self.medicalNoButton.backgroundColor = coreWhiteColor
            self.medicalNoButton.tintColor = coreOrangeColor
            
            self.medicalYesButton.backgroundColor = dividerGrey.withAlphaComponent(0.2)
            self.medicalYesButton.tintColor = dividerGrey
            
        case 2:
            
            UIView.animate(withDuration: 0.15) {
                self.containerTwoTopConstraint?.constant = self.offSetDifference
                self.medicalConditionTextField.alpha = 1
                self.view.layoutIfNeeded()
                
            }
            
            self.medicalConditionTextField.becomeFirstResponder()
            self.medicalDifference = adjustmentDifference
            self.resetContentView()
            
            globalNewDogBuilder.dogBuilderHasMedicalConditions = true
            
            self.medicalNoButton.backgroundColor = dividerGrey.withAlphaComponent(0.2)
            self.medicalNoButton.tintColor = dividerGrey
            
            self.medicalYesButton.backgroundColor = coreWhiteColor
            self.medicalYesButton.tintColor = coreOrangeColor
            
        default: print("only 2 items here")
        }
    }
    
    @objc func handleBehavioralConcernsSelection(sender : UIButton) {
        
        switch sender.tag {
        
        case 1:
            
            UIView.animate(withDuration: 0.15) {
                self.containerThreeTopConstraint?.constant = 0
                self.behavioralConditionTextField.alpha = 0
                self.view.layoutIfNeeded()
            }
            
            self.behavioralConditionTextField.resignFirstResponder()
            self.behaviorDifference = 0.0
            self.resetContentView()
            
            globalNewDogBuilder.dogBuilderHasBehaviouralConditions = false
            
            self.behaviorNoButton.backgroundColor = coreWhiteColor
            self.behaviorNoButton.tintColor = coreOrangeColor
            
            self.behaviorYesButton.backgroundColor = dividerGrey.withAlphaComponent(0.2)
            self.behaviorYesButton.tintColor = dividerGrey
            
        case 2:
            
            UIView.animate(withDuration: 0.15) {
                self.containerThreeTopConstraint?.constant = self.offSetDifference
                self.behavioralConditionTextField.alpha = 1
                self.view.layoutIfNeeded()
                
            }
            
            self.behavioralConditionTextField.becomeFirstResponder()
            self.behaviorDifference = adjustmentDifference
            self.resetContentView()
            
            globalNewDogBuilder.dogBuilderHasBehaviouralConditions = true
            
            self.behaviorNoButton.backgroundColor = dividerGrey.withAlphaComponent(0.2)
            self.behaviorNoButton.tintColor = dividerGrey
            
            self.behaviorYesButton.backgroundColor = coreWhiteColor
            self.behaviorYesButton.tintColor = coreOrangeColor
            
        default: print("only 2 items here")
            
        }
    }
    
    @objc func customAlertDecision() {
        
        let alertController = UIAlertController(title: "Vaccine upload", message: "Would you like to upload a file or a photo?", preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: "Photo", style: .default) { res in
            self.checkForGalleryAuth()
        }
        
        let actionTwo = UIAlertAction(title: "File", style: .default) { res in
            self.checkForFiles()
        }
        
        let actionThree = UIAlertAction(title: "Cancel", style: .destructive) { res in
            
        }
        
        alertController.addAction(actionOne)
        alertController.addAction(actionTwo)
        alertController.addAction(actionThree)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func checkForFiles() {
        
        let supportedTypes: [UTType] = [.plainText, .pdf, .folder]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.navigationController?.present(documentPicker, animated: true, completion: nil)
        
    }
    
    @objc func customAlertDecisionForNoVaccinationCard() {
        
        let alertController = UIAlertController(title: "Vaccine upload", message: "Just so you know, a vaccine card will have to be uploaded in order to book a service", preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: "Ok", style: .default) { res in
            self.presentNewDogFive()
        }
        
        let actionThree = UIAlertAction(title: "Go Back", style: .destructive) { res in
            print("User is staying")
        }
        
        alertController.addAction(actionOne)
        alertController.addAction(actionThree)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNextButton() {
        
        let vacineCardUpload = globalNewDogBuilder.dogBuilderHasUploadedVaccineCard ?? false
        
        let medicalDescriptionTextField = self.medicalConditionTextField.text ?? "nil"
        let behavioralDescriptionTextField = self.behavioralConditionTextField.text ?? "nil"
        
        globalNewDogBuilder.medicalConditionDescription = medicalDescriptionTextField
        globalNewDogBuilder.behavioralConditionDescription = behavioralDescriptionTextField
        
        if vacineCardUpload == false {
            self.customAlertDecisionForNoVaccinationCard()
        } else {
            self.presentNewDogFive()
        }
    }
    
    @objc func presentNewDogFive() {
        
        UIDevice.vibrateLight()
        
        let newDogFive = NewDogFive()
        newDogFive.modalPresentationStyle = .fullScreen
        newDogFive.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(newDogFive, animated: true)
        
    }
}


import AVFoundation
import MobileCoreServices
import Photos

extension NewDogFour : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFile = urls.first else {
            return
        }
        
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = directory.appendingPathComponent(selectedFile.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            globalNewDogBuilder.dogBuilderHasUploadedVaccineFilePath = sandboxFileURL.path
            globalNewDogBuilder.dogBuilderHasUploadedVaccineCard = true
           
            globalNewDogBuilder.dogBuilderHasUploadedVaccineImage = UIImage()
            
            self.fileDifference = adjustmentDifference
            self.resetContentView()
            self.selectedVaccineButton.text = "file 📎"
            self.selectedVaccineButton.isHidden = false
            
            
        } else {
            do {
                try FileManager.default.copyItem(at: selectedFile, to: sandboxFileURL)
                
                globalNewDogBuilder.dogBuilderHasUploadedVaccineFilePath = sandboxFileURL.path
                globalNewDogBuilder.dogBuilderHasUploadedVaccineCard = true
                
                globalNewDogBuilder.dogBuilderHasUploadedVaccineImage = UIImage()
                
                self.fileDifference = adjustmentDifference
                self.resetContentView()
                self.selectedVaccineButton.text = "file 📎"
                self.selectedVaccineButton.isHidden = false
                
            } catch  {
                print("Error:")
            }
        }
    }
    
    @objc func checkForGalleryAuth() {
        
        UIDevice.vibrateLight()
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        
        case .authorized:
            self.openGallery()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.openGallery()
                }
            })
            
        case .restricted:
            AlertControllerCompletion.handleAlertWithCompletion(title: "Permissions", message: "Please allow Photo Library Permissions in the Settings application.") { (complete) in
                print("Alert presented")
            }
        case .denied:
            AlertControllerCompletion.handleAlertWithCompletion(title: "Permissions", message: "Please allow Photo Library Permissions in the Settings application.") { (complete) in
                print("Alert presented")
            }
        default :
            AlertControllerCompletion.handleAlertWithCompletion(title: "Permissions", message: "Please allow Photo Library Permissions in the Settings application.") { (complete) in
                print("Alert presented")
            }
        }
    }
    
    func openCameraOptions() {
        
        DispatchQueue.main.async {
            
            let ip = UIImagePickerController()
            ip.sourceType = .camera
            ip.mediaTypes = [kUTTypeImage as String]
            ip.allowsEditing = true
            ip.delegate = self
            
            if let topViewController = UIApplication.getTopMostViewController() {
                topViewController.present(ip, animated: true) {
                    
                }
            }
        }
    }
    
    func openGallery() {
        
        DispatchQueue.main.async {
            
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            
            if let topViewController = UIApplication.getTopMostViewController() {
                topViewController.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true) {
            print("Dismissed the image picker or camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            
            let mediaType = info[.mediaType] as! CFString
            
            switch mediaType {
            
            case kUTTypeImage :
                
                if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    
                    self.selectedImage = editedImage

                    globalNewDogBuilder.dogBuilderHasUploadedVaccineCard = true
                    globalNewDogBuilder.dogBuilderHasUploadedVaccineImage = self.selectedImage
                    
                    globalNewDogBuilder.dogBuilderHasUploadedVaccineFilePath = "nil"
                    
                    self.fileDifference = self.adjustmentDifference
                    self.resetContentView()
                    self.selectedVaccineButton.text = "image 📎"
                    self.selectedVaccineButton.isHidden = false
                    
                    UIDevice.vibrateLight()
                    
                    
                } else if let originalImage = info[.originalImage] as? UIImage  {
                    
                    self.selectedImage = originalImage
                    
                    globalNewDogBuilder.dogBuilderHasUploadedVaccineCard = true
                    globalNewDogBuilder.dogBuilderHasUploadedVaccineImage = self.selectedImage
                    
                    globalNewDogBuilder.dogBuilderHasUploadedVaccineFilePath = "nil"
                    
                    self.fileDifference = self.adjustmentDifference
                    self.resetContentView()
                    self.selectedVaccineButton.text = "image 📎"
                    self.selectedVaccineButton.isHidden = false
                    
                    UIDevice.vibrateLight()
                    
                    
                } else {
                    print("Failed grabbing the photo")
                }
                
            default : print("SHOULD NOT HIT FOR THE CAMERA PICKER")
                
            }
        }
    }
}











