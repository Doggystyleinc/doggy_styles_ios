//
//  PinNumberEntry.swift
//  DSGroomer
//
//  Created by Charlie Arcodia on 6/12/21.
//

import Foundation
import UIKit
import Firebase

final class PinNumberVerificationEntryController: UIViewController, UITextFieldDelegate, CustomAlertCallBackProtocol {
    
    let logo = LogoImageView(frame: .zero),
        mainLoadingScreen = MainLoadingScreen(),
        databaseRef = Database.database().reference()
    
    var phoneNumber: String!,
        countryCode: String!,
        firstName: String!,
        lastName: String!,
        email: String!,
        password: String!,
        pinTimer: Timer?,
        pinCounter: Int = 120,
        errorCounter = 0
    
    let cancelButton: UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .white
        cbf.layer.masksToBounds = true
        cbf.tintColor = .dsOrange
        cbf.clipsToBounds = false
        cbf.layer.masksToBounds = false
        cbf.layer.shadowOpacity = 1
        cbf.layer.shadowOffset = CGSize(width: 0, height: 4)
        cbf.layer.shadowRadius = 8
        cbf.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
        cbf.layer.shouldRasterize = false
        cbf.layer.cornerRadius = 4
        cbf.addTarget(self, action: #selector(handleCancelButton), for: UIControl.Event.touchUpInside)
        
        return cbf
        
    }()
    
    private let mainHeaderLabel = DSBoldLabel(title: "SMS Verification", size: 24)
    
    private lazy var subHeaderLabel = DSRegularLabel(title: "", size: 16)
    
