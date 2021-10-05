//
//  RegisteredPetCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/1/21.
//

import Foundation
import UIKit
import Firebase

class RegisteredPetCollection : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let petID = "petID"
    
    var dashMainView : DashMainView?
    
    var doggyProfileDataSource = [DoggyProfileDataSource]()
    let databaseRef = Database.database().reference()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        
        self.isPrefetchingEnabled = false
        self.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        self.alwaysBounceVertical = false
        self.alwaysBounceHorizontal = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.canCancelContentTouches = false
        self.contentInsetAdjustmentBehavior = .never
        self.delaysContentTouches = true
        self.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        self.register(PetCollectionFeeder.self, forCellWithReuseIdentifier: self.petID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return doggyProfileDataSource.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.petID, for: indexPath) as! PetCollectionFeeder
        
        cell.registeredPetCollection = self
        
        let lastIndex = self.doggyProfileDataSource.count - 1
        
        switch indexPath.item {
        
        case lastIndex:
            
            let image = UIImage(named: "add_dog_logo_image")?.withRenderingMode(.alwaysOriginal)
            cell.addDogImage.image = image
            cell.nameLabel.text = "Add"
            cell.nameLabel.font = UIFont(name: dsHeaderFont, size: 16)
            cell.nameLabel.textColor = coreOrangeColor
            
        default:
            
            let feeder = self.doggyProfileDataSource[indexPath.item + 1]
            let profileImage = feeder.dog_builder_profile_url ?? "nil"
            let dogsName = feeder.dog_builder_name ?? ""
            cell.nameLabel.text = dogsName
            cell.nameLabel.font = UIFont(name: dsHeaderFont, size: 16)
            cell.nameLabel.textColor = coreBlackColor
            
            cell.addDogImage.loadImageGeneralUse(profileImage) { isComplete in
                print("image loaded")
            }
        }
        
        return cell
    }
    
    @objc func handleAddDog(sender : UIImageView) {
        
        let selectedButtonCell = sender.superview as! UICollectionViewCell
        guard let indexPath = self.indexPath(for: selectedButtonCell) else {return}
        
        let lastIndex = self.doggyProfileDataSource.count - 1
        
        switch indexPath.item {
        
        case lastIndex :
            
            self.dashMainView?.dashboardController?.handleNewDogFlow()
            
        default:
            
            let _ = self.doggyProfileDataSource[indexPath.item + 1]
            
        //self.removeDoggyProfileAlert(passedDogName: dogName, refKey: refKey, parentKey: parentKey, userUID: user_uid)
        }
    }
    
    func removeDoggyProfileAlert(passedDogName : String, refKey : String, parentKey : String, userUID : String) {
        
        let alertController = UIAlertController(title: "Remove", message: "Would you like to remove \(passedDogName)?", preferredStyle: .actionSheet)
        
        let actionOne = UIAlertAction(title: "Ok", style: .default) { res in
            self.removeDogProfile(passedDogName: passedDogName, refKey: refKey, parentKey: parentKey, userUID: userUID)
        }
        
        let actionTwo = UIAlertAction(title: "Cancel", style: .destructive) { res in
            
        }
        
        alertController.addAction(actionOne)
        alertController.addAction(actionTwo)
        
        self.dashMainView?.dashboardController?.present(alertController, animated: true, completion: nil)
        
    }
    
    func removeDogProfile(passedDogName : String, refKey : String, parentKey : String, userUID : String) {
        
        let path = self.databaseRef.child("doggy_profile_builder").child(userUID).child(refKey)
        
        path.removeValue { error, ref in
            
            if error != nil {
                print("ERROR: ", error?.localizedDescription as Any)
                return
            }
            print("Success")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PetCollectionFeeder : UICollectionViewCell {
    
    var registeredPetCollection : RegisteredPetCollection?
    
    lazy var addDogImage : UIImageView = {
        
        let vi = UIImageView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFill
        vi.isUserInteractionEnabled = true
        let image = UIImage(named: "add_dog_logo_image")?.withRenderingMode(.alwaysOriginal)
        vi.image = image
        vi.layer.masksToBounds = true
        vi.layer.cornerRadius = 40
        vi.backgroundColor = coreOrangeColor.withAlphaComponent(0.1)
        vi.layer.borderWidth = 2
        vi.layer.borderColor = coreWhiteColor.cgColor
        vi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleAddDog(sender:))))
        
        return vi
    }()
    
    let nameLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Add"
        hl.font = UIFont(name: dsHeaderFont, size: 16)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .center
        hl.textColor = coreOrangeColor
        
        return hl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.addDogImage)
        self.addSubview(self.nameLabel)
        
        self.addDogImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.addDogImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        self.addDogImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.addDogImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.nameLabel.topAnchor.constraint(equalTo: self.addDogImage.bottomAnchor, constant: 0).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
    }
    
    @objc func handleAddDog(sender : UITapGestureRecognizer) {
        
        if let tappableArea = sender.view as? UIImageView {
            
            self.registeredPetCollection?.handleAddDog(sender:tappableArea)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
