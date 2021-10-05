//
//  NewDogOne.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/28/21.
//

import Foundation
import UIKit

class NewDogOne : UIViewController, UITextFieldDelegate, UIScrollViewDelegate, CustomAlertCallBackProtocol {
    
    var selectedDate : String = "",
        dogBreedJsonGrabber = DogBreed(),
        dogBreedJson : [String] = [],
        predictionString : String = "",
        selectedImage : UIImage?,
        isSelectedNameChosen : Bool = false,
        isKeyboardShowing : Bool = false,
        lastKeyboardHeight : CGFloat = 0.0,
        contentHeight : CGFloat = 645.0
    
    lazy var newDogSearchBreedSubview : NewDogSearchBreedSubview = {
        
        let ndsb = NewDogSearchBreedSubview(frame: .zero)
        ndsb.newDogOne = self
        ndsb.isHidden = true
        return ndsb
        
    }()
    
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
    
    let contentView : UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.isUserInteractionEnabled = true
        return cv
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
        let placeholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
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
        etfc.layer.borderColor = dividerGrey.withAlphaComponent(0.2).cgColor
        etfc.layer.borderWidth = 1.0
        etfc.layer.cornerRadius = 10
        
        return etfc
        
    }()
    
    lazy var breedTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Breed", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
        etfc.attributedPlaceholder = placeholder
        etfc.textAlignment = .left
        etfc.backgroundColor = coreWhiteColor
        etfc.textColor = UIColor .darkGray.withAlphaComponent(1.0)
        etfc.font = UIFont(name: rubikRegular, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.layer.masksToBounds = true
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        
        etfc.leftViewMode = .always
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))

        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.layer.borderColor = dividerGrey.withAlphaComponent(0.2).cgColor
        etfc.layer.borderWidth = 1.0
        etfc.layer.cornerRadius = 10
        
        etfc.addTarget(self, action: #selector(self.handleBreedTap), for: .touchDown)
        
        return etfc
        
    }()
    
    
    lazy var ageTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: "Birthday (or guesstimate)", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
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
        etfc.layer.borderColor = dividerGrey.withAlphaComponent(0.2).cgColor
        etfc.layer.borderWidth = 1.0
        etfc.layer.cornerRadius = 10
        etfc.isUserInteractionEnabled = false
        
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
    
    lazy var toolBar : UIToolbar = {
        
        let bar = UIToolbar()
        
        let upImage = UIImage(named : "toolbarUpArrow")?.withRenderingMode(.alwaysOriginal)
        let downImage = UIImage(named : "toolBarDownArrow")?.withRenderingMode(.alwaysOriginal)
        let next = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.handleNextArrowButton))
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
        //MARK: - SET TEXTFIELD CONTENT TYPES
        self.nameTextField.textContentType = UITextContentType(rawValue: "")
        self.breedTextField.textContentType = UITextContentType(rawValue: "")
        self.ageTextField.textContentType = UITextContentType(rawValue: "")
        
        self.nameTextField.inputAccessoryView = self.toolBar
        self.breedTextField.inputAccessoryView = self.toolBar
        self.ageTextField.inputAccessoryView = self.toolBar
        
        self.scrollView.keyboardDismissMode = .interactive
        self.dogBreedJson = self.dogBreedJsonGrabber.dogBreedJSON
        self.breedTextField.inputView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.breedTextField.endEditing(true)
        self.ageTextField.endEditing(true)
    }
    
    @objc func handleBreedTap() {
        
        self.resignation()
        self.newDogSearchBreedSubview.isHidden = false
        self.newDogSearchBreedSubview.moveConstraints()
        
        UIView.animate(withDuration: 0.2) {
            self.newDogSearchBreedSubview.alpha = 1
        }
    }
    
    func addViews() {
        
        self.view.addSubview(scrollView)
        
        self.scrollView.addSubview(self.contentView)
        
        self.contentView.addSubview(self.stackView)

        self.stackView.addArrangedSubview(self.headerBarOne)
        self.stackView.addArrangedSubview(self.headerBarTwo)
        self.stackView.addArrangedSubview(self.headerBarThree)
        self.stackView.addArrangedSubview(self.headerBarFour)
        
        self.contentView.addSubview(self.headerContainer)
        self.contentView.addSubview(self.cancelButton)
        self.contentView.addSubview(self.basicDetailsLabel)
        self.contentView.addSubview(self.profileImageViewContainer)
        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.pencilIconButton)
        self.contentView.addSubview(self.datePicker)
        
        self.contentView.addSubview(self.nameTextField)
        self.contentView.addSubview(self.breedTextField)
        self.contentView.addSubview(self.ageTextField)
        
        self.contentView.addSubview(self.nextButton)
        
        self.view.addSubview(timeCover)
        self.view.addSubview(self.newDogSearchBreedSubview)
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.contentHeight + self.lastKeyboardHeight)
        
        self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 0).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor, constant: 0).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.contentView.heightAnchor.constraint(equalToConstant: 635).isActive = true
        
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
        
        self.ageTextField.topAnchor.constraint(equalTo: self.breedTextField.bottomAnchor, constant: 20).isActive = true
        self.ageTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.ageTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.ageTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.nextButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
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
        
        self.newDogSearchBreedSubview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.newDogSearchBreedSubview.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.newDogSearchBreedSubview.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.newDogSearchBreedSubview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
    }
    
    @objc func adjustContentSize() {
        
        self.scrollView.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.contentHeight + self.lastKeyboardHeight)
        self.scrollView.scrollToBottom()
        
    }
    
    @objc func handleKeyboardShow(notification : Notification) {
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        if keyboardRectangle.height > 200 {
            
            if self.isKeyboardShowing == true {return}
            self.isKeyboardShowing = true
            
            self.lastKeyboardHeight = keyboardRectangle.height
            self.perform(#selector(self.handleKeyboardMove), with: nil, afterDelay: 0.1)
            
        }
    }
    
    @objc func handleKeyboardHide(notification : Notification) {
        
        self.isKeyboardShowing = false
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        self.lastKeyboardHeight = keyboardRectangle.height
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.contentHeight)
    }
    
    @objc func handleKeyboardMove() {
        self.adjustContentSize()
    }
    
    func resignation() {
        
        self.nameTextField.resignFirstResponder()
        self.breedTextField.resignFirstResponder()
        self.ageTextField.resignFirstResponder()
        
    }
    
    @objc func tappedPrediction() {
        
        if self.predictionString != "" {
            self.breedTextField.text = self.predictionString
            self.isSelectedNameChosen = true
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
        self.ageTextField.text = self.selectedDate
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.resignation()
        self.scrollView.scrollToTop()
        return false
        
    }
    
    @objc func handleNextArrowButton() {
        
        self.resignation()
        self.scrollView.scrollToTop()
        
    }
    
    @objc func fillBreed(breedType : String) {
        
        self.breedTextField.text = breedType
        self.isSelectedNameChosen = true
        self.newDogSearchBreedSubview.breedTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.025) {
            self.newDogSearchBreedSubview.alpha = 0
        }
    }
    
    @objc func handleBackButton() {
            self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNextButton() {
        
        guard let dogName = self.nameTextField.text else {return}
        guard let dogBreed = self.breedTextField.text else {return}
        guard let dogBirthday = self.ageTextField.text else {return}
        
        let safeName = dogName.trimmingCharacters(in: .whitespacesAndNewlines)
        let safeBreed = dogBreed.trimmingCharacters(in: .whitespacesAndNewlines)
        let safeBirthday = dogBirthday.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if safeName.count > 1 {
            if safeBreed.count > 1 {
                if safeBirthday.count > 1 {
                    if self.selectedImage != nil {
                        if self.isSelectedNameChosen == true {
                            
                            //MARK: - PROFILE BUILDER, NEEDS TO BE CALLED EVERYTIME A USER MOVES FORWARD
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
                            self.handleCustomPopUpAlert(title: "BREED", message: "Please select a pre-populated breed.", passedButtons: [Statics.OK])
                        }
                    } else {
                        self.handleCustomPopUpAlert(title: "PROFILE PHOTO", message: "Please add a photo of your pup.", passedButtons: [Statics.OK])
                    }
                } else {
                    self.handleCustomPopUpAlert(title: "BIRTHDAY", message: "Seems incorrect. Please try again.", passedButtons: [Statics.OK])
                }
            } else {
                self.handleCustomPopUpAlert(title: "BREED", message: "Seems incorrect. Please try again.", passedButtons: [Statics.OK])
            }
        } else {
            self.handleCustomPopUpAlert(title: "NAME", message: "Please make sure your pup's name is at least two characters.", passedButtons: [Statics.OK])
        }
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
}

import AVFoundation
import MobileCoreServices
import Photos

extension NewDogOne : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func checkForGalleryAuth() {
        
        UIDevice.vibrateLight()
        self.resignation()
        
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
        
        default :
            self.handleCustomPopUpAlert(title: "PERMISSIONS", message: "Please allow Photo Library Permissions in the Settings application.", passedButtons: [Statics.OK])
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
            print("DISMISSED")
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
                    print("PHOTO GRAB FAILURE")
                }
                
            default : print("SHOULD NOT HIT FOR THE CAMERA PICKER")
                
            }
        }
    }
}