    private let registerButton: DSButton = {
        let cbf = DSButton(titleText: "Send", backgroundColor: .dsOrange, titleColor: .white)
        cbf.addTarget(self, action: #selector(handleRegistrationButton), for: UIControl.Event.touchUpInside)
        return cbf
    }()
    
    private lazy var slotOneTextField: DSSMSTextField = {
        let etfc = DSSMSTextField()
        etfc.delegate = self
        etfc.addTarget(self, action: #selector(self.handleResponders(textField:)), for: UIControl.Event.editingChanged)
        return etfc
    }()
    
    private lazy var slotTwoTextField: DSSMSTextField = {
        let etfc = DSSMSTextField()
        etfc.delegate = self
        etfc.addTarget(self, action: #selector(self.handleResponders(textField:)), for: UIControl.Event.editingChanged)
        return etfc
    }()
    
    private lazy var slotThreeTextField: DSSMSTextField = {
        let etfc = DSSMSTextField()
        etfc.delegate = self
        etfc.addTarget(self, action: #selector(self.handleResponders(textField:)), for: UIControl.Event.editingChanged)
        return etfc
    }()
    
    private lazy var slotFourTextField: DSSMSTextField = {
        let etfc = DSSMSTextField()
        etfc.delegate = self
        etfc.addTarget(self, action: #selector(self.handleResponders(textField:)), for: UIControl.Event.editingChanged)
        return etfc
    }()
    
    private let stackView : UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalCentering
        sv.alignment = .center
        sv.spacing = 6
        return sv
    }()
    
    let counterForPinLabel : UILabel = {
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.text = "120"
        thl.font = UIFont.poppinsRegular(size: 15)
        thl.numberOfLines = 2
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = .dsTextColor
        return thl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        addViews()
        pinTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handleCountDown), userInfo: nil, repeats: true)
        
        let phoneNumber = self.phoneNumber ?? "xxxx"
        let phoneTrim = phoneNumber.suffix(4)
        
        self.subHeaderLabel.text = "We have sent you a unique 4 digit code to the phone number ending in \(phoneTrim)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.counterForPinLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.slotOneTextField.becomeFirstResponder()
        UIView.animate(withDuration: 1.0) {
            self.counterForPinLabel.alpha = 1
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.pinCounter = 120
        self.pinTimer?.invalidate()
        self.counterForPinLabel.text = "120"
    }
    
    private func configureVC() {
        view.backgroundColor = .dsViewBackground
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = logo
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func addViews() {
        
        self.stackView.addArrangedSubview(self.slotOneTextField)
        self.stackView.addArrangedSubview(self.slotTwoTextField)
        self.stackView.addArrangedSubview(self.slotThreeTextField)
        self.stackView.addArrangedSubview(self.slotFourTextField)
        
        self.view.addSubview(mainHeaderLabel)
        mainHeaderLabel.topToSuperview(offset: 30, usingSafeArea: true)
        mainHeaderLabel.left(to: view, offset: 30)
        mainHeaderLabel.right(to: view, offset: -30)
        
        self.view.addSubview(subHeaderLabel)
        subHeaderLabel.topToBottom(of: mainHeaderLabel, offset: 15)
        subHeaderLabel.left(to: mainHeaderLabel)
        subHeaderLabel.right(to: mainHeaderLabel)
        
        self.view.addSubview(stackView)
        stackView.topToBottom(of: subHeaderLabel, offset: 25)
        stackView.left(to: mainHeaderLabel)
        stackView.right(to: mainHeaderLabel)
        
        self.view.addSubview(registerButton)
        registerButton.topToBottom(of: stackView, offset: 32)
        registerButton.left(to: mainHeaderLabel)
        registerButton.right(to: mainHeaderLabel)
    }
    
    private func handleVerification(phone : String, countryCode : String, enteredCode : String) {
        
        self.mainLoadingScreen.callMainLoadingScreen(lottiAnimationName: Statics.PAW_ANIMATION)
        self.resignation()
        
        ServiceHTTP.shared.twilioGetRequest(function_call: "request_for_authorization", users_country_code: countryCode, users_phone_number: phone, delivery_method: "sms", entered_code: enteredCode) { object, error in
            
            guard let obj = object else {return}
        
            for (key,value) in obj {
                
                let response = String(describing: value)
                
                if key == "twilio_response" {
                    
                    switch response {
                    
                    case "denied" :
                        DispatchQueue.main.async {
                            self.mainLoadingScreen.cancelMainLoadingScreen()
                            self.handleCustomPopUpAlert(title: "Incorrect Pin", message: "Please try again.", passedButtons: [Statics.GOT_IT])
                        }
                       
                    case "failed" :
                        DispatchQueue.main.async {
                            self.mainLoadingScreen.cancelMainLoadingScreen()
                            self.handleCustomPopUpAlert(title: "Internal Error", message: "Please try again.", passedButtons: [Statics.GOT_IT])
                        }
                        
                    case "approved" :
                        DispatchQueue.main.async {
                            self.mainLoadingScreen.cancelMainLoadingScreen()
                            self.handleVerifiedPinState()
                        }
                        
                    default: print("unknown from twilio")
                    
                    }
                }
            }
        }
    }
    
    private func handlePinCompletionEntry() {
        
        let slotOne = self.slotOneTextField.text ?? ""
        let slotTwo = self.slotTwoTextField.text ?? ""
        let slotThree = self.slotThreeTextField.text ?? ""
        let slotFour = self.slotFourTextField.text ?? ""
        
        if slotOne.isEmpty || slotTwo.isEmpty || slotThree.isEmpty || slotFour.isEmpty {
            return
        }
        
        let pin = "\(slotOne)\(slotTwo)\(slotThree)\(slotFour)"
        
        self.registerButton.isHidden = true
        self.navigationController?.popViewController(animated: true)
        self.pinTimer?.invalidate()
        self.counterForPinLabel.text = ""
        self.pinCounter = 120
        
        guard let safePhoneNumber = self.phoneNumber, let safeCountryCode = self.countryCode else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.handleVerification(phone: safePhoneNumber, countryCode: safeCountryCode, enteredCode: pin)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let entrySlot = textField.text {
            
            let maxLength = 1
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            textField.text = entrySlot
            return newString.length <= maxLength
        }
        return true
    }
    
    private func resignation() {
        
        self.slotOneTextField.resignFirstResponder()
        self.slotTwoTextField.resignFirstResponder()
        self.slotThreeTextField.resignFirstResponder()
        self.slotFourTextField.resignFirstResponder()
        
    }
  
    @objc func handleCustomPopUpAlert(title : String, message : String, passedButtons: [String]) {
        
        self.mainLoadingScreen.cancelMainLoadingScreen()
        
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
        case Statics.GOT_IT:
            
            self.slotOneTextField.text = ""
            self.slotTwoTextField.text = ""
            self.slotThreeTextField.text = ""
            self.slotFourTextField.text = ""
            
            self.slotOneTextField.becomeFirstResponder()
            
        default: print("Should not hit")
            
        }
    }
}

//MARK: - @objc
extension PinNumberVerificationEntryController {
    
    @objc func handleCountDown() {
        self.pinCounter -= 1
        self.counterForPinLabel.text = "\(self.pinCounter)"
        
        if self.pinCounter == 0 {
            self.handleCancelButton()
        }
    }
    
    @objc func handleResponders(textField : UITextField) {
        let slotOneText = self.slotOneTextField.text ?? ""
        let slotTwoText = self.slotTwoTextField.text ?? ""
        let slotThreeText = self.slotThreeTextField.text ?? ""
        let slotFourText = self.slotFourTextField.text ?? ""
        
        if slotOneText.isEmpty {
        } else {
            self.slotOneTextField.layer.borderColor = UIColor.dsOrange.cgColor
            self.slotOneTextField.layer.borderWidth = 0.5
        }
        
        if slotTwoText.isEmpty {
        } else {
            self.slotTwoTextField.layer.borderColor = UIColor.dsOrange.cgColor
            self.slotTwoTextField.layer.borderWidth = 0.5
        }
        
        if slotThreeText.isEmpty {
        } else {
            self.slotThreeTextField.layer.borderColor = UIColor.dsOrange.cgColor
            self.slotThreeTextField.layer.borderWidth = 0.5
        }
        
        if slotFourText.isEmpty {
        } else {
            self.slotFourTextField.layer.borderColor = UIColor.dsOrange.cgColor
            self.slotFourTextField.layer.borderWidth = 0.5
        }
        
        if self.slotOneTextField.isFirstResponder && slotOneText.count > 0 {
            self.slotTwoTextField.becomeFirstResponder()
        } else if slotTwoTextField.isFirstResponder && slotTwoText.count > 0 {
            self.slotThreeTextField.becomeFirstResponder()
        } else if slotThreeTextField.isFirstResponder && slotThreeText.count > 0 {
            self.slotFourTextField.becomeFirstResponder()
        } else if self.slotFourTextField.isFirstResponder && slotFourText.count > 0 {
            self.handlePinCompletionEntry()
        }
    }
    
    @objc func handleRegistrationButton() {
        self.resignation()
        self.handlePinCompletionEntry()
    }
    
    @objc func handleVerifiedPinState() {
        
        let notificationsController = NotificationsController()
        let nav = UINavigationController(rootViewController: notificationsController)
        nav.modalPresentationStyle = .fullScreen
        navigationController?.present(nav, animated: true)
    }
    
    @objc func handleCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
