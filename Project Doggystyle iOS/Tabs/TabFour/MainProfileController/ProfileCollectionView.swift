//
//  ProfileCollectionView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/2/21.
//

import Foundation
import UIKit

class ProfileCollectionSubview : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private let profileID = "profileID", arrayOfStaticLabels = ["My dogs","Payment Methods", "Notifications", "Contact Us", "Re-fur a Doggy"]
    
    var profileController : ProfileController?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
        self.dataSource = self
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.alwaysBounceVertical = true
        self.register(ProfileFeeder.self, forCellWithReuseIdentifier: self.profileID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 1.15, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayOfStaticLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.profileID, for: indexPath) as! ProfileFeeder
        
        let feederLabels = self.arrayOfStaticLabels[indexPath.item]
        
        cell.profileCollectionSubview = self
        cell.feederLabel.text = feederLabels
        
        switch feederLabels {
        
        case "My dogs" :
            cell.feederIcon.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
            cell.feederIcon.text = String.fontAwesomeIcon(name: .dog)
            cell.feederIcon.textColor = coreOrangeColor
        case "Payment Methods" :
            cell.feederIcon.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
            cell.feederIcon.text = String.fontAwesomeIcon(name: .dollarSign)
            cell.feederIcon.textColor = coreOrangeColor
        case "Contact Us" :
            cell.feederIcon.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
            cell.feederIcon.text = String.fontAwesomeIcon(name: .comment)
            cell.feederIcon.textColor = coreOrangeColor
        case "Notifications" :
            cell.feederIcon.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
            cell.feederIcon.text = String.fontAwesomeIcon(name: .bell)
            cell.feederIcon.textColor = coreOrangeColor
        case "Re-fur a Doggy" :
            cell.feederIcon.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
            cell.feederIcon.text = String.fontAwesomeIcon(name: .gift)
            cell.feederIcon.textColor = coreOrangeColor
        default:print("never hit this")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    @objc func handleSelection(sender: UIButton) {
        
        let selectedButtonCell = sender.superview as! UICollectionViewCell
        guard let indexPath = self.indexPath(for: selectedButtonCell) else {return}
        
        let feederLabels = self.arrayOfStaticLabels[indexPath.item]
        
        switch feederLabels {
        
        case "My dogs" : self.profileController?.handleAddDogController()
        case "Payment Methods" : print("Payment")
        case "Notifications" : print("Notifications")
        case "Contact Us" : print("Contact Us")
        case "Re-fur a Doggy" : self.profileController?.handleRefurFriend()

        default : print("Button not found, add it to the array")
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
