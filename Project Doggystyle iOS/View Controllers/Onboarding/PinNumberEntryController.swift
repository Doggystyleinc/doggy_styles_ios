//
//  PinNumberEntry.swift
//  DSGroomer
//
//  Created by Charlie Arcodia on 6/12/21.
//

import Foundation
import UIKit
import Firebase

final class PinNumberVerificationEntryController: UIViewController, UITextFieldDelegate {
    private let logo = LogoImageView(frame: .zero)
    
    //AND ANY OTHER DATA YOU WOULD LIKE TO PASS IN HERE
    var phoneNumber: String?
    var countryCode: String?
    var usersName: String?
    var pinTimer: Timer?
    var pinCounter: Int = 120
    
    let databaseRef = Database.database().reference()
    
    private let cancelButton: UIButton = {
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
    
    private let mainHeaderLabel = DSBoldLabel(title: "SMS Verification", size: 22)
    private lazy var subHeaderLabel = DSRegularLabel(title: "We have sent you a unique 4 digit code to the phone number ending in \(self.phoneNumber ?? "xxxx")", size: 14)
    
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
        dismissKeyboardTapGesture()
        configureVC()
        addViews()
        pinTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handleCountDown), userInfo: nil, repeats: true)
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
}

//MARK: - Configure View Controller
extension PinNumberVerificationEntryController {
    private func configureVC() {
        view.backgroundColor = .dsViewBackground
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = logo
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

//MARK: - Configure Views
extension PinNumberVerificationEntryController {
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
}

//MARK: - Helpers
extension PinNumberVerificationEntryController {
    private func listenForPendingResponsesFromToken(listeningKey: String, phone: String, countryCode: String) {
        let ref = Database.database().reference().child("pin_verification_responses").child(listeningKey)
        
        ref.observe(.value) { (snap: DataSnapshot) in
            
            if snap.exists() {
                guard let dic = snap.value as? [String : AnyObject] else {return}
                
                let status = dic["status"] as? String ?? ""
                
                switch status {
                
                case "error": print("Error: listening key")
                    self.dismissLoadingView()
                    self.presentAlertOnMainThread(title: "Error", message: "Seems something went wrong attempting to validate. Plase try again. If this problem persists, please contact Team Doggystyle directly.", buttonTitle: "Ok")
                    self.registerButton.isHidden = false
                    
                case "expired": print("Verification code has been approved")
                    self.dismissLoadingView()
                    self.presentAlertOnMainThread(title: "Expired", message: "Code has expired. Please try again.", buttonTitle: "Ok")
                    self.navigationController?.popViewController(animated: true)
                    
                case "failed": print("Failed Verification")
                    self.dismissLoadingView()
                    self.presentAlertOnMainThread(title: "Failed", message: "Please check your phone/pin # and try again.", buttonTitle: "Ok")
                    self.navigationController?.popViewController(animated: true)
                    
                case "canceled" : print("Canceled Verification")
                    self.dismissLoadingView()
                    self.presentAlertOnMainThread(title: "Canceled", message: "Verification was canceled", buttonTitle: "Ok")
                    self.navigationController?.popViewController(animated: true)
                    
                case "approved": print("Verification code has been approved")
                    self.handleVerifiedPinState()
                    
                default :
                    self.dismissLoadingView()
                    self.presentAlertOnMainThread(title: "Unknown Error", message: "Something is not right. Please try again.", buttonTitle: "Ok")
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else if !snap.exists() {
                print("nothing yet here from the linker")
            }
        }
    }
    
    private func handleVerification(phone : String, countryCode : String, enteredCode : String) {
        
        self.showLoadingView()
        self.resignation()
        
        let unique_key = NSUUID().uuidString
        let ref = Database.database().reference().child("pin_verification_requests").child(unique_key)
        let values = [
            "unique_key" : unique_key,
            "users_phone_number" : phone,
            "users_country_code" : countryCode,
            "entered_code" : enteredCode
        ]
        
        ref.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                print(error?.localizedDescription as Any)
                self.dismissLoadingView()
                self.presentAlertOnMainThread(title: "Error", message: "Seems something went wrong attempting to register. Plase try again. If this problem persists, please contact Team Doggystyle directly.", buttonTitle: "Ok")
                self.registerButton.isHidden = false
                return
            }
            
            self.listenForPendingResponsesFromToken(listeningKey: unique_key, phone: phone, countryCode: countryCode)
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
        self.handleVerification(phone: self.phoneNumber ?? "", countryCode: self.countryCode ?? "", enteredCode: pin)
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
            //
        } else {
            self.slotOneTextField.layer.borderColor = UIColor.dsOrange.cgColor
            self.slotOneTextField.layer.borderWidth = 1.5
        }
        
        if slotTwoText.isEmpty {
            //
        } else {
            self.slotTwoTextField.layer.borderColor = UIColor.dsOrange.cgColor
            self.slotTwoTextField.layer.borderWidth = 1.5
        }
        
        if slotThreeText.isEmpty {
            //
        } else {
            self.slotThreeTextField.layer.borderColor = UIColor.dsOrange.cgColor
            self.slotThreeTextField.layer.borderWidth = 1.5
        }
        
        if slotFourText.isEmpty {
            //
        } else {
            self.slotFourTextField.layer.borderColor = UIColor.dsOrange.cgColor
            self.slotFourTextField.layer.borderWidth = 1.5
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
        print("User is verified - push them to the next controller in the flow")
//        let homeVC = HomeViewController()
//        let navVC = UINavigationController(rootViewController: homeVC)
//        navVC.modalPresentationStyle = .fullScreen
//        navigationController?.present(navVC, animated: true)
    }
    
    @objc func handleCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
