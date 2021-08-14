//
//  NewDogThree.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/28/21.
//

import Foundation
import UIKit

class NewDogThree : UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    var dogTreatJsonGrabber = DogTreatHelper(),
        dogTreatJson : [String] = [],
        predictionStringTreat : String = "",
        
        dogFoodJsonGrabber = DogFoodHelper(),
        dogFoodJson : [String] = [],
        predictionStringFood : String = ""
    
    lazy var newDogTreatSubview : NewDogTreatSubview = {
        
        let ndsb = NewDogTreatSubview(frame: .zero)
        ndsb.newDogThree = self
        ndsb.isHidden = true
        return ndsb
        
    }()
    
    lazy var newDogFoodSubview : NewDogFoodSubview = {
        
        let ndsb = NewDogFoodSubview(frame: .zero)
        ndsb.newDogThree = self
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
    
    lazy var favoriteTreatTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.placeholder = "Search by keyword or name"
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
        
        let image = UIImage(named: "magnifyingGlass")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
        imageView.contentMode = .center
        etfc.contentMode = .center
        imageView.image = image
        etfc.leftView = imageView
        
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
        
        etfc.addTarget(self, action: #selector(self.handleTreatTap), for: .touchDown)


        return etfc
        
    }()
    
    lazy var dogFoodTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.placeholder = "Search by keyword or name"
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
        
        let image = UIImage(named: "magnifyingGlass")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
        imageView.contentMode = .center
        etfc.contentMode = .center
        imageView.image = image
        etfc.leftView = imageView
        
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
        
        etfc.addTarget(self, action: #selector(self.handleFoodTap), for: .touchDown)

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
    
    let treatLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Favorite treat"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    let foodLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Dog food"
        nl.font = UIFont(name: rubikMedium, size: 21)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
       return nl
    }()
    
    @objc func handleTreatTap() {
        
        self.resignation()
        self.newDogTreatSubview.isHidden = false
        self.newDogTreatSubview.moveConstraints()
        
        UIView.animate(withDuration: 0.2) {
            self.newDogTreatSubview.alpha = 1
        }
    }
    
    @objc func handleFoodTap() {
        
        self.resignation()
        self.newDogFoodSubview.isHidden = false
        self.newDogFoodSubview.moveConstraints()
        
        UIView.animate(withDuration: 0.2) {
            self.newDogFoodSubview.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        self.fillValues()
        
        self.dogTreatJson = self.dogTreatJsonGrabber.dogTreatJSON
        self.dogFoodJson = self.dogFoodJsonGrabber.dogFoodJSON
        
        //SET TEXTFIELD CONTENT TYPES
        self.favoriteTreatTextField.textContentType = UITextContentType(rawValue: "")
        self.dogFoodTextField.textContentType = UITextContentType(rawValue: "")

        self.favoriteTreatTextField.setUpImage(imageName: "magnifyingGlass", on: .left)
        self.dogFoodTextField.setUpImage(imageName: "magnifyingGlass", on: .left)
        
        self.favoriteTreatTextField.inputView = UIView()
        self.dogFoodTextField.inputView = UIView()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.favoriteTreatTextField.endEditing(true)
        self.dogFoodTextField.endEditing(true)
    }
    
    func fillValues() {
        
        
        //SET TEXTFIELD CONTENT TYPES
        self.favoriteTreatTextField.textContentType = UITextContentType(rawValue: "")
        self.dogFoodTextField.textContentType = UITextContentType(rawValue: "")
        
        self.favoriteTreatTextField.inputAccessoryView = self.toolBar
        self.dogFoodTextField.inputAccessoryView = self.toolBar
        
        self.scrollView.keyboardDismissMode = .interactive
        
        let dogsName = globalNewDogBuilder.dogBuilderName ?? "Dog"
        self.basicDetailsLabel.text = "\(dogsName)'s Foodz"
        
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
        
        self.scrollView.addSubview(self.treatLabel)
        self.scrollView.addSubview(self.foodLabel)

        self.scrollView.addSubview(self.favoriteTreatTextField)
        self.scrollView.addSubview(self.dogFoodTextField)
        
        self.scrollView.addSubview(self.nextButton)
        
        self.view.addSubview(timeCover)
        self.view.addSubview(newDogTreatSubview)
        self.view.addSubview(newDogFoodSubview)

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
        case 844 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.02)
        case 812 : scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.001)
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
        self.basicDetailsLabel.leftAnchor.constraint(equalTo: self.cancelButton.leftAnchor, constant: 22).isActive = true
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
        
        self.treatLabel.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 48).isActive = true
        self.treatLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.treatLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.treatLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.favoriteTreatTextField.topAnchor.constraint(equalTo: self.treatLabel.bottomAnchor, constant: 20).isActive = true
        self.favoriteTreatTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.favoriteTreatTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.favoriteTreatTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.foodLabel.topAnchor.constraint(equalTo: self.favoriteTreatTextField.bottomAnchor, constant: 25).isActive = true
        self.foodLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.foodLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.foodLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.dogFoodTextField.topAnchor.constraint(equalTo: self.foodLabel.bottomAnchor, constant: 20).isActive = true
        self.dogFoodTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.dogFoodTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.dogFoodTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.newDogTreatSubview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.newDogTreatSubview.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.newDogTreatSubview.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.newDogTreatSubview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.newDogFoodSubview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.newDogFoodSubview.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.newDogFoodSubview.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.newDogFoodSubview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

    }
    
    @objc func fillBreed(breedType : String) {
        
        self.favoriteTreatTextField.text = breedType
        self.newDogTreatSubview.breedTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.025) {
            self.newDogTreatSubview.alpha = 0
        }
    }
    
    @objc func fillDogs(breedType : String) {
        
        self.dogFoodTextField.text = breedType
        self.newDogFoodSubview.breedTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.025) {
            self.newDogFoodSubview.alpha = 0
        }
    }
    
    func resignation() {
        
        self.favoriteTreatTextField.resignFirstResponder()
        self.dogFoodTextField.resignFirstResponder()
    }
    
    @objc func handleManualScrolling(sender : UITextField) {
       
        if sender == self.favoriteTreatTextField {
        
            self.scrollView.scrollToTop()
            
        } else if sender == self.dogFoodTextField {
            
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
        } else {
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.resignation()
        self.scrollView.scrollToTop()
        return false
        
    }
    
    @objc func handleNextArrowButton() {
        
        if self.favoriteTreatTextField.isFirstResponder {
            
            self.favoriteTreatTextField.resignFirstResponder()
            self.dogFoodTextField.becomeFirstResponder()
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)

        } else if dogFoodTextField.isFirstResponder {
            
            self.dogFoodTextField.resignFirstResponder()
            self.favoriteTreatTextField.becomeFirstResponder()

            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        
        }
    }
    
    @objc func handleBackButton() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNextButton() {
        
        guard let favoriteTreat = self.favoriteTreatTextField.text else {return}
        guard let favoriteFood = self.dogFoodTextField.text else {return}
        
        let cleanTreat = favoriteTreat.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanFood = favoriteFood.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanTreat.count > 2 {
            if cleanFood.count > 2 {
                
                globalNewDogBuilder.dogBuilderFavoriteTreat = cleanTreat
                globalNewDogBuilder.dogBuilderFavoriteFood = cleanFood
                
                self.moveToNewDogFour()
                
            } else {
                presentAlertOnMainThread(title: "Treat", message: "Please make sure the treat is more than two characters.", buttonTitle: "ok")
            }
            
        } else {
            presentAlertOnMainThread(title: "Treat", message: "Please make sure the treat is more than two characters.", buttonTitle: "ok")
        }
    }
    
    @objc func moveToNewDogFour() {
        
        UIDevice.vibrateLight()

        let newDogTwo = NewDogFour()
        newDogTwo.modalPresentationStyle = .fullScreen
        newDogTwo.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(newDogTwo, animated: true)
        
    }
}
