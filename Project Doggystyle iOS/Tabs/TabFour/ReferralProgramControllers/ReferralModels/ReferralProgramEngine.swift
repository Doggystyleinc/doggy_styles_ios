//
//  ReferralProgramEngine.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/21/21.
//

import Foundation
import Contacts
import UIKit

extension ReferralContactsContainer {
    
    func runDataEngine() {
        
        self.activityIndicator.startAnimating()
        self.referralProgramCollectionView.alpha = 0
        self.referButton.alpha = 0
        
        self.view.isUserInteractionEnabled = false
        
        self.grabAllContacts { complete, error in
            
            if complete == "complete" {
                
                let contactsPhoneNumberArray = self.arrayOfPhoneNumbers
                
                self.compareNumbersAgainstDatabase(passedPhoneNumberArray: contactsPhoneNumberArray) { completion in
                    
                    DispatchQueue.main.async {
                        self.referralProgramCollectionView.reloadData()
                    }
                    
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    UIView.animate(withDuration: 0.35) {
                        self.referralProgramCollectionView.alpha = 1
                        self.referButton.alpha = 1
                    }
                }
                
            } else {
                self.handleCustomPopUpAlert(title: "CONTACTS", message: "We are unable to gain access to your device’s contacts. We have been alerted of the issue and will have a fix available shortly.", passedButtons: [Statics.GOT_IT])
            }
        }
    }
    
    func compareNumbersAgainstDatabase(passedPhoneNumberArray : [String], completion : @escaping (_ isComplete : Bool)->()) {
        
        var counter : Int = 0
        
        let ref = self.databaseRef.child("all_users")
        
        ref.observeSingleEvent(of: .value) { snap in
            
            let childrenCount = Int(snap.childrenCount)
            
            if snap.exists() {
                
                self.observingRefOne = self.databaseRef.child("all_users")
                
                self.handleOne = self.observingRefOne.observe(.childAdded, with: { snapLoop in
                    
                    if let JSON = snapLoop.value as? [String:Any] {
                        
                        let users_phone_number = JSON["users_phone_number"] as? String ?? "nil"
                        
                        var arrayReplica = self.contactsArray
                        
                        for i in 0..<arrayReplica.count {
                            
                            print("hits here")
                            let fetchedPhoneNumber = arrayReplica[i].phoneNumber
                            
                            if fetchedPhoneNumber == users_phone_number {
                                arrayReplica[i].isCurrentDoggystyleUser = true
                                counter += 1
                                
                                if childrenCount == counter {
                                    
                                    self.observingRefOne.removeObserver(withHandle: self.handleOne)
                                    completion(true)
                                }
                            } else {
                                arrayReplica[i].isCurrentDoggystyleUser = false
                                counter += 1
                                
                                if childrenCount == counter {
                                    
                                    self.observingRefOne.removeObserver(withHandle: self.handleOne)
                                    completion(true)
                                }
                            }
                        }
                        
                    } else {
                        self.handleBackButton()
                    }
                })
                
            } else {
                self.handleBackButton()
            }
        }
    }
    
    func grabAllContacts(completion : @escaping (_ finished : String, _ error : Any?) -> ()) {
        
        let store = CNContactStore()
        
        let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
        
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        do {
            
            try store.enumerateContacts(with: request) { (contact, unsafePointer) in
                
                if contact.phoneNumbers.first?.value.stringValue != "" {
                    
                    if contact.phoneNumbers.first?.value.stringValue != nil {
                        
                        if contact.givenName.count > 0 {
                            
                            let unsafeChars = CharacterSet.alphanumerics.inverted
                            
                            let cleanChars = contact.phoneNumbers.first?.value.stringValue.components(separatedBy: unsafeChars).joined(separator: "")
                            
                            guard let cleanNumbers = cleanChars else {return}
                            
                            if cleanNumbers.count < 8 {return}
                            
                            let last8 = String(cleanNumbers.suffix(8))
                            
                            let dic : [String : Any] = ["givenName" : contact.givenName, "familyName" : contact.familyName, "phoneNumber" : last8, "fullPhoneNumber" : cleanNumbers]
                            
                            let feed = ContactsList(json: dic)
                            
                            if let number = feed.phoneNumber {
                                
                                if number.count >= 7 {
                                    
                                    if !self.collectedPhoneNumbers.contains(number) {
                                        self.contactsArray.append(feed)
                                    }
                                    
                                    if !self.collectedPhoneNumbers.contains(number) {
                                        self.collectedPhoneNumbers.append(number)
                                    }
                                    
                                    self.contactsArray.sort(by: { (nameOne, nameTwo) -> Bool in
                                        
                                        if let one = nameOne.givenName {
                                            if let two = nameTwo.givenName {
                                                return one < two
                                            }
                                        }
                                        return false
                                    })
                                    
                                    let trimmed = number.numbers
                                    self.arrayOfPhoneNumbers.append(trimmed)
                                }
                            }
                        }
                    }
                }
            }
            
            completion("complete", nil)
            
        } catch let err {
            completion("error", err)
        }
    }
}
