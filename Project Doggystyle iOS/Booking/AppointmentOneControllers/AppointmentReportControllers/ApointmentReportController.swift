//
//  ApointmentReportController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/11/21.
//

import Foundation
import UIKit


class ApointmentReportController : UIViewController, UITextFieldDelegate {
    
    lazy var backButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreOrangeColor
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let leaveReviewLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Leave Review"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let ratingLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Rating"
        thl.font = UIFont(name: rubikSemiBold, size: 21)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    lazy var stackView : UIStackView = {
              
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalCentering
        sv.alignment = .leading
        sv.spacing = 2
        
        return sv
    }()
    
    lazy var starOne : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 41, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .star), for: .normal)
        cbf.setTitleColor(starGold, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleStarOne), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    lazy var starTwo : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 41, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .star), for: .normal)
        cbf.setTitleColor(dividerGrey, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleStarOne), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    lazy var starThree : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 41, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .star), for: .normal)
        cbf.setTitleColor(dividerGrey, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleStarOne), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    lazy var starFour : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 41, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .star), for: .normal)
        cbf.setTitleColor(dividerGrey, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleStarOne), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    lazy var starFive : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 41, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .star), for: .normal)
        cbf.setTitleColor(dividerGrey, for: .normal)
        cbf.addTarget(self, action: #selector(self.handleStarOne), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let yourCommentsLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Your comments"
        thl.font = UIFont(name: rubikSemiBold, size: 21)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let commentsTextView : UITextView = {
        
        let tv = UITextView()
        tv.backgroundColor = coreWhiteColor
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = coreBlackColor
        tv.textAlignment = .left
        tv.isUserInteractionEnabled = true
        tv.isScrollEnabled = true
        tv.alwaysBounceVertical = true
        tv.alwaysBounceHorizontal = false
        tv.text = "Rex is finally clean as a whistle! Thanks for taking such good care of him, I’m sure he’s looking forward to next month’s appointment."
        tv.font = UIFont(name: rubikRegular, size: 16)
        tv.isUserInteractionEnabled = true
        tv.isScrollEnabled = true
        tv.isEditable = false
        tv.isSelectable = true
        tv.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 15
        tv.clipsToBounds = false
        tv.layer.masksToBounds = false
        tv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        tv.layer.shadowOpacity = 0.05
        tv.layer.shadowOffset = CGSize(width: 2, height: 3)
        tv.layer.shadowRadius = 9
        tv.layer.shouldRasterize = false
        
        return tv
    }()
    
    let tiplabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Tip"
        thl.font = UIFont(name: rubikSemiBold, size: 21)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let tipSublabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Your tip means a lot to your stylist <3"
        thl.font = UIFont(name: rubikRegular, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    lazy var tipStackView : UIStackView = {
              
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalCentering
        sv.alignment = .leading
        sv.spacing = 5
        
        return sv
    }()
    
    lazy var tipAmountFive : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("$5", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 16)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dsFlatBlack.withAlphaComponent(0.4)
        cbf.backgroundColor = dividerGrey
        cbf.layer.cornerRadius = 10
        cbf.layer.masksToBounds = true
        cbf.tintColor = dsFlatBlack.withAlphaComponent(0.4)
        cbf.tag = 1
        cbf.addTarget(self, action: #selector(self.handleTipSelection(sender:)), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var tipAmountTen : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("$10", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 16)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dsFlatBlack.withAlphaComponent(0.4)
        cbf.backgroundColor = dividerGrey
        cbf.layer.cornerRadius = 10
        cbf.layer.masksToBounds = true
        cbf.tintColor = dsFlatBlack.withAlphaComponent(0.4)
        cbf.tag = 1
        cbf.addTarget(self, action: #selector(self.handleTipSelection(sender:)), for: .touchUpInside)
        
        return cbf
        
    }()
    
    lazy var tipAmountTwenty : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("$20", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 16)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = dsFlatBlack.withAlphaComponent(0.4)
        cbf.backgroundColor = dividerGrey
        cbf.layer.cornerRadius = 10
        cbf.layer.masksToBounds = true
        cbf.tintColor = dsFlatBlack.withAlphaComponent(0.4)
        cbf.tag = 1
        cbf.addTarget(self, action: #selector(self.handleTipSelection(sender:)), for: .touchUpInside)
        
        return cbf
        
    }()
   
    lazy var customAmountTextField: UITextField = {
        
        let etfc = UITextField()
        let placeholder = NSAttributedString(string: "Custom amount", attributes: [NSAttributedString.Key.foregroundColor: dsFlatBlack.withAlphaComponent(0.4)])
        etfc.attributedPlaceholder = placeholder
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.textAlignment = .center
        etfc.textColor = dsFlatBlack.withAlphaComponent(0.4)
        etfc.font = UIFont(name: dsHeaderFont, size: 16)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.backgroundColor = dividerGrey
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.done
        etfc.keyboardType = .alphabet
        etfc.layer.masksToBounds = true
        etfc.layer.cornerRadius = 10
        etfc.leftViewMode = .always
        etfc.layer.borderColor = UIColor.clear.cgColor
        etfc.layer.borderWidth = 1
        etfc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.isSecureTextEntry = false
        etfc.setRightPaddingPoints(50)
        
        return etfc
        
    }()
    
    lazy var submitButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Submit", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.addTarget(self, action: #selector(self.handleSubmitButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    @objc func handleTipSelection(sender : UIButton) {
        
        switch sender.tag {
        
        case 1: print("5 bucks")
        case 2: print("10 bucks")
        case 3: print("20 bucks")
        default:print("no such tip")
        
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.leaveReviewLabel)
        self.view.addSubview(self.ratingLabel)
        self.view.addSubview(self.stackView)

        self.stackView.addArrangedSubview(self.starOne)
        self.stackView.addArrangedSubview(self.starTwo)
        self.stackView.addArrangedSubview(self.starThree)
        self.stackView.addArrangedSubview(self.starFour)
        self.stackView.addArrangedSubview(self.starFive)
        
        self.view.addSubview(self.yourCommentsLabel)
        self.view.addSubview(self.commentsTextView)
        self.view.addSubview(self.tiplabel)
        self.view.addSubview(self.tipSublabel)

        self.view.addSubview(self.tipStackView)
        
        self.tipStackView.addArrangedSubview(self.tipAmountFive)
        self.tipStackView.addArrangedSubview(self.tipAmountTen)
        self.tipStackView.addArrangedSubview(self.tipAmountTwenty)
        
        self.view.addSubview(self.customAmountTextField)
        self.view.addSubview(self.submitButton)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.leaveReviewLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 15).isActive = true
        self.leaveReviewLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.leaveReviewLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.leaveReviewLabel.sizeToFit()
        
        self.ratingLabel.topAnchor.constraint(equalTo: self.leaveReviewLabel.bottomAnchor, constant: 23).isActive = true
        self.ratingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.ratingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.ratingLabel.sizeToFit()
        
        self.stackView.topAnchor.constraint(equalTo: self.ratingLabel.bottomAnchor, constant: 20).isActive = true
        self.stackView.leftAnchor.constraint(equalTo: self.leaveReviewLabel.leftAnchor, constant: 0).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.leaveReviewLabel.rightAnchor, constant: 0).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.starOne.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.starOne.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.starTwo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.starTwo.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.starThree.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.starThree.widthAnchor.constraint(equalToConstant: 50).isActive = true

        self.starFour.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.starFour.widthAnchor.constraint(equalToConstant: 50).isActive = true

        self.starFive.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.starFive.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.yourCommentsLabel.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 30).isActive = true
        self.yourCommentsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.yourCommentsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.yourCommentsLabel.sizeToFit()
        
        self.commentsTextView.topAnchor.constraint(equalTo: self.yourCommentsLabel.bottomAnchor, constant: 13).isActive = true
        self.commentsTextView.leftAnchor.constraint(equalTo: self.yourCommentsLabel.leftAnchor, constant: 0).isActive = true
        self.commentsTextView.rightAnchor.constraint(equalTo: self.yourCommentsLabel.rightAnchor, constant: 0).isActive = true
        self.commentsTextView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        
        self.tiplabel.topAnchor.constraint(equalTo: self.commentsTextView.bottomAnchor, constant: 25).isActive = true
        self.tiplabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.tiplabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.tiplabel.sizeToFit()
        
        self.tipSublabel.topAnchor.constraint(equalTo: self.tiplabel.bottomAnchor, constant: 8).isActive = true
        self.tipSublabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.tipSublabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.tipSublabel.sizeToFit()
        
        self.tipStackView.topAnchor.constraint(equalTo: self.tipSublabel.bottomAnchor, constant: 20).isActive = true
        self.tipStackView.leftAnchor.constraint(equalTo: self.leaveReviewLabel.leftAnchor, constant: 0).isActive = true
        self.tipStackView.rightAnchor.constraint(equalTo: self.leaveReviewLabel.rightAnchor, constant: 0).isActive = true
        self.tipStackView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.tipAmountFive.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.tipAmountFive.widthAnchor.constraint(equalToConstant: 104).isActive = true
        
        self.tipAmountTen.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.tipAmountTen.widthAnchor.constraint(equalToConstant: 104).isActive = true
        
        self.tipAmountTwenty.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.tipAmountTwenty.widthAnchor.constraint(equalToConstant: 104).isActive = true
        
        self.customAmountTextField.topAnchor.constraint(equalTo: self.tipStackView.bottomAnchor, constant: 10).isActive = true
        self.customAmountTextField.leftAnchor.constraint(equalTo: self.tipStackView.leftAnchor, constant: 0).isActive = true
        self.customAmountTextField.rightAnchor.constraint(equalTo: self.tipStackView.rightAnchor, constant: 0).isActive = true
        self.customAmountTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.submitButton.topAnchor.constraint(equalTo: self.customAmountTextField.bottomAnchor, constant: 10).isActive = true
        self.submitButton.leftAnchor.constraint(equalTo: self.customAmountTextField.leftAnchor, constant: 0).isActive = true
        self.submitButton.rightAnchor.constraint(equalTo: self.customAmountTextField.rightAnchor, constant: 0).isActive = true
        self.submitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

    }
    
    @objc func handleSubmitButton() {
        print("Submit button tapped")
    }
    
    @objc func handleStarOne() {
        print("star one here")
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
