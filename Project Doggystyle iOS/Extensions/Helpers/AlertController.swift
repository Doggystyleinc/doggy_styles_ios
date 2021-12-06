//
//  AlertController.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/4/21.
//

import Foundation
import UIKit
import AudioToolbox
import Firebase
import FontAwesome_swift

protocol CustomAlertCallBackProtocol {
    func onSelectionPassBack(buttonTitleForSwitchStatement: String)
}

class AlertController : UIViewController {
    
    var customAlertCallBackProtocol : CustomAlertCallBackProtocol?,
        passedTitle : String?,
        passedMmessage : String?,
        hasViewBeenLaidOut : Bool = false,
        passedButtonSelections : [String]?,
        buttonOne = UIButton(type: .system),
        buttonTwo = UIButton(type: .system),
        buttonThree = UIButton(type: .system),
        mainTopAnchorConstraint : NSLayoutConstraint?,
        passedViewController : UIViewController?,
        passedIconName : FontAwesome?,
        headerIconHeightConstraint : NSLayoutConstraint?,
        headerIconTopConstraint : NSLayoutConstraint?

    
    let mainContainer : UIView = {
        
        let mc = UIView()
        mc.translatesAutoresizingMaskIntoConstraints = false
        mc.backgroundColor = coreWhiteColor
        mc.layer.masksToBounds = true
        mc.layer.cornerRadius = 10
        mc.isUserInteractionEnabled = false
        
        return mc
    }()
    
    let headerLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.font = UIFont(name: rubikBold, size: 18)
        thl.numberOfLines = 2
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    let descriptionLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .center
        thl.font = UIFont(name: rubikRegular, size: 18)
        thl.numberOfLines = -1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = dsFlatBlack
        return thl
        
    }()

    lazy var headerIcon : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 60, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .infoCircle), for: .normal)
        cbf.setTitleColor(coreOrangeColor, for: .normal)
        cbf.isUserInteractionEnabled = false
        return cbf
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        self.addViewLogic()
        self.handleLoggers()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        UIView.animate(withDuration: 0.75) {
            self.view.backgroundColor = UIColor (white: 0.0, alpha: 0.4)
        }
    }
    
    @objc func handleLoggers() {
        
        let auth = Auth.auth().currentUser?.uid ?? "nil"
        let error_message = self.passedMmessage ?? "no error message"
        ErrorHandlingService.shared.handleErrorLogging(user_uid: auth, error_message: error_message) { response, error in
            print("error code sent up")
        }
    }
    
    @objc func addViewLogic() {
        
        guard let safeMessage = self.passedMmessage else {return}
        guard let safeTitle = self.passedTitle else {return}
        guard let safeButtonSelections = self.passedButtonSelections else {return}
        var buffer : CGFloat = 132

        var heightForIcon : CGFloat = 0.0
        
        if self.passedIconName == nil {
            heightForIcon = 30.0
            self.headerIcon.isHidden = true
            buffer = 132
            self.headerIcon.setTitle(String.fontAwesomeIcon(name: .infoCircle), for: .normal)
        } else {
            heightForIcon = 60.0
            self.headerIcon.isHidden = false
            buffer = 132 + 50
            guard let iconName = self.passedIconName else {return}
            self.headerIcon.setTitle(String.fontAwesomeIcon(name: iconName), for: .normal)

        }

        self.headerLabel.text = safeTitle
        self.descriptionLabel.text = safeMessage

        let width : CGFloat = UIScreen.main.bounds.width / 1.2

        let size = CGSize(width: (UIScreen.main.bounds.width / 1.2) - 81, height: 2000),
        options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
        message = safeMessage
    
        let estimatedMessageFrame = NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont(name: rubikRegular, size: 18)!], context: nil)
        let estimatedDescriptionHeight = estimatedMessageFrame.height

        self.view.addSubview(self.mainContainer)
        self.mainContainer.addSubview(self.headerIcon)
        self.mainContainer.addSubview(self.headerLabel)
        self.mainContainer.addSubview(self.descriptionLabel)

        self.mainTopAnchorConstraint = self.mainContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
        self.mainTopAnchorConstraint?.isActive = true
        self.mainContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.mainContainer.heightAnchor.constraint(equalToConstant: estimatedDescriptionHeight + buffer).isActive = true
        self.mainContainer.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        self.headerIconTopConstraint = self.headerIcon.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 26)
        self.headerIconTopConstraint?.isActive = true
        self.headerIcon.centerXAnchor.constraint(equalTo: self.mainContainer.centerXAnchor, constant: 0).isActive = true
        self.headerIcon.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.headerIconHeightConstraint = self.headerIcon.heightAnchor.constraint(equalToConstant: heightForIcon)
        self.headerIconHeightConstraint?.isActive = true

        self.headerLabel.topAnchor.constraint(equalTo: self.headerIcon.bottomAnchor, constant: 20).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 20).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -20).isActive = true
        self.headerLabel.sizeToFit()

        self.descriptionLabel.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 10).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 41).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -41).isActive = true
        self.descriptionLabel.sizeToFit()
        
        if self.passedIconName == nil {
            self.headerIconTopConstraint?.constant = 0.0
        } else {
            self.headerIconTopConstraint?.constant = 26.0
        }
        
        if safeButtonSelections.count == 0 {
            self.perform(#selector(self.handleLightDismiss), with: nil, afterDelay: 2.0)
            return
        }
        
        guard let safeButtonArray = self.passedButtonSelections else {return}
        self.addButtons(arrayOfButtonsPass: safeButtonArray)
       
    }
    
    func addButtons(arrayOfButtonsPass : [String]) {
        
        let arrayOfButtons : [UIButton] = [buttonOne, buttonTwo, buttonThree]
        
        var counter : CGFloat = 0.0
        let heightDifference : CGFloat = 68.0
        var spacingForButtons : CGFloat = 0.0
        var titleForButton : String = ""
        
        for count in 0..<arrayOfButtonsPass.count {
            
            counter += 1.0
            
            titleForButton = arrayOfButtonsPass[count]
            
            let button = arrayOfButtons[Int(counter) - 1]
            
            spacingForButtons = heightDifference * counter
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = coreWhiteColor
            button.titleLabel?.font = UIFont(name: rubikMedium, size: 18)
            button.tintColor = dsFlatBlack
            button.setTitle(titleForButton, for: .normal)
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.tag = Int(counter - 1.0)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.numberOfLines = 1
            button.addTarget(self, action: #selector(self.handleButtonSelection), for: .touchUpInside)
            
            self.view.addSubview(button)
            
            button.topAnchor.constraint(equalTo: self.mainContainer.bottomAnchor, constant: spacingForButtons - 40).isActive = true
            button.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 0).isActive = true
            button.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: 0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 58).isActive = true
            
        }
        
        let mainContainerOffset : CGFloat = -(CGFloat(arrayOfButtonsPass.count) * 29.0)
        
        UIView.animate(withDuration: 0.25) {
            self.mainTopAnchorConstraint?.constant = mainContainerOffset
        }
    }
    
    @objc func handleButtonSelection(sender : UIButton) {
        self.dismissAndCall(sender: sender)
    }
    
    func dismissAndCall(sender : UIButton) {
        
        AudioServicesPlaySystemSound(1519)
        UIDevice.vibrateLight()
        
        self.view.backgroundColor = .clear
         
        self.dismiss(animated: true) {
            let buttonTitle = sender.titleLabel?.text ?? "Incognito"
            self.customAlertCallBackProtocol?.onSelectionPassBack(buttonTitleForSwitchStatement: buttonTitle)
        }
    }
   
    @objc func handleLightDismiss() {
        
        UIView.animate(withDuration: 0.15) {
            
            self.mainContainer.alpha = 0
            self.buttonOne.alpha = 0
            self.buttonTwo.alpha = 0
            self.buttonThree.alpha = 0
            self.view.backgroundColor = .clear
            
        } completion: { complete in
            
            self.dismiss(animated: false, completion: nil)
            
            self.mainContainer.alpha = 1
            self.buttonOne.alpha = 1
            self.buttonTwo.alpha = 1
            self.buttonThree.alpha = 1
            self.view.backgroundColor = UIColor (white: 0.0, alpha: 0.60)
        }
    }
}

