//
//  AppointmentThreeContainer.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/23/21.
//

import Foundation
import UIKit


class AppointmentThreeContainer : UIView, UITextFieldDelegate, UITextViewDelegate {
    
    var appointmentThree : AppointmentThree?
    
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
    
    let circleView : UIButton = {
        
        let co = UIButton(type: .system)
        co.translatesAutoresizingMaskIntoConstraints = false
        co.layer.masksToBounds = true
        co.layer.cornerRadius = 15
        co.layer.borderWidth = 4
        co.layer.borderColor = circleGrey.cgColor
        co.layer.cornerRadius = 29/2
        co.isUserInteractionEnabled = false
        co.titleLabel?.font = UIFont.fontAwesome(ofSize: 21, style: .solid)
        co.setTitle(String.fontAwesomeIcon(name: .checkCircle), for: .normal)
        co.setTitleColor(coreOrangeColor, for: .normal)
        co.backgroundColor = .clear

        return co
    }()
    
    let selectionDescription : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = ""
        nl.font = UIFont(name: rubikMedium, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        nl.isUserInteractionEnabled = false
        
       return nl
    }()
    
    lazy var selectionContainerOne : UIView = {
        
        let co = UIView()
        co.translatesAutoresizingMaskIntoConstraints = false
        co.backgroundColor = coreWhiteColor
        co.layer.masksToBounds = false
        co.layer.cornerRadius = 15
        co.isUserInteractionEnabled = false
        
        co.layer.borderWidth = 0.5
        co.layer.borderColor = coreOrangeColor.cgColor
        co.layer.shadowColor = coreOrangeColor.cgColor
        co.layer.shadowOpacity = 0.3
        co.layer.shadowOffset = CGSize(width: 0, height: 0)
        co.layer.shadowRadius = 4
        co.layer.shouldRasterize = false
        co.isUserInteractionEnabled = true
        co.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleRevert)))

       return co
    }()
    
    let pickupLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Enter pick up/drop off details:"
        nl.font = UIFont(name: rubikRegular, size: 16)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = 1
        
       return nl
    }()
    
    lazy var apartmentTextField: UITextField = {
        
        let etfc = UITextField()
        let placeholder = NSAttributedString(string: "Apt. #", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont(name: rubikMedium, size: 18)!])
        etfc.attributedPlaceholder = placeholder
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikMedium, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .decimalPad
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 10
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
        etfc.addTarget(self, action: #selector(self.handleApartmentTap), for: .touchDown)
        
        return etfc
        
    }()
    
    lazy var buzzerCodeTextField: UITextField = {
        
        let etfc = UITextField()
        let placeholder = NSAttributedString(string: "Buzzer code", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont(name: rubikMedium, size: 18)!])
        etfc.attributedPlaceholder = placeholder
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikMedium, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .default
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 10
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
        etfc.addTarget(self, action: #selector(self.handleBuzzerTap), for: .touchDown)

        return etfc
        
    }()
    
    
    lazy var notesTextView: UITextView = {
        
        let etfc = UITextView()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .left
        etfc.textColor = coreBlackColor
        etfc.font = UIFont(name: rubikMedium, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = coreWhiteColor
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = .default
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 10
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isUserInteractionEnabled = true
        etfc.contentInset = UIEdgeInsets(top: 8, left: 17, bottom: 8, right: 17)
        etfc.clipsToBounds = true
        etfc.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleNotesTouch)))
        
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
        cbf.isHidden = false
        cbf.addTarget(self, action: #selector(self.handleNextButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    let textviewPlaceholder : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Additional notes (optional)"
        nl.font = UIFont(name: rubikMedium, size: 18)
        nl.textColor = dsFlatBlack.withAlphaComponent(0.4)
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        nl.numberOfLines = -1
        nl.isUserInteractionEnabled = false
        
       return nl
    }()
    
    lazy var toolBar : UIToolbar = {
        
        let bar = UIToolbar()
        
        let upImage = UIImage(named : "toolbarUpArrow")?.withRenderingMode(.alwaysOriginal)
        let downImage = UIImage(named : "toolBarDownArrow")?.withRenderingMode(.alwaysOriginal)
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.handleNextField))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        bar.items = [flexButton,next]
        bar.backgroundColor = coreWhiteColor
        bar.sizeToFit()
        
        return bar
        
    }()
    
    @objc func handleNextField() {
        
        if self.apartmentTextField.isFirstResponder {
            self.apartmentTextField.resignFirstResponder()
            self.buzzerCodeTextField.becomeFirstResponder()
            self.scrollView.scrollToBottom()
        } else if self.buzzerCodeTextField.isFirstResponder {
            self.buzzerCodeTextField.resignFirstResponder()
            self.notesTextView.becomeFirstResponder()
            self.scrollView.scrollToBottom()
            self.textviewPlaceholder.isHidden = true
        } else if self.notesTextView.isFirstResponder {
            self.notesTextView.resignFirstResponder()
            self.apartmentTextField.becomeFirstResponder()
            self.scrollView.scrollToTop()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.keyboardDismissMode = .interactive
        self.addViews()
        
        //SET TEXTFIELD CONTENT TYPES
        self.apartmentTextField.textContentType = UITextContentType(rawValue: "")
        self.buzzerCodeTextField.textContentType = UITextContentType(rawValue: "")
        
        self.apartmentTextField.inputAccessoryView = toolBar
        self.buzzerCodeTextField.inputAccessoryView = toolBar
        self.notesTextView.inputAccessoryView = toolBar
        
        self.scrollView.keyboardDismissMode = .interactive

    }
    
    func fillText(passedText : String) {
        self.selectionDescription.text = passedText
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.resignation()
        
        return false
    }
    
    func addViews() {
        
        self.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.selectionContainerOne)
        self.selectionContainerOne.addSubview(self.circleView)
        self.selectionContainerOne.addSubview(self.selectionDescription)
        
        self.scrollView.addSubview(self.pickupLabel)
        self.scrollView.addSubview(self.apartmentTextField)
        self.scrollView.addSubview(self.buzzerCodeTextField)
        self.scrollView.addSubview(self.notesTextView)
        self.notesTextView.addSubview(self.textviewPlaceholder)
        self.scrollView.addSubview(self.nextButton)

        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        let screenHeight = UIScreen.main.bounds.height
        
        switch screenHeight {
        
        //MANUAL CONFIGURATION - REFACTOR FOR UNNIVERSAL FITMENT
        case 926 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 175)
        case 896 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 175)
        case 844 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 50)
        case 812 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        case 736 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 140)
        case 667 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 140)
        case 568 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 140)
        case 480 : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 140)
            
        default : scrollView.contentSize = CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.height * 1.5)
            
        }

        self.selectionContainerOne.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 25).isActive = true
        self.selectionContainerOne.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.selectionContainerOne.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.selectionContainerOne.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        self.circleView.centerYAnchor.constraint(equalTo: self.selectionContainerOne.centerYAnchor, constant: 0).isActive = true
        self.circleView.leftAnchor.constraint(equalTo: self.selectionContainerOne.leftAnchor, constant: 17).isActive = true
        self.circleView.heightAnchor.constraint(equalToConstant: 29).isActive = true
        self.circleView.widthAnchor.constraint(equalToConstant: 29).isActive = true

        self.selectionDescription.leftAnchor.constraint(equalTo: self.circleView.rightAnchor, constant: 10).isActive = true
        self.selectionDescription.rightAnchor.constraint(equalTo: self.selectionContainerOne.rightAnchor, constant: -30).isActive = true
        self.selectionDescription.topAnchor.constraint(equalTo: self.selectionContainerOne.topAnchor, constant: 0).isActive = true
        self.selectionDescription.bottomAnchor.constraint(equalTo: self.selectionContainerOne.bottomAnchor, constant: 0).isActive = true
        
        self.pickupLabel.topAnchor.constraint(equalTo: self.selectionContainerOne.bottomAnchor, constant: 30).isActive = true
        self.pickupLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.pickupLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.pickupLabel.sizeToFit()
        
        self.apartmentTextField.topAnchor.constraint(equalTo: self.pickupLabel.bottomAnchor, constant: 20).isActive = true
        self.apartmentTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.apartmentTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.apartmentTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.buzzerCodeTextField.topAnchor.constraint(equalTo: self.apartmentTextField.bottomAnchor, constant: 20).isActive = true
        self.buzzerCodeTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.buzzerCodeTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.buzzerCodeTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.notesTextView.topAnchor.constraint(equalTo: self.buzzerCodeTextField.bottomAnchor, constant: 20).isActive = true
        self.notesTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.notesTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.notesTextView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        self.textviewPlaceholder.topAnchor.constraint(equalTo: self.notesTextView.topAnchor, constant: 12).isActive = true
        self.textviewPlaceholder.leftAnchor.constraint(equalTo: self.notesTextView.leftAnchor, constant: 7).isActive = true
        self.textviewPlaceholder.rightAnchor.constraint(equalTo: self.notesTextView.rightAnchor, constant: -10).isActive = true
        self.textviewPlaceholder.sizeToFit()
        
        self.nextButton.topAnchor.constraint(equalTo: self.notesTextView.bottomAnchor, constant: 30).isActive = true
        self.nextButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        self.textviewPlaceholder.isHidden = true
        
        return true
    }
    
    @objc func resignation() {
        
        self.apartmentTextField.resignFirstResponder()
        self.buzzerCodeTextField.resignFirstResponder()
        self.notesTextView.resignFirstResponder()
    }
    
    @objc func handleApartmentTap() {
        self.scrollView.scrollToTop()
        self.apartmentTextField.becomeFirstResponder()
    }
    @objc func handleBuzzerTap() {
        self.scrollView.scrollToBottom()
        self.buzzerCodeTextField.becomeFirstResponder()
    }
    
    @objc func handleNotesTouch() {
        self.scrollView.scrollToBottom()
        self.textviewPlaceholder.isHidden = true
        self.notesTextView.becomeFirstResponder()
    }
    
    @objc func handleRevert() {
        
        self.appointmentThree?.appointmentThreeCollectionview.indexpathArray.removeAll()
        DispatchQueue.main.async {
            self.appointmentThree?.appointmentThreeCollectionview.reloadData()
        }
        self.appointmentThree?.appointmentThreeContainer.isHidden = true
        self.appointmentThree?.appointmentThreeCollectionview.isHidden = false
        self.resignation()
        
    }
    
    @objc func handleNextButton() {
        print("handle next button")
        self.appointmentThree?.handleNextButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
