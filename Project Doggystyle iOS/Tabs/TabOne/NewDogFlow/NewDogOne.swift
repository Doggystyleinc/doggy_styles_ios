//
//  NewDogOne.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/28/21.
//

import Foundation
import UIKit

class NewDogOne : UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    var selectedDate : String = ""
    var dogBreedJsonGrabber = DogBreed()
    var dogBreedJson : [String] = []
    var predictionString : String = ""
    var selectedImage : UIImage?
    
    var ageTopConstraint : NSLayoutConstraint?
    
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
        nl.text = "Basic info"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var profileImageViewContainer : UIButton = {
        
        let pv = UIButton()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = coreWhiteColor
        pv.isUserInteractionEnabled = true
        pv.clipsToBounds = false
        pv.layer.borderWidth = 2
        pv.layer.borderColor = coreOrangeColor.cgColor
        pv.layer.masksToBounds = true
        pv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        pv.layer.shadowOpacity = 0.05
        pv.layer.shadowOffset = CGSize(width: 2, height: 3)
        pv.layer.shadowRadius = 9
        pv.layer.shouldRasterize = false
        
        let fillerImage = UIImage(named: "doggy_profile_filler")?.withRenderingMode(.alwaysOriginal)
        pv.setBackgroundImage(fillerImage, for: .normal)
        
        return pv
    }()
    
    lazy var pencilIconButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreWhiteColor
        cbf.contentMode = .scaleAspectFill
        cbf.backgroundColor = coreOrangeColor
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 11, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        cbf.addTarget(self, action: #selector(self.checkForGalleryAuth), for: .touchUpInside)
        return cbf
        
    }()
    
    lazy var profileImageView : UIImageView = {
        
        let pv = UIImageView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = .clear
        pv.contentMode = .scaleAspectFill
        pv.isUserInteractionEnabled = true
        pv.layer.masksToBounds = true
        pv.clipsToBounds = true
        pv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.checkForGalleryAuth)))

        return pv
    }()
    
    
    lazy var nameTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: dividerGrey])
        etfc.attributedPlaceholder = placeholder
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
        etfc.layer.borderColor = dividerGrey.cgColor
        etfc.layer.borderWidth = 0.5
        etfc.isUserInteractionEnabled = true
        etfc.addTarget(self, action: #selector(self.handleManualScrolling), for: .touchDown)
        
        return etfc
        
    }()
    
    lazy var breedTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Breed", attributes: [NSAttributedString.Key.foregroundColor: dividerGrey])
        etfc.attributedPlaceholder = placeholder
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
        etfc.layer.borderColor = dividerGrey.cgColor
        etfc.layer.borderWidth = 0.5
        etfc.addTarget(self, action: #selector(self.handleManualScrolling), for: .touchDown)
        etfc.addTarget(self, action: #selector(self.monitorChangesForBreed(textField:)), for: .editingChanged)

        return etfc
        
    }()
    
    lazy var ageTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Birthday", attributes: [NSAttributedString.Key.foregroundColor: dividerGrey])
        etfc.attributedPlaceholder = placeholder
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
        etfc.layer.borderColor = dividerGrey.cgColor
        etfc.layer.borderWidth = 0.5
        etfc.isUserInteractionEnabled = false
        etfc.addTarget(self, action: #selector(self.handleManualScrolling), for: .touchDown)

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
        hbo.backgroundColor = dividerGrey.withAlphaComponent(0.5)
        return hbo
    }()
    
    let headerBarThree : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = dividerGrey.withAlphaComponent(0.5)
        return hbo
    }()
    
    let headerBarFour : UIView = {
        
        let hbo = UIView()
        hbo.translatesAutoresizingMaskIntoConstraints = false
        hbo.backgroundColor = dividerGrey.withAlphaComponent(0.5)
        return hbo
    }()
    
    let timeCover : UIView = {
        
        let tc = UIView()
        tc.translatesAutoresizingMaskIntoConstraints = false
        tc.backgroundColor = coreBackgroundWhite
        
        return tc
    }()
    
    lazy var toolBar : UIToolbar = {
        
        let bar = UIToolbar()
        
        let upImage = UIImage(named : "toolbarUpArrow")?.withRenderingMode(.alwaysOriginal)
        let downImage = UIImage(named : "toolBarDownArrow")?.withRenderingMode(.alwaysOriginal)
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.handleNextArrowButton))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        bar.items = [flexButton,next]
        bar.backgroundColor = coreWhiteColor
        bar.sizeToFit()
        
        return bar
        
    }()
    
    lazy var datePicker : UIDatePicker = {
        
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        let minus20Years = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
        let minusEightWeeks = Calendar.current.date(byAdding: .month, value: -2, to: Date())!
        dp.minimumDate = minus20Years
        dp.maximumDate = minusEightWeeks
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .automatic
        dp.tintColor = dividerGrey
        dp.backgroundColor = dividerGrey
        dp.alpha = 0.1
        dp.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
        return dp
        
    }()
    
    lazy var predictionLabel : UILabel = {
        
        let pl = UILabel()
        pl.translatesAutoresizingMaskIntoConstraints = false
        pl.textColor = coreBlackColor
        pl.font = UIFont(name: dsSubHeaderFont, size: 14)
        pl.textAlignment = .center
        pl.isUserInteractionEnabled = true
        pl.clipsToBounds = true
        pl.layer.masksToBounds = true
        pl.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        pl.layer.shadowOpacity = 0.05
        pl.layer.shadowOffset = CGSize(width: 2, height: 3)
        pl.layer.shadowRadius = 9
        pl.layer.shouldRasterize = false
        pl.layer.borderColor = dividerGrey.cgColor
        pl.layer.borderWidth = 0.5
        pl.backgroundColor = coreGreenColor.withAlphaComponent(0.2)
        pl.isHidden = true
        pl.layer.cornerRadius = 10
        pl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedPrediction)))
       return pl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
        //SET TEXTFIELD CONTENT TYPES
        self.nameTextField.textContentType = UITextContentType(rawValue: "")
        self.breedTextField.textContentType = UITextContentType(rawValue: "")
        self.ageTextField.textContentType = UITextContentType(rawValue: "")
        
        self.nameTextField.inputAccessoryView = self.toolBar
        self.breedTextField.inputAccessoryView = self.toolBar
        self.ageTextField.inputAccessoryView = self.toolBar
        
        self.scrollView.keyboardDismissMode = .interactive
        
        self.dogBreedJson = self.dogBreedJsonGrabber.dogBreedJSON
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
        self.scrollView.addSubview(self.basicDetailsLabel)
        self.scrollView.addSubview(self.profileImageViewContainer)
        self.scrollView.addSubview(self.profileImageView)
        self.scrollView.addSubview(self.pencilIconButton)
        self.scrollView.addSubview(self.datePicker)

        self.scrollView.addSubview(self.nameTextField)
        self.scrollView.addSubview(self.breedTextField)
        self.scrollView.addSubview(self.ageTextField)
        self.scrollView.addSubview(self.predictionLabel)

        self.scrollView.addSubview(self.nextButton)
        
        self.view.addSubview(timeCover)
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.5)
        
        let screenHeight = UIScreen.main.bounds.height
        print("Screen height: \(screenHeight)")
        
        switch screenHeight {
        
        //MANUAL CONFIGURATION - REFACTOR FOR UNNIVERSAL FITMENT
        case 926 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.0)
        case 896 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.0)
        case 844 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.02)
        case 812 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.03)
        case 736 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.11)
        case 667 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.21)
        case 568 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.21)
        case 480 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.21)
            
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
        self.basicDetailsLabel.leftAnchor.constraint(equalTo: self.cancelButton.leftAnchor, constant: 22).isActive = true
        self.basicDetailsLabel.sizeToFit()
        
        self.stackView.centerYAnchor.constraint(equalTo: self.basicDetailsLabel.centerYAnchor, constant: 0).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.headerContainer.rightAnchor, constant: -30).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        self.stackView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.profileImageViewContainer.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 21).isActive = true
        self.profileImageViewContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.profileImageViewContainer.heightAnchor.constraint(equalToConstant: 98).isActive = true
        self.profileImageViewContainer.widthAnchor.constraint(equalToConstant: 98).isActive = true
        self.profileImageViewContainer.layer.cornerRadius = 98/2
        
        self.profileImageView.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 21).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 98).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 98).isActive = true
        self.profileImageView.layer.cornerRadius = 98/2
        
        self.pencilIconButton.centerYAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: -16).isActive = true
        self.pencilIconButton.centerXAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: -16).isActive = true
        self.pencilIconButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        self.pencilIconButton.widthAnchor.constraint(equalToConstant: 23).isActive = true
        self.pencilIconButton.layer.cornerRadius = 23/2
        
        self.nameTextField.topAnchor.constraint(equalTo: self.profileImageViewContainer.bottomAnchor, constant: 25).isActive = true
        self.nameTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.nameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.nameTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.breedTextField.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 20).isActive = true
        self.breedTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.breedTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.breedTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.ageTopConstraint = self.ageTextField.topAnchor.constraint(equalTo: self.breedTextField.bottomAnchor, constant: 20)
        self.ageTopConstraint?.isActive = true
        self.ageTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.ageTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.ageTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.timeCover.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.timeCover.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.timeCover.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.timeCover.heightAnchor.constraint(equalToConstant: globalStatusBarHeight).isActive = true
        
        self.datePicker.topAnchor.constraint(equalTo: self.ageTextField.topAnchor, constant: 0).isActive = true
        self.datePicker.leftAnchor.constraint(equalTo: self.ageTextField.leftAnchor, constant: 0).isActive = true
        self.datePicker.rightAnchor.constraint(equalTo: self.ageTextField.rightAnchor, constant: 0).isActive = true
        self.datePicker.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.predictionLabel.topAnchor.constraint(equalTo: self.breedTextField.bottomAnchor, constant: 5).isActive = true
        self.predictionLabel.leftAnchor.constraint(equalTo: self.breedTextField.leftAnchor, constant: 0).isActive = true
        self.predictionLabel.rightAnchor.constraint(equalTo: self.breedTextField.rightAnchor, constant: 0).isActive = true
        self.predictionLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func adjustAgeConstraint(moveDown : Bool) {
        
        if moveDown {
            UIView.animate(withDuration: 0.25) {
                self.ageTopConstraint?.constant = 60
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.ageTopConstraint?.constant = 20
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func resignation() {
        
        self.nameTextField.resignFirstResponder()
        self.breedTextField.resignFirstResponder()
        self.ageTextField.resignFirstResponder()
        
    }
    
    @objc func tappedPrediction() {
        
        if self.predictionString != "" {
            self.breedTextField.text = self.predictionString
            self.predictionLabel.isHidden = true
            self.adjustAgeConstraint(moveDown: false)
        }
    }
    
    @objc func monitorChangesForBreed(textField : UITextField) {
        
        guard let text = self.breedTextField.text else {return}
        
        if text.count > 0 {

            let matchingTerms = self.dogBreedJson.filter({
                $0.range(of: text, options: .caseInsensitive) != nil
            })
            
            if matchingTerms.count > 0 {
                self.predictionLabel.text = matchingTerms[0]
                self.predictionString = matchingTerms[0]
                self.adjustAgeConstraint(moveDown: true)
                self.predictionLabel.isHidden = false

            } else {
                self.predictionLabel.text = ""
                self.predictionString = ""
                self.adjustAgeConstraint(moveDown: false)
                self.predictionLabel.isHidden = true

            }
            print(matchingTerms)
        } else {
            self.predictionLabel.text = ""
            self.predictionString = ""
            self.adjustAgeConstraint(moveDown: false)
            self.predictionLabel.isHidden = true

        }
    }
    
    
    @objc func handleDatePicker(sender: UIDatePicker) {
          
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sender.date)
        let month = dateComponents.month ?? 0
        let day = dateComponents.day ?? 0
        let year = dateComponents.year ?? 0
        
        var dayFixed : String = "\(day)"
        var monthFixed : String = "\(month)"

        if day < 10 {
            dayFixed = "0\(day)"
        }
        
        if month < 10 {
            monthFixed = "0\(month)"
        }
        
        self.selectedDate = "\(year)-\(monthFixed)-\(dayFixed)"
        print("Selected date: ", selectedDate)
        self.ageTextField.text = self.selectedDate
          
      }
    
    @objc func handleManualScrolling(sender : UITextField) {
        
        if sender == self.nameTextField {
            
            self.scrollView.scrollToTop()
            
        } else if sender == self.breedTextField {
            
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
        } else if sender == self.ageTextField {
            
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.resignation()
        self.scrollView.scrollToTop()
        return false
        
    }
    
    @objc func handleNextArrowButton() {
        
        if self.nameTextField.isFirstResponder {
            
            self.nameTextField.resignFirstResponder()
            self.breedTextField.becomeFirstResponder()
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
        } else if breedTextField.isFirstResponder {
            
            self.breedTextField.resignFirstResponder()
            self.ageTextField.becomeFirstResponder()
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
        } else if ageTextField.isFirstResponder {
            
            self.ageTextField.resignFirstResponder()
            self.nameTextField.becomeFirstResponder()
            self.scrollView.scrollToTop()
            
        }
    }
    
    @objc func handleBackButton() {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNextButton() {
        
        guard let dogName = self.nameTextField.text else {
            print("Guarded empty dog")
            return
        }
        guard let dogBreed = self.breedTextField.text else {
            print("Guarded breed")
            return
            
        }
        guard let dogBirthday = self.ageTextField.text else {
            print("Guarded birthday")
            return
        }
        
        let safeName = dogName.trimmingCharacters(in: .whitespacesAndNewlines)
        let safeBreed = dogBreed.trimmingCharacters(in: .whitespacesAndNewlines)
        let safeBirthday = dogBirthday.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if safeName.count > 1 {
            if safeBreed.count > 1 {
                if safeBirthday.count > 1 {
                    if self.selectedImage != nil {
                    
                    //PROFILE BUILDER, NEEDS TO BE CALLED EVERYTIME A USER MOVES FORWARD
                    globalNewDogBuilder.dogBuilderName = safeName
                    globalNewDogBuilder.dogBuilderBreed = safeBreed
                    globalNewDogBuilder.dogBuilderBirthday = safeBirthday
                    globalNewDogBuilder.dogBuilderProfileImage = self.selectedImage
                    
                    UIDevice.vibrateLight()

                    let newDogTwo = NewDogTwo()
                    newDogTwo.modalPresentationStyle = .fullScreen
                    newDogTwo.navigationController?.navigationBar.isHidden = true
                    self.navigationController?.pushViewController(newDogTwo, animated: true)
                        
                    } else {
                        self.presentAlertOnMainThread(title: "Profile photo", message: "Please add a photo of your pup.", buttonTitle: "Ok")
                    }
                    
                } else {
                    self.presentAlertOnMainThread(title: "Birthday", message: "Seems incorrect. Please try again.", buttonTitle: "Ok")
                }
            } else {
                self.presentAlertOnMainThread(title: "Breed", message: "Seems incorrect. Please try again.", buttonTitle: "Ok")
            }
        } else {
            self.presentAlertOnMainThread(title: "Name", message: "Please make sure your pup's name is at least two characters.", buttonTitle: "Ok")
        }
    }
}

import AVFoundation
import MobileCoreServices
import Photos


extension NewDogOne : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                    
                    self.profileImageView.image = editedImage
                    self.selectedImage = editedImage
                    
                    UIDevice.vibrateLight()
                    
                    
                } else if let originalImage = info[.originalImage] as? UIImage  {
                   
                    self.profileImageView.image = originalImage
                    self.selectedImage = originalImage
                    
                    UIDevice.vibrateLight()

                    
                } else {
                    print("Failed grabbing the photo")
                }
                
            default : print("SHOULD NOT HIT FOR THE CAMERA PICKER")
                
            }
        }
    }
}








