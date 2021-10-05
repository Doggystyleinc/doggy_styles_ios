//
//  NewDogFive.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/6/21.
//

import Foundation
import UIKit
import Firebase


class NewDogFive : UIViewController, CustomAlertCallBackProtocol {
    
    let mainLoadingScreen = MainLoadingScreen(),
        storageRef = Storage.storage().reference(),
        databaseRef = Database.database().reference()
    
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
        nl.text = "Confirm <name> details"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var confirmButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Confirm", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.addTarget(self, action: #selector(self.doggyProfileUploader), for: .touchUpInside)
        
        return cbf
        
    }()
    
    let mainContainer : UIView = {
        
        let wc = UIView()
        wc.translatesAutoresizingMaskIntoConstraints = false
        wc.backgroundColor = coreWhiteColor
        wc.isUserInteractionEnabled = true
        wc.layer.masksToBounds = true
        wc.layer.cornerRadius = 20
        wc.clipsToBounds = false
        wc.layer.masksToBounds = false
        wc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        wc.layer.shadowOpacity = 0.05
        wc.layer.shadowOffset = CGSize(width: 2, height: 3)
        wc.layer.shadowRadius = 9
        wc.layer.shouldRasterize = false
        return wc
        
    }()
    
    let dogImage : UIImageView = {
        
        let di = UIImageView()
        di.translatesAutoresizingMaskIntoConstraints = false
        di.backgroundColor = coreOrangeColor.withAlphaComponent(0.2)
        di.contentMode = .scaleAspectFill
        di.isUserInteractionEnabled = true
        di.layer.masksToBounds = true
        
        return di
    }()
    
    lazy var pencilIconButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreOrangeColor
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 17, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        cbf.addTarget(self, action: #selector(self.handlePencilButton), for: UIControl.Event.touchUpInside)
        cbf.isHidden = true
        return cbf
        
    }()
    
    let k9Name : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = ""
        nl.font = UIFont(name: dsSubHeaderFont, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let containerForSize : UIView = {
        
        let cfs = UIView()
        cfs.translatesAutoresizingMaskIntoConstraints = false
        cfs.backgroundColor = coreWhiteColor
        
        return cfs
    }()
    
    lazy var newDogCollection : NewDogFiveCollectionview = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let ndc = NewDogFiveCollectionview(frame: .zero, collectionViewLayout: layout)
        ndc.newDogFive = self
        return ndc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        self.fillValues()
        
    }
    
    var fetchedArray : [String] = [String]()
    
    func fillValues() {
        
        //MARK: - HEADER
        let dogsName = globalNewDogBuilder.dogBuilderName ?? "Dog"
        self.basicDetailsLabel.text = "Confirm \(dogsName)'s details"
        
        let image = globalNewDogBuilder.dogBuilderProfileImage ?? UIImage(named: "doggy_profile_filler")?.withRenderingMode(.alwaysOriginal)
        self.dogImage.image = image
        
        //MARK: - BODY
        self.k9Name.text = dogsName
        
        let size = globalNewDogBuilder.dogBuilderSize
        let breed = globalNewDogBuilder.dogBuilderBreed ?? "Unknown"
        let age = globalNewDogBuilder.dogBuilderBirthday ?? "Unknown"
        let frequency = globalNewDogBuilder.dogBuilderGroomingFrequency
        let favoriteTreat = globalNewDogBuilder.dogBuilderFavoriteTreat ?? "n/a"
        let favoriteFood = globalNewDogBuilder.dogBuilderFavoriteFood ?? "n/a"
        let hasMedicalConditions = globalNewDogBuilder.dogBuilderHasMedicalConditions ?? false
        let hasBehavoirConcerns = globalNewDogBuilder.dogBuilderHasBehaviouralConditions ?? false
        
        let medicalDescription = globalNewDogBuilder.medicalConditionDescription ?? ""
        let behaviorDescription = globalNewDogBuilder.behavioralConditionDescription ?? ""
        
        
        var medicalCondition = "no"
        var behaviorCondition = "no"
        
        if hasMedicalConditions == true {
            medicalCondition = "yes"
        } else {
            medicalCondition = "no"
        }
        
        if hasBehavoirConcerns == true {
            behaviorCondition = "yes"
        } else {
            behaviorCondition = "no"
        }
        
        var frequencyString : String = ""
        var sizeString : String = ""
        
        if frequency == .fourWeeks {
            frequencyString = "4 weeks"
        } else {
            frequencyString = "8 weeks"
        }
        
        if size == .small {
            sizeString = "Small"
        } else if size == .medium {
            sizeString = "Medium"
        } else if size == .large {
            sizeString = "Large"
        } else if size == .xlarge {
            sizeString = "X-Large"
        }
        
        self.fetchedArray = ["\(sizeString)", "\(breed)", "\(age)", "\(frequencyString)", "\(favoriteTreat)", "\(favoriteFood)", "\(medicalCondition)", "\(medicalDescription)", "\(behaviorCondition)", "\(behaviorDescription)"]
        self.newDogCollection.valueArray = self.fetchedArray
        
        DispatchQueue.main.async {
            self.newDogCollection.reloadData()
        }
    }
    
    func addViews() {
        
        self.view.addSubview(self.headerContainer)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.basicDetailsLabel)
        self.view.addSubview(self.mainContainer)
        self.view.addSubview(self.confirmButton)
        
        self.mainContainer.addSubview(self.dogImage)
        self.mainContainer.addSubview(self.k9Name)
        self.mainContainer.addSubview(self.pencilIconButton)
        self.mainContainer.addSubview(self.containerForSize)
        self.mainContainer.addSubview(self.newDogCollection)
        
        
        self.headerContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
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
        
        self.confirmButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        self.confirmButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.confirmButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.confirmButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.mainContainer.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 20).isActive = true
        self.mainContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.mainContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.mainContainer.bottomAnchor.constraint(equalTo: self.confirmButton.topAnchor, constant: -30).isActive = true
        
        self.dogImage.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 21).isActive = true
        self.dogImage.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 27).isActive = true
        self.dogImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.dogImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
        self.dogImage.layer.cornerRadius = 48/2
        
        self.k9Name.centerYAnchor.constraint(equalTo: self.dogImage.centerYAnchor, constant: 0).isActive = true
        self.k9Name.leftAnchor.constraint(equalTo: self.dogImage.rightAnchor, constant: 10).isActive = true
        self.k9Name.sizeToFit()
        
        self.pencilIconButton.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 21).isActive = true
        self.pencilIconButton.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -27).isActive = true
        self.pencilIconButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.pencilIconButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.containerForSize.topAnchor.constraint(equalTo: self.dogImage.bottomAnchor, constant: 10).isActive = true
        self.containerForSize.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 0).isActive = true
        self.containerForSize.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: 0).isActive = true
        self.containerForSize.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor, constant: -10).isActive = true
        
        self.newDogCollection.topAnchor.constraint(equalTo: self.dogImage.bottomAnchor, constant: 10).isActive = true
        self.newDogCollection.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 0).isActive = true
        self.newDogCollection.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: 0).isActive = true
        self.newDogCollection.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor, constant: -10).isActive = true
        
    }
    
    @objc func handlePencilButton() {
        
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNextButton() {
        
        UIDevice.vibrateLight()
        
        let newDogSix = NewDogSix()
        newDogSix.modalPresentationStyle = .fullScreen
        newDogSix.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(newDogSix, animated: true)
        
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

extension NewDogFive {
    
    @objc func doggyProfileUploader() {
        
        self.mainLoadingScreen.callMainLoadingScreen(lottiAnimationName: Statics.PAW_ANIMATION)
        guard let user_uid = Auth.auth().currentUser?.uid else {return}
        
        let path = self.databaseRef.child("doggy_profile_builder").child(user_uid).childByAutoId()
        let time_stamp : Double = NSDate().timeIntervalSince1970
        
        let profileImageFetch = globalNewDogBuilder.dogBuilderProfileImage ?? UIImage(named: "doggy_profile_filler")?.withRenderingMode(.alwaysOriginal)
        let vaccineImage = globalNewDogBuilder.dogBuilderHasUploadedVaccineImage
        
        let dog_builder_name = globalNewDogBuilder.dogBuilderName ?? "n/a"
        let dog_builder_breed = globalNewDogBuilder.dogBuilderBreed ?? "n/a"
        let dog_builder_birthday = globalNewDogBuilder.dogBuilderBirthday ?? "n/a"
        let dog_builder_favorite_treat = globalNewDogBuilder.dogBuilderFavoriteTreat ?? "n/a"
        let dog_builder_favorite_food = globalNewDogBuilder.dogBuilderFavoriteFood ?? "n/a"
        let dog_builder_has_medical_conditions = globalNewDogBuilder.dogBuilderHasMedicalConditions ?? false
        let dog_builder_has_behavioral_conditions = globalNewDogBuilder.dogBuilderHasBehaviouralConditions ?? false
        let dog_builder_has_vaccine_card = globalNewDogBuilder.dogBuilderHasUploadedVaccineCard ?? false
        let dog_builder_has_vaccine_file_path = globalNewDogBuilder.dogBuilderHasUploadedVaccineFilePath ?? "nil"
        let dog_builder_medical_description = globalNewDogBuilder.medicalConditionDescription ?? "nil"
        let dog_builder_behavior_description = globalNewDogBuilder.behavioralConditionDescription ?? "nil"
        
        var dog_builder_size = ""
        var dog_builder_frequency = ""
        
        switch globalNewDogBuilder.dogBuilderSize {
        
        case .small : dog_builder_size = "Small"
        case .medium : dog_builder_size = "Medium"
        case .large : dog_builder_size = "Large"
        case .xlarge : dog_builder_size = "X-Large"
            
        }
        
        switch globalNewDogBuilder.dogBuilderGroomingFrequency {
        
        case .fourWeeks : dog_builder_frequency = "4 Weeks"
        case .eightWeeks : dog_builder_frequency = "8 Weeks"
            
        }
        
        self.uploadPhotoWithCustomPath(path: "dog_profile_images", imageToUpload: profileImageFetch!) { isComplete, profileURL in
            
            if isComplete {
                
                if dog_builder_has_vaccine_card == true {
                    
                    if dog_builder_has_vaccine_file_path == "nil" {
                        
                        //MARK: - HAS VACCINE PHOTO
                        self.uploadPhotoWithCustomPath(path: "vaccine_images", imageToUpload: vaccineImage!) { isComplete, vaccineURL in
                            
                            let values : [String : Any] = ["dog_builder_name" : dog_builder_name,
                                                           "dog_builder_breed" : dog_builder_breed,
                                                           "dog_builder_birthday" : dog_builder_birthday,
                                                           "dog_builder_favorite_treat" : dog_builder_favorite_treat,
                                                           "dog_builder_favorite_food" : dog_builder_favorite_food,
                                                           "dog_builder_has_medical_conditions" : dog_builder_has_medical_conditions,
                                                           "dog_builder_has_behavioral_conditions" : dog_builder_has_behavioral_conditions,
                                                           "dog_builder_has_vaccine_card" : true,
                                                           "dog_builder_size" : dog_builder_size,
                                                           "dog_builder_frequency" : dog_builder_frequency,
                                                           "dog_builder_profile_url" : profileURL,
                                                           "dog_builder_vaccine_card_url" : vaccineURL,
                                                           "ref_key" : path.key ?? "nil",
                                                           "user_uid" : user_uid,
                                                           "parent_key" : path.parent?.key ?? "nil",
                                                           "time_stamp" : time_stamp,
                                                           "vaccine_proof_is_image" : true,
                                                           "dog_builder_medical_description" : dog_builder_medical_description,
                                                           "dog_builder_behavior_description" : dog_builder_behavior_description
                            ]
                            
                            let path = self.databaseRef.child("doggy_profile_builder").child(user_uid).childByAutoId()
                            path.updateChildValues(values) { error, ref in
                                
                                if error != nil {
                                    print(error?.localizedDescription as Any)
                                    self.mainLoadingScreen.cancelMainLoadingScreen()
                                    self.handleCustomPopUpAlert(title: "FAILED", message: "Seems something wen't wrong, please try again.", passedButtons: [Statics.OK])
                                    return
                                }
                                
                                self.mainLoadingScreen.cancelMainLoadingScreen()
                                self.handleNextButton()
                            }
                        }
                        
                    } else {
                        
                        //MARK: - HAS VACCINE FILE
                        let fileURLForUploading = URL(fileURLWithPath: dog_builder_has_vaccine_file_path)
                        
                        fileUPloader.upload(localFilePath: fileURLForUploading) { isComplete, fileURL in
                            
                            let values : [String : Any] = ["dog_builder_name" : dog_builder_name,
                                                           "dog_builder_breed" : dog_builder_breed,
                                                           "dog_builder_birthday" : dog_builder_birthday,
                                                           "dog_builder_favorite_treat" : dog_builder_favorite_treat,
                                                           "dog_builder_favorite_food" : dog_builder_favorite_food,
                                                           "dog_builder_has_medical_conditions" : dog_builder_has_medical_conditions,
                                                           "dog_builder_has_behavioral_conditions" : dog_builder_has_behavioral_conditions,
                                                           "dog_builder_has_vaccine_card" : true,
                                                           "dog_builder_size" : dog_builder_size,
                                                           "dog_builder_frequency" : dog_builder_frequency,
                                                           "dog_builder_profile_url" : profileURL,
                                                           "dog_builder_vaccine_card_url" : fileURL,
                                                           "ref_key" : path.key ?? "nil",
                                                           "user_uid" : user_uid,
                                                           "parent_key" : path.parent?.key ?? "nil",
                                                           "time_stamp" : time_stamp,
                                                           "vaccine_proof_is_image" : false,
                                                           "dog_builder_medical_description" : dog_builder_medical_description,
                                                           "dog_builder_behavior_description" : dog_builder_behavior_description
                                                           
                            ]
                            
                            let path = self.databaseRef.child("doggy_profile_builder").child(user_uid).childByAutoId()
                            path.updateChildValues(values) { error, ref in
                                
                                if error != nil {
                                    print(error?.localizedDescription as Any)
                                    self.mainLoadingScreen.cancelMainLoadingScreen()
                                    self.handleCustomPopUpAlert(title: "FAILED", message: "Seems something wen't wrong, please try again.", passedButtons: [Statics.OK])
                                    return
                                }
                                
                                print("Successful upload with vaccine card")
                                self.mainLoadingScreen.cancelMainLoadingScreen()
                                self.handleNextButton()
                            }
                        }
                    }
                    
                } else {
                    
                    //MARK: - HAS VACCINE INFO
                    let values : [String : Any] = ["dog_builder_name" : dog_builder_name,
                                                   "dog_builder_breed" : dog_builder_breed,
                                                   "dog_builder_birthday" : dog_builder_birthday,
                                                   "dog_builder_favorite_treat" : dog_builder_favorite_treat,
                                                   "dog_builder_favorite_food" : dog_builder_favorite_food,
                                                   "dog_builder_has_medical_conditions" : dog_builder_has_medical_conditions,
                                                   "dog_builder_has_behavioral_conditions" : dog_builder_has_behavioral_conditions,
                                                   "dog_builder_has_vaccine_card" : false,
                                                   "dog_builder_size" : dog_builder_size,
                                                   "dog_builder_frequency" : dog_builder_frequency,
                                                   "dog_builder_profile_url" : profileURL,
                                                   "dog_builder_vaccine_card_url" : "nil",
                                                   "ref_key" : path.key ?? "nil",
                                                   "user_uid" : user_uid,
                                                   "parent_key" : path.parent?.key ?? "nil",
                                                   "time_stamp" : time_stamp,
                                                   "vaccine_proof_is_image" : false,
                                                   "dog_builder_medical_description" : dog_builder_medical_description,
                                                   "dog_builder_behavior_description" : dog_builder_behavior_description
                                                   
                    ]
                    
                    path.updateChildValues(values) { error, ref in
                        
                        if error != nil {
                            print(error?.localizedDescription as Any)
                            self.mainLoadingScreen.cancelMainLoadingScreen()
                            self.handleCustomPopUpAlert(title: "FAILED", message: "Seems something wen't wrong, please try again.", passedButtons: [Statics.OK])
                            return
                        }
                        
                        print("Successful upload without vaccine card")
                        self.mainLoadingScreen.cancelMainLoadingScreen()
                        self.handleNextButton()
                    }
                }
                
            } else {
                self.mainLoadingScreen.cancelMainLoadingScreen()
                self.handleCustomPopUpAlert(title: "FAILED", message: "Seems something wen't wrong, please try again.", passedButtons: [Statics.OK])
            }
        }
    }
    
    func uploadPhotoWithCustomPath(path : String, imageToUpload : UIImage, completion : @escaping (_ isComplete : Bool, _ url : String) -> ()) {
        
        guard let userUid = Auth.auth().currentUser?.uid else {return}
        guard let imageDataToUpload = imageToUpload.jpegData(compressionQuality: 0.15) else {return}
        
        let randomString = NSUUID().uuidString
        let imageRef = self.storageRef.child(path).child(userUid).child(randomString)
        
        imageRef.putData(imageDataToUpload, metadata: nil) { (metaDataPass, error) in
            
            if error != nil {
                completion(false, "");
                return
            }
            
            imageRef.downloadURL(completion: { (urlGRab, error) in
                
                if error != nil {
                    completion(false, "");
                    return
                }
                
                if let uploadUrl = urlGRab?.absoluteString {
                    
                    completion(true, uploadUrl)
                    
                }
            })
        }
    }
}