class ErrorHandlingService : NSObject {
    
    static let shared = ErrorHandlingService()
    
    func handleErrorLogging(user_uid : String?, error_message : String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        //MARK: - USER HAS NO AUTH, MAKE THIS ERROR REPORTING GLOBAL
        if user_uid == "nil" {
            
            let error_message = error_message
            let error_groomers_full_name = "nil"
            let error_groomers_user_uid = "nil"
            let error_is_groomer = false
            let random_key = NSUUID().uuidString
            let path = "error_logging_global/\(random_key)"

            let parameters : [String : Any] = ["error_message": error_message, "error_groomers_full_name" : error_groomers_full_name, "error_groomers_user_uid" : error_groomers_user_uid, "error_is_groomer" : error_is_groomer, "random_key" : random_key, "path" : path]

            let slug = "error_logging"
            
            let url = URL(string: "https://doggystyle-dev.herokuapp.com/\(slug)")!
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
    
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error in

               guard error == nil else {
                   completion(nil, error)
                   return
               }

               guard let data = data else {
                   completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                   return
               }

               do {
                   guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                       completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                       return
                   }
                
                   completion(json, nil)
                
               } catch let error {
                   print(error.localizedDescription)
                   completion(nil, error)
               }
           })
                
            task.resume()
       
        //MARK: - USER HAS AUTH, MAKE THIS ERROR REPORTING PERSONAL
        } else {
            
            guard let userUID = user_uid else {return}
            
            let usersFirstName = userProfileStruct.user_first_name ?? "nil"
            let usersLastName = userProfileStruct.user_last_name ?? "nil"
            let groomersFullName = "\(usersFirstName) \(usersLastName)"
            
            let error_message = error_message
            let error_groomers_full_name = groomersFullName
            let error_groomers_user_uid = userUID
            let error_is_groomer = true
            let random_key = NSUUID().uuidString
            let path = "error_logging/\(userUID)/\(random_key)"
            
            let parameters : [String : Any] = ["error_message": error_message, "error_groomers_full_name" : error_groomers_full_name, "error_groomers_user_uid" : error_groomers_user_uid, "error_is_groomer" : error_is_groomer, "random_key" : random_key, "path" : path]

            let slug = "error_logging"
            
            let url = URL(string: "https://doggystyle-dev.herokuapp.com/\(slug)")!
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
    
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error in

               guard error == nil else {
                   completion(nil, error)
                   return
               }

               guard let data = data else {
                   completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                   return
               }

               do {
                   guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                       completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                       return
                   }
                   completion(json, nil)
               } catch let error {
                   print(error.localizedDescription)
                   completion(nil, error)
               }
           })
            
            task.resume()
            
        }
    }
}
