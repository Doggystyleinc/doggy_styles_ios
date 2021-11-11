//
//  ReferralProgramCollectionView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/20/21.
//

import Foundation
import UIKit
import PhoneNumberKit

class ReferralProgramCollectionView : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let referralCollectionID = "referralCollectionID"
    
    var referralContactsContainer : ReferralContactsContainer?
    
    var selectionArray = [Int]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        
        self.isPrefetchingEnabled = false
        self.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        self.alwaysBounceVertical = true
        self.alwaysBounceHorizontal = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.canCancelContentTouches = false
        self.contentInsetAdjustmentBehavior = .never
        self.delaysContentTouches = true
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        self.automaticallyAdjustsScrollIndicatorInsets = true
        self.alpha = 0
        
        self.register(ReferralCollectionFeeder.self, forCellWithReuseIdentifier: self.referralCollectionID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.referralContactsContainer?.searchTextField.text != "" {
            return self.referralContactsContainer?.filteredContactsArray.count ?? 0
        } else {
            return self.referralContactsContainer?.contactsArray.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 93)
    }
    
    //MARK: - TODO - EDGE CASE SORTING AND NON EXISTING USERS INSERT AT SUBSET 0 AND ALL REMAINING USERS SUBSET AFTER THE INITIAL USE CASE.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.referralCollectionID, for: indexPath) as! ReferralCollectionFeeder
        
        cell.referralProgramCollectionView = self
        
        if let safeDataSource = self.referralContactsContainer?.contactsArray, let safeFilteredDataSource = self.referralContactsContainer?.filteredContactsArray {
            
            if safeDataSource.count > 0 {
                
                    cell.contentView.isUserInteractionEnabled = false

                    //RESET DATASOURCE ACCORDING TO THE SEARCH RESULTS
                    var feeder = safeDataSource[indexPath.item]
                    if self.referralContactsContainer?.searchTextField.text != "" {
                        feeder = safeFilteredDataSource[indexPath.item]
                    } else {
                        feeder = safeDataSource[indexPath.item]
                    }

                    //MARK: - SET THE VALUES
                    let user_first_name = feeder.familyName ?? "nil"
                    let user_last_name = feeder.givenName ?? "nil"
                    let phoneNumber = feeder.phoneNumber ?? "nil"
                    let _ = feeder.fullPhoneNumber ?? "nil"
                    let isCurrentDoggystyleUser = feeder.isCurrentDoggystyleUser ?? false

                    cell.nameLabel.text = "\(user_first_name) \(user_last_name)"
                    let phoneTrim = phoneNumber.suffix(4)
                    cell.phoneNumberLabel.text = "XXX-XXX-\(phoneTrim)"

                    //MARK: - RESETS THE USERS TAP DECISION
                    if !self.selectionArray.contains(indexPath.item) {
                        
                        cell.selectionButton.backgroundColor = .clear
                        cell.selectionButton.setTitle("", for: .normal)
                        
                    } else if self.selectionArray.contains(indexPath.item) {
                        
                        cell.selectionButton.backgroundColor = coreOrangeColor
                        cell.selectionButton.setTitle(String.fontAwesomeIcon(name: .check), for: .normal)
                        cell.selectionButton.setTitleColor(coreWhiteColor, for: .normal)
                        cell.selectionButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 12, style: .solid)
                        
                    }

                    if isCurrentDoggystyleUser == true {
                        cell.appLogoIcon.isHidden = false
                        cell.selectionButton.isHidden = true
                    } else {
                        cell.appLogoIcon.isHidden = true
                        cell.selectionButton.isHidden = false
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    @objc func handleSelection(sender : UIButton) {
        
        let selectedButtonCell = sender.superview as! UICollectionViewCell
        guard let indexPath = self.indexPath(for: selectedButtonCell) else {return}
        
        if !self.selectionArray.contains(indexPath.item) {
            
            if self.selectionArray.count >= 10  {return}
            
            self.selectionArray.append(indexPath.item)
            UIDevice.vibrateLight()
            
            if let safeDataSource = self.referralContactsContainer?.contactsArray, let safeFilteredDataSource = self.referralContactsContainer?.filteredContactsArray {
                
                //RESET DATASOURCE ACCORDING TO THE SEARCH RESULTS
                var feeder = safeDataSource[indexPath.item]
                if self.referralContactsContainer?.searchTextField.text != "" {
                    feeder = safeFilteredDataSource[indexPath.item]
                } else {
                    feeder = safeDataSource[indexPath.item]
                }
                
                let isDoggystyleUser = feeder.isCurrentDoggystyleUser ?? false

                if isDoggystyleUser == true {
                    UIDevice.vibrateHeavy()
                    return
                }
                
                let givenName = feeder.givenName ?? "nil",
                    familyName = feeder.familyName ?? "nil",
                    phoneNumber = feeder.phoneNumber ?? "nil",
                    fullPhoneNumber = feeder.fullPhoneNumber ?? "nil",
                    isCurrentDoggystyleUser = feeder.isCurrentDoggystyleUser ?? false
                
                let dic : [String : Any] = ["givenName" : givenName, "familyName" : familyName, "phoneNumber" : phoneNumber, "fullPhoneNumber" : fullPhoneNumber, "isCurrentDoggystyleUser" : isCurrentDoggystyleUser]
                let contact = ContactsList(json: dic)
                self.referralContactsContainer?.selectedContactsArray.append(contact)
            }
            
        } else if self.selectionArray.contains(indexPath.item) {
            if let index = self.selectionArray.firstIndex(of: indexPath.item) {
                self.selectionArray.remove(at: index)
                self.referralContactsContainer?.selectedContactsArray.remove(at: index)
            }
        }
        
        DispatchQueue.main.async {
            self.referralContactsContainer?.referButton.setTitle("Refer \(self.selectionArray.count) lucky dog owners", for: .normal)
            self.reloadItems(at: [indexPath])
        }
    }
    
    @objc func handleInfoLogoPopup(sender : UIButton) {
        self.referralContactsContainer?.handleCustomPopUpAlert(title: "CURRENT USER", message: "If you see the Doggystyle logo, that means your contact is already a Doggystyle customer!", passedButtons: [Statics.OK])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ReferralCollectionFeeder : UICollectionViewCell {
    
    var referralProgramCollectionView : ReferralProgramCollectionView?
    
    lazy var containerView : UIButton = {
        
        let cv = UIButton()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = coreWhiteColor
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 10
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        cv.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        cv.layer.shadowOpacity = 0.05
        cv.layer.shadowOffset = CGSize(width: 2, height: 3)
        cv.layer.shadowRadius = 9
        cv.layer.shouldRasterize = false
        cv.addTarget(self, action: #selector(self.handleSelectionButton(sender:)), for: .touchUpInside)
        
        return cv
        
    }()
    
    lazy var selectionButton : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.layer.borderColor = selectionGrey.cgColor
        cbf.layer.borderWidth = 3
        cbf.isUserInteractionEnabled = false
        cbf.backgroundColor = coreOrangeColor
        cbf.setTitle(String.fontAwesomeIcon(name: .check), for: .normal)
        return cbf
        
    }()
    
    let nameLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Loading..."
        thl.font = UIFont(name: rubikMedium, size: 16)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreBlackColor
        thl.isUserInteractionEnabled = false
        
        return thl
        
    }()
    
    let phoneNumberLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "(XXX) XXX-XXXX)"
        thl.font = UIFont(name: rubikRegular, size: 13)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = false
        thl.textColor = coreBlackColor
        thl.isUserInteractionEnabled = false
        
        return thl
        
    }()
    
    lazy var appLogoIcon : UIButton = {
        
        let dcl = UIButton(type : .system)
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = true
        let image = UIImage(named: "mini_app_logo")?.withRenderingMode(.alwaysOriginal)
        dcl.setImage(image, for: .normal)
        dcl.layer.masksToBounds = true
        dcl.layer.cornerRadius = 8
        dcl.isHidden = true
        dcl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleInfoLogoButton(sender:))))
        return dcl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.containerView)
        self.addSubview(self.selectionButton)
        
        self.containerView.addSubview(self.nameLabel)
        self.containerView.addSubview(self.phoneNumberLabel)
        self.containerView.addSubview(self.appLogoIcon)
        
        self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.containerView.heightAnchor.constraint(equalToConstant: 73).isActive = true
        self.containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        self.selectionButton.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 17).isActive = true
        self.selectionButton.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor, constant: 0).isActive = true
        self.selectionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.selectionButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.appLogoIcon.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor, constant: 0).isActive = true
        self.appLogoIcon.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -20).isActive = true
        self.appLogoIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.appLogoIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.nameLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor, constant: -10).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.selectionButton.rightAnchor, constant: 16).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.appLogoIcon.leftAnchor, constant: -15).isActive = true
        self.nameLabel.sizeToFit()
        
        self.phoneNumberLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor, constant: 10).isActive = true
        self.phoneNumberLabel.leftAnchor.constraint(equalTo: self.selectionButton.rightAnchor, constant: 16).isActive = true
        self.phoneNumberLabel.rightAnchor.constraint(equalTo: self.appLogoIcon.leftAnchor, constant: -15).isActive = true
        self.phoneNumberLabel.sizeToFit()
        
    }
    
    @objc func handleSelectionButton(sender : UIButton) {
        self.referralProgramCollectionView?.handleSelection(sender: sender)
    }
    
    @objc func handleInfoLogoButton(sender : UIButton) {
        self.referralProgramCollectionView?.handleInfoLogoPopup(sender : sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
