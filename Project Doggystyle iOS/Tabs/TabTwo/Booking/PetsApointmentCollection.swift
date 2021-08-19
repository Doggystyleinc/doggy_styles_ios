//
//  PetsApointmentCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/19/21.
//


import Foundation
import UIKit
import Firebase

class PetAppointmentsCollection : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let petAptID = "petAptID"
    
    var appointmentOne : AppointmentOne?

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
        
        self.register(PetAppointmentsFeeder.self, forCellWithReuseIdentifier: self.petAptID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return doggyProfileDataSource.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.petAptID, for: indexPath) as! PetAppointmentsFeeder
        
        cell.petAppointmentsCollection = self
        
        let firstIndex = 0
        
        switch indexPath.item {
        
        case firstIndex:
            
            cell.addDogImage.setImage(UIImage(), for: .normal)
            
            cell.addDogImage.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
            cell.addDogImage.setTitle(String.fontAwesomeIcon(name: .dog), for: .normal)
            
            cell.nameLabel.text = "All"
            cell.nameLabel.font = UIFont(name: dsHeaderFont, size: 16)
            cell.nameLabel.textColor = coreOrangeColor
            
        default:
            
            let feeder = self.doggyProfileDataSource[indexPath.item]
            let profileImage = feeder.dog_builder_profile_url ?? "nil"
            let dogsName = feeder.dog_builder_name ?? ""
            
            cell.nameLabel.text = dogsName
            cell.nameLabel.font = UIFont(name: dsHeaderFont, size: 16)
            cell.nameLabel.textColor = coreBlackColor

            let imageView = UIImageView()
            imageView.loadImageGeneralUse(profileImage) { complete in
                cell.addDogImage.setImage(imageView.image, for: .normal)
            }
        }
        
        return cell
    }
    
    @objc func handleAddDog(sender : UIButton) {
        
        let selectedButtonCell = sender.superview as! UICollectionViewCell
        guard let indexPath = self.indexPath(for: selectedButtonCell) else {return}
        print(indexPath)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PetAppointmentsFeeder : UICollectionViewCell {
    
    var petAppointmentsCollection : PetAppointmentsCollection?
    
    lazy var addDogImage : UIButton = {
        
        let vi = UIButton()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFill
        vi.isUserInteractionEnabled = true
        vi.layer.masksToBounds = true
        vi.layer.cornerRadius = 40
        vi.backgroundColor = coreOrangeColor
        vi.tintColor = coreWhiteColor
        vi.layer.borderWidth = 1
        vi.layer.borderColor = coreOrangeColor.cgColor
        vi.addTarget(self, action: #selector(self.handleAddDog(sender:)), for: .touchUpInside)
        
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
    
    @objc func handleAddDog(sender : UIButton) {
        self.petAppointmentsCollection?.handleAddDog(sender: sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
