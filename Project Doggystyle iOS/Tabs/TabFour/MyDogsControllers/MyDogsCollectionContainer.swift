//
//  MyDogsCollectionContainer.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/13/21.
//

import Foundation
import UIKit
import Firebase

class MyDogsCollectionContainer : UIViewController, CustomAlertCallBackProtocol {
    
    var homeViewController : HomeViewController?,
        removalID : String = "nil",
        removalDogsNameID : String = "nil"

    lazy var backButton : UIButton = {
        
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
    
    let myDoggiesLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "My Doggies"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    lazy var myDogsCollectionView : MyDogsCollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let mdc = MyDogsCollectionView(frame: .zero, collectionViewLayout: layout)
        mdc.myDogsCollectionContainer = self
        
       return mdc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        self.reloadDoggyCollection()
        self.addObservers()
    }
    
    func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDoggyCollection), name: NSNotification.Name(Statics.RELOAD_DOGGY_PROFILE_SETTINGS), object: nil)
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.myDoggiesLabel)
        self.view.addSubview(self.myDogsCollectionView)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 11).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.myDoggiesLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 43).isActive = true
        self.myDoggiesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.myDoggiesLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.myDoggiesLabel.sizeToFit()
        
        self.myDogsCollectionView.topAnchor.constraint(equalTo: self.myDoggiesLabel.bottomAnchor, constant: 20).isActive = true
        self.myDogsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.myDogsCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.myDogsCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

    }
    
   @objc func reloadDoggyCollection() {
        
        DispatchQueue.main.async {
            self.myDogsCollectionView.reloadData()
        }
    }
    
    @objc func handleAddNewDog() {
        self.homeViewController?.handleAddNewDogFlow()
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleCustomPopUpAlert(title : String, message : String, passedButtons: [String]) {
        
        let alert = AlertController()
        alert.passedTitle = title
        alert.passedMmessage = message
        alert.passedButtonSelections = passedButtons
        alert.customAlertCallBackProtocol = self
        alert.passedIconName = .infoCircle
        alert.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    func onSelectionPassBack(buttonTitleForSwitchStatement type: String) {
        
        switch type {
        
        case Statics.OK: print(Statics.OK)
        case Statics.CANCEL: print(Statics.CANCEL)

        case Statics.GOT_IT:
            self.handleRemoval()
            
        default: print("Should not hit")
            
        }
    }
  
    func handleDogRemoval(passedChildAutoKey : String, dogsName : String) {
        self.removalID = passedChildAutoKey
        self.removalDogsNameID = dogsName
        self.handleCustomPopUpAlert(title: "\(dogsName)", message: "Just so you know, removing \(dogsName) is permanent.", passedButtons: [Statics.GOT_IT, Statics.CANCEL])
    }
    
    func handleRemoval() {
        
        guard let user_uid = Auth.auth().currentUser?.uid else {return}

        Service.shared.removeDog(passedAutoID: self.removalID) { isComplete in
            
            if isComplete {
                Service.shared.notificationSender(notificationType: Statics.NOTIFICATION_DOG_REMOVAL, userUID: user_uid, textMessage: "\(self.removalDogsNameID) has been removed.", imageURL: "nil") { notificationCompletion in
                    self.handleBackButton()
                }
            } else {
                Service.shared.notificationSender(notificationType: Statics.NOTIFICATION_DOG_REMOVAL, userUID: user_uid, textMessage: "\(self.removalDogsNameID) could not be removed Please try again.", imageURL: "nil") { notificationCompletion in
                    self.handleBackButton()
                }
            }
        }
    }
}
